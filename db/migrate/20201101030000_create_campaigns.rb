class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns, comment: 'キャンペーン' do |t|
      t.references  :product,   null: false,  comment: 'プロダクトID'
      t.integer     :platform,  null: false,  comment: 'プラットフォーム', limit: 3
      t.string      :store_url, null: false,  comment: 'ストアURL'
      t.integer     :status,    null: false,  comment: 'ステータス', limit: 3
      t.string      :note,      null: true,   comment: '備考'

      t.timestamps
    end
    add_foreign_key :campaigns, :products
    add_index :campaigns, %i[product_id store_url], unique: true
  end
end
