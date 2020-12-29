require 'test_helper'

module Budgets
  class ShowTest < ActionDispatch::IntegrationTest
    fixtures :budgets

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { product_id: budgets(:budget1).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 100_000 }
    end

    def expected_attrs
      { product_id: budgets(:budget1).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 100_000 }
    end

    test 'Show Data' do
      ctx = Operation::Show.call(params: { id: budgets(:budget1).id }, current_user: @current_user)
      assert_equal ctx[:model].end_at, budgets(:budget1).end_at
    end

    test 'Show No Data' do
      e = assert_raises InvalidParameters do
        Operation::Show.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
