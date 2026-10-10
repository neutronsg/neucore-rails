# frozen_string_literal: true

require "test_helper"
require "neucore"

class AmisUiCrudTest < Minitest::Test
  include Neucore::Helpers::AmisUi::Crud

  def test_string_column_does_not_set_a_default_width
    schema = amis_string_column(name: "name")

    refute schema.key?(:width)
  end

  def test_popover_string_column_defaults_to_a_bounded_width
    schema = amis_string_column(name: "description", popOver: true)

    assert_equal 300, schema[:width]
    assert_equal "ellipsis", schema[:textOverflow]
  end

  def test_popover_string_column_preserves_an_explicit_width
    schema = amis_string_column(name: "description", popOver: true, width: 500)

    assert_equal 500, schema[:width]
  end
end
