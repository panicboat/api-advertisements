class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets, comment: '予算' do |t|
      t.references  :product, null: false,  comment: 'プロダクトID'
      t.string      :label,     null: true,   comment: 'ラベル'
      t.datetime    :start_at,  null: false,  comment: '開始日時'
      t.datetime    :end_at,    null: false,  comment: '終了日時'
      t.integer     :amount,    null: false,  comment: '金額'
      t.integer     :status,    null: false,  comment: 'ステータス', limit: 3

      t.timestamps
    end
  end
end
