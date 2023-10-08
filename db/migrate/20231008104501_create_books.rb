class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :authors, array: true, default: []
      t.string :publisher
      t.date :published_date
      t.text :description
      t.jsonb :image_links, default: {}
      t.string :category
      t.string :preview_link

      t.timestamps
    end
  end
end
