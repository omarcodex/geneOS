# Draft for an interoperating biomolecule classes
# Part of the Object-Oriented Gene Circuitry Project (OOGCP)
# Each biomolecule type has a target that it can act upon (bind to)
# O. A. Malik 2021

class System
  attr_accessor :stuff_in_system

  def initialize
    @stuff_in_system = []
  end

  def step
    stuff_to_check = @stuff_in_system.dup
    until stuff_to_check.length == 0
      biomolecule = stuff_to_check.pop
      stuff_to_check.each do |other_biomolecule|
        puts "Comparing #{biomolecule.identifier} to #{other_biomolecule.identifier}"
        if (biomolecule.target == other_biomolecule.identifier ||
          biomolecule.identifier == other_biomolecule.target)
          handle_target(biomolecule, other_biomolecule)
        end
      end
    end
  end

  def handle_target(biomolecule, target)
    self.stuff_in_system.delete(target)
  end
end

class Biomolecule
  attr_accessor :identifier, :target
  def initialize(args)
    @identifier = args[:identifier]
    @target = args[:target] || nil
  end
end
