class RelationshipsController < ApplicationController


  def index
    @project_to_users = call_api(users_project_has())
    @project_to_users.each do |u|
      Relationship.create(project_id: params[:project_id], user_id: u[:user][:id], roles: u[:roles][0][:name])
    end
    @users = Relationship.where(project_id: params[:project_id]).joins(:user).select("users.*, relationships.*")
  end





end
