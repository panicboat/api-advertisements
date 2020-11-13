class CreateBudgetDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :budget_details, comment: '予算詳細' do |t|
      t.references  :budget,    null: false,  comment: '予算ID'
      t.references  :campaign,  null: false,  comment: 'キャンペーンID'
      t.integer     :amount,    null: false,  comment: '金額'

      t.timestamps
    end
    add_foreign_key :budget_details, :budgets
    add_foreign_key :budget_details, :campaigns
  end
end
