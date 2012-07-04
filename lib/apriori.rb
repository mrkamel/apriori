
require "apriori/version"
require "tempfile"
require "escape"

module Apriori
  def self.rules(transactions, options = {})
    binary = File.expand_path("../../bin/apriori", __FILE__)

    infile = Tempfile.new("apriori_in")
    outfile = Tempfile.new("apriori_out")

    begin
      ops = {}

      ops[:min_support] = 1
      ops[:max_support] = 100
      ops[:min_confidence] = 20
      ops[:min_items] = 2
      ops[:max_items] = 10

      ops.merge! options

      transactions.each do |transaction|
        if options[:separator]
          infile.puts transaction.to_s.split(options[:separator]).reject(&:empty?).join(",")
        else
          infile.puts Array(transaction).join(",")
        end
      end

      infile.puts
      infile.flush

      command = Escape.shell_command([binary, "-tr", "-c#{ops[:min_confidence]}",
        "-n#{ops[:max_items]}", "-m#{ops[:min_items]}", "-S#{ops[:max_support]}",
        "-s#{ops[:min_support]}", "-I<", "-v;%S;%C", "-f,", "-k,", infile.path, outfile.path])

      `#{command} 2> /dev/null &> /dev/null`

      outfile.rewind

      outfile.each do |line|
        rule, support, confidence = line.strip.split(";")

        destination, source = rule.split("<")

        yield :destination => destination.split(","), :source => source.split(","), :support => support.to_f, :confidence => confidence.to_f
      end
    ensure
      infile.close
      infile.unlink

      outfile.close
      outfile.unlink
    end
  end
end

