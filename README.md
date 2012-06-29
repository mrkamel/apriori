
# Apriori

This is another ruby wrapper gem for the apriori implementation of Christian Borgelt.
Currently, this is more a dirty hack, since the binary is included and the items may not include any commas and semicolons.
However, using this gem is really simple and straight forward if you're using an amd64 architecture and a linux box.

<pre>
irb> Apriori.association_rules [["beer", "cheese"],["beer", "mr.tom"],["beer", "cheese"]]
=> [{:destination=>["beer"], :source=>["mr.tom"], :support=>25.0, :confidence=>100.0}, ...]
</pre>

