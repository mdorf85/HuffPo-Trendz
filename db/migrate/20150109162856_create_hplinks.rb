class CreateHplinks < ActiveRecord::Migration
  def change
    create_table :hplinks do |t|
      t.string :section
      t.string :title
      t.string :url

      t.timestamps null: false
    end
  end
end
