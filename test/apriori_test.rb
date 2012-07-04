
require File.expand_path("../../lib/apriori", __FILE__)
require "test/unit"

class AprioriTest < Test::Unit::TestCase
  def test_rules
    calculated_rules = []

    Apriori.rules do |apriori|
      apriori.add ["beer", "cheese"]
      apriori.add ["beer", "mr.tom"]
      apriori.add ["beer", "cheese"]

      apriori.each do |rule|
        calculated_rules.push rule
      end
    end

    expected_rules = [{ :destination => ["beer"], :source => ["mr.tom"], :support => 25.0, :confidence => 100.0 },
      { :destination => ["mr.tom"], :source => ["beer"], :support => 25.0, :confidence => 33.3333 },
      { :destination => ["beer"], :source => ["cheese"], :support => 50.0, :confidence => 100.0 },
      { :destination => ["cheese"], :source => ["beer"], :support => 50.0, :confidence => 66.6667 }]

    assert_equal expected_rules, calculated_rules
  end
end

