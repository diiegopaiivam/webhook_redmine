module Api 
  module V1
    class ProjectsController < ApplicationController
      def create
        @project = Project.new(set_params)  
        if @project.save
          Project.save_project_redmine(params)
          render json: @project.aliased, status: :created
        else
          render json: { error: @project.errors }, status: :unprocessable_entity
        end
      end

      private 
        # Only allow a trusted parameter "white list" through.
        def set_params
          params.require(:project).permit(:name, :identifier, :description, :is_public, :inherit_members, :tracker_ids)
        end
    end 
  end
end
