module Api 
  module V1
    class ProjectsController < ApplicationController
      def create
        @project = Project.new(@project_params)
        Project.save_project_redmine(params)
        if @project.save
          render json: @project.aliased, status: :created
        else
          render json: { error: @project.errors }, status: :unprocessable_entity
        end
      end

      private 
        # Only allow a trusted parameter "white list" through.
        def set_params
          @project_params = params.permit(:name, :identifier, :description, :is_public, :inherit_members, :tracker_ids)
        end
    end 
  end
end
