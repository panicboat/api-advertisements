class CreateBanners < ActiveRecord::Migration[6.0]
  def change
    create_table :banners, comment: 'バナー' do |t|
      t.references  :product, null: false,  comment: 'プロダクトID'
      t.integer     :type,    null: false,  comment: 'バナー種別', limit: 3
      t.string      :label,   null: true,   comment: 'ラベル'
      t.integer     :status,  null: false,  comment: 'ステータス', limit: 3

      t.timestamps
    end
    add_foreign_key :banners, :products
  end
end
