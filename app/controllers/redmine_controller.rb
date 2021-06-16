class RedmineController < ApplicationController

  before_action :set_project, except: [:index]
  before_action :set_issues, except: [:index]
  before_action :should_redirect_if_no_issue, only: [:show]

  
  def index
    within_year = today - 365
    #1年以上前のプロジェクト
    latest_update = Issue.group(:project_id).maximum(:updated)
    project_ids_by_latest_update = latest_update.map do |key, value|
      if value.to_date < within_year
        key
      end 
    end
    #完了したプロジェクト
    complete =  Project.where(status: 5)
    project_ids_by_complete = complete.map do |p|
      p[:project_id]
    end 
    #Laplaceに載せないプロジェクトたち
    hide_project_ids = project_ids_by_latest_update.compact.push(project_ids_by_complete).flatten.uniq
    @show_projects = Project.where.not(project_id: hide_project_ids)
    @projects = Project.all
  end

  def update
    if @project.update(project_params)
      redirect_to("/projects/#{params[:project_id]}")
    end
  end

  def create
    if params[:cost].present?
      OutsourcingCost.create(project_id: params[:project_id], cost: params[:cost], name: params[:name], description: params[:description])
    end
    redirect_to("/projects/#{params[:project_id]}")
  end

  def delete_outsourcing
    outsourcing_cost = OutsourcingCost.find(params[:id]).destroy
    redirect_to("/projects/#{outsourcing_cost.project_id}")
  end

  def edit
  end

  def versions_update
    if Version.find_by(id: params[:version]).update(qc_checked: params[:qc_checked])
      redirect_to("/projects/#{params[:project_id]}")
    end
  end

  def show    
    @total_ac = @issues.time_entries.sum(:hours)
    @total_pv = @issues.sum(:estimate_hours)
    @total_ev = @issues.done.sum(:estimate_hours)
    @remaining_working_time = @issues.not_done.sum(:estimate_hours)
    @outsourcing_info = @project.outsourcing_costs
    @users_worktime = @issues.time_entries_join_users.sum(:hours)
    @versions = @project.versions
    set_velocity
    set_project_info if @project.sales.present?
    set_gon
  end

  def test
  end

  private

    def set_project
      @project = Project.find_by(project_id: params[:project_id])
    end

    def set_issues
      @issues = @project.issues
    end

    def set_gon
      gon.daily_ac = @issues.time_entries.group("time_entries.spent_on").sum(:hours)
      gon.daily_pv = @issues.group(:start_date).sum(:estimate_hours)
      gon.daily_ev = @issues.done.group(:start_date).sum(:estimate_hours)
      gon.week_beginning = @project.created.sunday - 7
      gon.month_beginning = @project.created.beginning_of_month
      gon.project_name = @project.project_name
      gon.cost = @project.sales ? @project.sales : 0
      gon.planned_cost = @project.planned_cost ? @project.planned_cost : 0
    end

    def set_velocity
      this_week_ac = @issues.done_between_today_7days.time_entries.sum(:hours)
      this_week_pv = @issues.done_between_today_7days.sum(:estimate_hours)
      last_week_ac = @issues.done_between_7days_14days.time_entries.sum(:hours)
      last_week_pv = @issues.done_between_7days_14days.sum(:estimate_hours)
      two_weeks_ago_ac = @issues.done_between_14days_21days.time_entries.sum(:hours)
      two_weeks_ago_pv = @issues.done_between_14days_21days.sum(:estimate_hours)
      @this_week_velocity = this_week_ac != 0 ? this_week_pv/this_week_ac : ""
      @last_week_velocity = last_week_ac != 0 ? last_week_pv/last_week_ac : ""
      @two_weeks_ago_velocity = two_weeks_ago_ac != 0 ? two_weeks_ago_pv/two_weeks_ago_ac : ""
    end

    def set_project_info
      # 外注費合計
      @outsourcing_cost_sum = @project.outsourcing_costs.sum(:cost).to_i
      # 予想利益
      @estimated_profits = @project.sales.to_i - @project.planned_cost.to_i - @outsourcing_cost_sum
      # 実利益
      @net_income = @project.sales.to_i - @total_cost - @outsourcing_cost_sum
      # 利益率
      @profit_rate = ((@project.sales - @outsourcing_cost_sum) / @total_cost * 100).round(1)
      # 評価値
      @grade = case @profit_rate
      when @profit_rate > 50
        "プラチナ"
      when @profit_rate > 30
        "ゴールド"
      when @profit_rate > 20
        "シルバー"
      when @profit_rate > 10 # documentは (収益率)>10 と定義
        "ブロンズ"
      when @profit_rate > 0
        "ストーン"
      else
        "F"
      end
      @project.update(grade: @grade)
    end

    def today
      Date.today
    end

    #1年以上前に作成されたプロジェクトかつissueがないプロジェクトはIssueテーブルのupdated_onに3年前の時間を入れ、プロジェクト一覧から除外する
    def should_redirect_if_no_issue
      if @issues.blank? && @project.created < today - 365
        @issues.updated = today.ago(3.years)
        @issues.save
        redirect_to projects_path
      end
    end

    def project_params
      params.require(:project).permit(:planned_cost, :sales, :leader_name)
    end

    def outsourcing_costs_params
      params.require(:outsourcing_cost).permit(:cost, :name, :description)
    end

end
