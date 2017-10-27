class CreateColumns < ActiveRecord::Migration[5.1]
  def change
    create_table :columns do |t|
      t.string :title
      t.references :board, foreign_key: true

      t.timestamps
    end
  end
end
