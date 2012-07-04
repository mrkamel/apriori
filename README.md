
# Apriori

This is another ruby wrapper gem for the apriori implementation of Christian Borgelt.
Currently, this is more a dirty hack, since the binary is included and the items may not include any commas and semicolons.
However, using this gem is really simple and straight forward if you're using an amd64 architecture and a linux box.

<pre>
def calculate
  rules = []

  Apriori.rules do |apriori|
    apriori.add_transaction ["beer", "cheese"]
    apriori.add_transaction "beer", "mr.tom"]
    apriori.add_transaction ["beer", "cheese"]

    apriori.each do |rule|
      rules.push rule
    end
  end

  rules
end

irb> calculate
=> [{:destination=>["beer"], :source=>["mr.tom"], :support=>25.0, :confidence=>100.0}, ...]
</pre>

