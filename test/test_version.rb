# frozen_string_literal: true

require "test_helper"

class TestVersion < Minitest::Test
  def test_version
    assert_equal "0.1.0", Neucore::VERSION
  end
end
