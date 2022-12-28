class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :identifier
      t.text :description
      t.boolean :is_public
      t.boolean :inherit_members
      t.string :trackers_ids
      t.string :enabled_module_names

      t.timestamps
    end
  end
end
