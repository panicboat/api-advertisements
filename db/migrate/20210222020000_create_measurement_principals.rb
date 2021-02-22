class CreateMeasurementPrincipals < ActiveRecord::Migration[6.0]
  def change
    create_table :measurement_principals, comment: '計測PRN' do |t|
      t.references  :measurement,         null: false,  comment: '計測ID'
      t.references  :campaign_principal,  null: false,  comment: 'キャンペーンPRN'

      t.timestamps
    end
    add_foreign_key :measurement_principals, :campaign_principals
    add_foreign_key :measurement_principals, :measurements
    add_index :measurement_principals, %i[measurement_id campaign_principal_id], unique: true, name: 'index_measurement_principals_unique'
  end
end
