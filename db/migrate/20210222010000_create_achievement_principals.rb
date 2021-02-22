class CreateAchievementPrincipals < ActiveRecord::Migration[6.0]
  def change
    create_table :achievement_principals, comment: '単価PRN' do |t|
      t.references  :achievement,         null: false,  comment: '単価ID'
      t.references  :campaign_principal,  null: false,  comment: 'キャンペーンPRN'

      t.timestamps
    end
    add_foreign_key :achievement_principals, :campaign_principals
    add_foreign_key :achievement_principals, :achievements
    add_index :achievement_principals, %i[achievement_id campaign_principal_id], unique: true, name: 'index_achievement_principals_unique'
  end
end
