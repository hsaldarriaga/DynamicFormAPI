class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.integer :procedure_id
      t.integer :group_id
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
