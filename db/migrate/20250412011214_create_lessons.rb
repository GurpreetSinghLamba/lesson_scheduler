class CreateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :lessons do |t|
      t.string :subject
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status, null: false, default: 0
      t.references :teacher, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
