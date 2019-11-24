class CreateLines < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
     / t.primary_key :id /
      t.integer :char_no, :null => false
      t.string :content, :null => false
      t.string :line, :null => false
      t.binary :post_flag, :default => 0
      t.timestamps
    end
  end
end
