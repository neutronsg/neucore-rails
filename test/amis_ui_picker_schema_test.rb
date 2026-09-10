# frozen_string_literal: true

require "test_helper"
require "neucore"

class AmisUiPickerSchemaTest < Minitest::Test
  include Neucore::Helpers::AmisUi::Form
  include Neucore::Helpers::AmisUi::Filter

  def test_date_defaults_to_human_readable_display_format
    schema = amis_form_date

    assert_equal "DD MMM YYYY", schema[:displayFormat]
    assert_equal "YYYY-MM-DD", schema[:valueFormat]
  end

  def test_datetime_defaults_to_human_readable_display_format
    schema = amis_form_datetime

    assert_equal "DD MMM YYYY, hh:mm A", schema[:displayFormat]
    assert_equal "YYYY-MM-DD HH:mm:ss", schema[:valueFormat]
  end

  def test_daterange_filter_keeps_ransack_machine_format
    schema = amis_daterange_filter(name: "created_at")

    assert_equal "DD MMM YYYY", schema[:displayFormat]
    assert_equal "YYYYMMDD", schema[:valueFormat]
    assert_equal "to", schema[:delimiter]
  end
end
