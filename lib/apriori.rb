
require "apriori/version"
require "tempfile"
require "escape"

class Apriori
  include Enumerable

  def initialize(infile, outfile, options = {})
    @infile = infile
    @outfile = outfile

    @ops = {}

    @ops[:min_support] = 1
    @ops[:max_support] = 100
    @ops[:min_confidence] = 20
    @ops[:min_items] = 2
    @ops[:max_items] = 10

    @ops.merge! options
  end

  def self.rules(options = {})
    infile, outfile = Tempfile.new("apriori_in"), Tempfile.new("apriori_out")

    begin
      yield new(infile, outfile, options)
    ensure
      [infile, outfile].each do |file|
        file.close
        file.unlink
      end
    end
  end

  def add(transaction)
    @infile.puts transaction.join(",")
  end

  def each
    binary = File.expand_path("../../bin/apriori", __FILE__)

    @infile.puts
    @infile.flush

    command = Escape.shell_command([binary, "-tr", "-c#{@ops[:min_confidence]}",
      "-n#{@ops[:max_items]}", "-m#{@ops[:min_items]}", "-S#{@ops[:max_support]}",
      "-s#{@ops[:min_support]}", "-I<", "-v;%S;%C", "-f,", "-k,", @infile.path, @outfile.path])

    `#{command} 2> /dev/null &> /dev/null`

    @outfile.rewind

    @outfile.each do |line|
      rule, support, confidence = line.strip.split(";")

      destination, source = rule.split("<")

      yield :destination => destination.split(","), :source => source.split(","), :support => support.to_f, :confidence => confidence.to_f
    end
  end
end

