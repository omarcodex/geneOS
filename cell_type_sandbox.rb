# October 2022
# O. A. Malik

# This sketches out some of theoretical concepts in genome biology:
#  * Cell type as defined by an inherited methylation pattern (i.e., epigenetic fingerprint).
#  * A gene as a repository of protein history (i.e., life's database entry).
#  * An attempt to model regulatory programming over the life cycle ("Entfaltung").

# Future work requires integration of genome's internal switching-on-and-off mechanics.

SYSTEM_PRODUCTS = {}

class BioComplex
    attr_accessor :pattern
    attr_reader :dictionary

    def initialize(args=nil)
        @pattern = args
        @dictionary = {
            "HBA1"=>"alphaglobin",
            "HBA2"=>"alphaglobin",
            "HBB"=>"betaglobin",
            "name"=> args["name"] || ""
        }
    end

    def attempt_binding(products_list)
        outgoing = []
        SYSTEM_PRODUCTS[@pattern["name"]] ||= 0
        products_list.each do |protein|
            if @pattern.key?(protein)
                if @pattern[protein] > 0
                    @pattern[protein] -= 1
                else
                    outgoing << protein
                    next
                end
            else
                outgoing << protein
            end
        end
        if @pattern.reject{|k,v| k=="name"}.values.all?{|x| x == 0}
            SYSTEM_PRODUCTS[@pattern["name"]] += 1
        end
        outgoing
    end
end

class CellTypeA
    attr_accessor :methylome
    def initialize(args=nil)
        @methylome = {
            "HBZ" => true,
            "HBA2" => false,
            "HBA1" => false,
            "HBE1" => true,
            "HBG2" => false,
            "HBG1" => false,
            "HBB" => false,
            "HBD" => false
        }
        @genome = {
            # alpha locus, chr. 16, 5' -> 3'
            "HBZ" => "h-s-zeta",
            "HBM" => "mu-hemoglobin (predicted)",
            "HBA2" => "alphaglobin",
            "HBA1" => "alphaglobin",
            "HBQ1" => "h-s-theta-1",
            # beta locus, chr. 11, 5' -> 3'
            "HBE1" => "h-s-epsilon",
            "HBG2" => "h-s-gamma-2",
            "HBG1" => "h-s-gamma-1",
            "HBD" => "h-s-delta",
            "HBB" => "betaglobin"
        }
        if args # optional overwrite
            args.each do |k,v|
                if @methylome.key?(k)
                    @methylome[k] = v
                end
            end
        end
    end
    def express(opts=nil)
        expressed = []
        @methylome.each do |key, val| # could do variable relative rates of expression
            if val
                expressed.push(@genome[key]) # gene as database entry for protein
            end
        end
        expressed
    end
end

class CellTypeB < CellTypeA
attr_accessor :methylome
    def initialize(args=nil)
        super
        @methylome["HBA1"] = true # descendents inherit this
        @methylome["HBA2"] = true
        @methylome["HBG1"] = true
        @methylome["HBG2"] = true
        @methylome["HBB"] = true
        # start of sequence gets turned off
        @methylome["HBZ"] = false
        @methylome["HBE1"] = false
    end
end

class CellTypeC < CellTypeB
attr_accessor :methylome
    def initialize(args=nil)
        super
        @methylome["HBA1"] = true
        @methylome["HBB"] = true
        @methylome["HBD"] = true
    end
end

a = CellTypeA.new
puts a.inspect

b=CellTypeB.new
puts b.inspect

c=CellTypeC.new
puts c.inspect

# Example of customized fingerprint at instantation:
#x = CellB.new({"HBZ"=>false, "HBE1"=>true})

d=CellTypeC.new
puts d.inspect

products_a = a.express
puts "T0: #{products_a}"

products_b = b.express
puts "T1: #{products_b}"

products_c = c.express
puts "T2: #{products_c}"

products_d = d.express
puts "T3a: #{products_d}"

products_d += d.express
puts "T3b: #{products_d}"

products_d += d.express
puts "T3c: #{products_d}"

# Additional concept: biocomplexes that count up the products and sort them into molecules, effectively:

h1 = BioComplex.new({"h-s-epsilon"=>2, "h-s-zeta"=>2, "name"=>"HbE Gower-1"}) # embryo (high levels), fetal
h2 = BioComplex.new({"alphaglobin"=>2, "h-s-zeta"=>2, "name"=>"HbE Gower-2"}) # embryo (low levels), fetal
h3 = BioComplex.new({"h-s-gamma-1"=>1, "h-s-gamma-2"=>1, "h-s-zeta"=>2, "name"=>"HbE Portland-1"}) # embryo (low), fetal # check gammas
h4 = BioComplex.new({"betaglobin"=>2, "h-s-zeta"=>2, "name"=>"HbE Portland-2"}) # embryo (low), fetal

hemoglobin_a = BioComplex.new({"alphaglobin"=>2, "betaglobin"=>2, "name"=>"HbA"})
hemoglobin_b = BioComplex.new({"alphaglobin"=>2, "h-s-delta"=>2, "name"=>"HbA2"})
hemoglobin_f = BioComplex.new({"alphaglobin"=>2, "h-s-gamma-1"=>1, "h-s-gamma-2"=>1, "name"=>"HbaF"}) # check gammas

products_d = hemoglobin_a.attempt_binding(products_d)
puts "T3c after HbA scan: #{products_d}"
puts "HbA BioComplex: #{hemoglobin_a.inspect}"

products_d = hemoglobin_b.attempt_binding(products_d)
puts "T3d after HbA2 scan: #{products_d}"
puts "HbA2 BioComplex: #{hemoglobin_b.inspect}"

products_d = hemoglobin_f.attempt_binding(products_d)
puts "T3d after HbaF scan: #{products_d}"
puts "HbaF BioComplex: #{hemoglobin_f.inspect}"

puts SYSTEM_PRODUCTS