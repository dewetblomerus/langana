class WorkReferenceRenameEmployer < ActiveRecord::Migration
  def change
    rename_column :work_references, :employer_user_id, :employer_id
  end
end
