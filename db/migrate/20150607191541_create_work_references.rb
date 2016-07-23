class CreateWorkReferences < ActiveRecord::Migration
  def change
    create_table :work_references do |t|
      t.references :employer_user, index: true
      t.references :worker_user, index: true
      t.string :work
      t.text :comment
      t.integer :rating
      t.boolean :recommend

      t.timestamps null: false
    end
    # add_foreign_key :work_references, :users, column: :employer_user_id, on_delete: :cascade
    # add_foreign_key :work_references, :users, column: :worker_user_id, on_delete: :cascade
  end
end
