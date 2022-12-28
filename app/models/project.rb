class Project < ApplicationRecord

    validates :name, :identifier, :description, :is_public, :inherit_members, presence: true

    def self.save_project_redmine(params)
        RedmineService.init_project(params)
    end 

    def aliased
        {
            id: id,
            name: name,
            identifier: identifier,
            description: description,
            criado_em: created_at,
            atualizado_em: updated_at
        }
    end

    


end



