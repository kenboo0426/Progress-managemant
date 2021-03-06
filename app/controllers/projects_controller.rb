class ProjectsController < ApplicationController

  before_action :set_project, except: [:index]
  before_action :set_issues, except: [:index]
  before_action :should_redirect_if_no_issue, only: [:show]
  before_action :set_outsourcing, only: [:update_outsourcing, :delete_outsourcing]

  
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
      redirect_to project_path
    end
  end

  def create_outsourcing
    flash[:notice] = OutsourcingCost.create(create_outsourcing_params) ? "作成しました" : "作成できませんでした"
    redirect_to project_path
  end

  def update_outsourcing
    flash[:notice] = @outsourcing.update(update_outsourcing_params) ? "更新しました" : "更新できませんでした"
    redirect_to project_path
  end

  def delete_outsourcing
    flash[:notice] = @outsourcing.destroy ? "削除しました" : "削除できませんでした"
    redirect_to project_path
  end

  def edit
  end

  def versions_update
    if Version.find_by(id: params[:version]).update(qc_checked: params[:qc_checked])
      redirect_to project_path
    end
  end

  def show    
    @total_ac = @issues.time_entries.sum(:hours)
    @total_pv = @issues.sum(:estimate_hours)
    @total_ev = @issues.done.sum(:estimate_hours)
    @active_days = @issues.order(:updated).last.updated - @project.created
    @remaining_working_time = @issues.not_done.sum(:estimate_hours)
    @outsourcing_info = @project.outsourcing_costs
    @users_worktime = @issues.time_entries_join_users.sum(:hours)
    @versions = @project.versions
    set_velocity
    set_project_info
    set_gon
  end

  def users
    @users_relation = @project.relationships.preload(:user)
  end

  def test
  end

  private

    def set_project
      @project ||= Project.find_by(project_id: params[:id])
    end

    def set_issues
      @issues ||= @project.issues
    end

    def set_gon
      gon.active_days = @active_days.to_i
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
      # 従業員コスト
      daily_cost = @issues.daily_cost.sum(:hours)
      employee_cost = 0
      daily_cost = daily_cost.map do |key, value|
        if key[0]
          employee_cost += (key[0] * value)/10000
          [key[1], (key[0] * value)/10000]
        end
      end
      gon.daily_cost = daily_cost.compact.to_h
      set_project_info_with_sales?(employee_cost) if @project.sales.present?
    end

    def set_project_info_with_sales?(employee_cost)
      # 予想利益
      @estimated_profits = @project.sales.to_i - @project.planned_cost.to_i - @outsourcing_cost_sum
      # 実利益
      @net_income = @project.sales.to_i - employee_cost - @outsourcing_cost_sum
      # 利益率
      @profit_rate = (@net_income / @project.sales * 100).round(1)
      # 評価値
      @grade = case @profit_rate
      when 50..100
        "プラチナ"
      when 30..49
        "ゴールド"
      when 20..29
        "シルバー"
      when 10..19 # documentは (収益率)>10 と定義
        "ブロンズ"
      when 0..9
        "ストーン"
      else
        "F"
      end
      @project.update(grade: @grade)
    end

    def set_outsourcing
      @outsourcing = OutsourcingCost.find_by(id: params[:outsourcing_cost][:id])
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

    def update_outsourcing_params
      params.require(:outsourcing_cost).permit(:name, :cost, :description)
    end

    def create_outsourcing_params
      params.permit(:project_id, :name, :cost, :description)
    end

end
