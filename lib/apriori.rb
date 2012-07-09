
require "apriori/version"
require "tempfile"
require "escape"

class Apriori
  include Enumerable

  def initialize(file_in, file_out, options = {})
    @file_in = file_in
    @file_out = file_out

    @ops = {}

    @ops[:min_support] = 1
    @ops[:max_support] = 100
    @ops[:min_confidence] = 20
    @ops[:min_items] = 2
    @ops[:max_items] = 10
    @ops[:memory_limit] = 0

    @ops.merge! options
  end

  def self.rules(options = {})
    file_in, file_out = Tempfile.new("apriori_in"), Tempfile.new("apriori_out")

    begin
      yield new(file_in, file_out, options)
    ensure
      [file_in, file_out].each do |file|
        file.close
        file.unlink
      end
    end
  end

  def add(transaction)
    @file_in.puts transaction.join(",")
  end

  def each
    limit = File.expand_path("../../bin/limit", __FILE__)
    binary = File.expand_path("../../bin/apriori", __FILE__)

    @file_in.puts
    @file_in.flush

    command = Escape.shell_command([limit, @ops[:memory_limit].to_s, binary, "-tr", "-c#{@ops[:min_confidence]}",
      "-n#{@ops[:max_items]}", "-m#{@ops[:min_items]}", "-S#{@ops[:max_support]}",
      "-s#{@ops[:min_support]}", "-I<", "-v;%S;%C", "-f,", "-k,", @file_in.path, @file_out.path])

    `#{command} 2> /dev/null &> /dev/null`

    raise unless $?.exitstatus.zero?

    @file_out.rewind

    @file_out.each do |line|
      rule, support, confidence = line.strip.split(";")

      destination, source = rule.split("<")

      yield :destination => destination.split(","), :source => source.split(","), :support => support.to_f, :confidence => confidence.to_f
    end
  end
end

