class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :step_id
      t.integer :procedure_id
      t.string :content

      t.timestamps null: false
    end
  end
end
