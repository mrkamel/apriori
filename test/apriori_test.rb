
require File.expand_path("../../lib/apriori", __FILE__)
require "test/unit"

class AprioriTest < Test::Unit::TestCase
  def test_rules
    calculated_rules = []

    Apriori.rules([["beer", "cheese"],["beer", "mr.tom"], ["beer", "cheese"]]) do |rule|
      calculated_rules.push rule
    end

    expected_rules = [{ :destination => ["beer"], :source => ["mr.tom"], :support => 25.0, :confidence => 100.0 },
      { :destination => ["mr.tom"], :source => ["beer"], :support => 25.0, :confidence => 33.3333 },
      { :destination => ["beer"], :source => ["cheese"], :support => 50.0, :confidence => 100.0 },
      { :destination => ["cheese"], :source => ["beer"], :support => 50.0, :confidence => 66.6667 }]

    assert_equal expected_rules, calculated_rules
  end

  def test_rules_with_separator
    calculated_rules = []

    Apriori.rules(["beer,cheese", "beer,mr.tom", "beer,cheese"], :separator => /\s*,\s*/) do |rule|
      calculated_rules.push rule
    end

    expected_rules = [{ :destination => ["beer"], :source => ["mr.tom"], :support => 25.0, :confidence => 100.0 },
      { :destination => ["mr.tom"], :source => ["beer"], :support => 25.0, :confidence => 33.3333 },
      { :destination => ["beer"], :source => ["cheese"], :support => 50.0, :confidence => 100.0 },
      { :destination => ["cheese"], :source => ["beer"], :support => 50.0, :confidence => 66.6667 }]

    assert_equal expected_rules, calculated_rules
  end
end

