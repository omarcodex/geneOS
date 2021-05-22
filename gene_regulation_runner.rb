require './gene_regulation_classes.rb'

# Demonstrate that presence of downstream object removes upstream object

bloodstream = System.new

signaler = Biomolecule.new({
  identifier: "growth_hormone",
  target: "cell_membrane_protein"
})
bloodstream.stuff_in_system << signaler

protein = Biomolecule.new({
    identifier: "growth_hormone_ase",
    target: "growth_hormone"
})
bloodstream.stuff_in_system << protein

puts "BEFORE STEP 1\n"
puts bloodstream.stuff_in_system.inspect
bloodstream.step
puts "AFTER STEP 1\n"
puts bloodstream.stuff_in_system.inspect

# Now add a new protein to remove the first protein...
protein_ase = Biomolecule.new({
    identifier: "growth_hormone_ase_ase",
    target: "growth_hormone_ase"
})
bloodstream.stuff_in_system << protein_ase

puts "BEFORE STEP 2\n"
puts bloodstream.stuff_in_system.inspect
bloodstream.step
puts "AFTER STEP 2\n"
puts bloodstream.stuff_in_system.inspect
puts bloodstream.stuff_in_system.length == 1 ? "Success" : "Fail"
