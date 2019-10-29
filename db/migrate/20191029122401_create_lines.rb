class CreateLines < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.primary_key :id
      t.integer :char_no
      t.string :content
      t.string :line
      t.binary :post_flag

      t.timestamps
    end
  end
end
