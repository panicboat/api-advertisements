class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products, comment: 'プロダクト' do |t|
      t.references  :advertiser,  null: false,  comment: '広告主ID'
      t.string      :name,        null: false,  comment: '名前'
      t.string      :url,         null: false,  comment: 'URL'
      t.string      :note,        null: true,   comment: '備考'

      t.timestamps
    end
    add_foreign_key :products, :advertisers
    add_index :products, [:url], unique: true
  end
end
