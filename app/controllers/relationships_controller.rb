class RelationshipsController < ApplicationController

  before_action :set_project, only: [:index]

  def index
    # @project_to_users = call_api(users_project_has())
    # @project_to_users.each do |u|
    #   Relationship.create(project_id: params[:project_id], user_id: u[:user][:id], roles: u[:roles][0][:name])
    # end
    # byebug
    @users = Relationship.where(project_id: params[:id]).joins(:user).select("users.*, relationships.*")
  end

  private

    def set_project
    end

end
