class CreateCampaignPrincipals < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_principals, comment: 'キャンペーンPRN' do |t|
      t.references  :campaign,    null: false,  comment: 'キャンペーンID'
      t.string      :princiapal,  null: false,  comment: 'リソース名'

      t.timestamps
    end
    add_foreign_key :campaign_principals, :campaigns
    add_index :campaign_principals, %i[campaign_id princiapal], unique: true
  end
end
