class Gene
  attr_reader :expression, :name
  attr_accessor :locked
  def initialize(args)
    @expression = args[:expression]
    @name = args[:name]
    @locked = true
  end
  def express
    unless locked
      @expression
    end
  end
end

METHYLS = {
  "a1" => false,
  "a2" => false,
  "b" => false,
  "g" => false
}

GENES = {
  "a1" => Gene.new({:name => "alpha1", :expression=>"alpha-globin"}),
  "a2" => Gene.new({:name => "alpha2", :expression=>"alpha-globin"}),
  "b"  => Gene.new({:name => "beta", :expression=>"beta-globlin"}),
  "g1" => "gamma1",
  "g2" => "gamma2",
  "d"  => "delta",
  "e"  => "epsilon",
  "t"  => "theta",
  "m"  => "mu",
  "z"  => "zeta"
}

def get_input
  input = gets.chomp
end

def switch_expression(input)
  markers = input.split(",")
  METHYLS.keys.each do |marker|
    if markers.include?(marker)
      METHYLS[marker] = !METHYLS[marker]
    end
  end
end

def express_genes
  combined_expressions = []
  GENES.each do |key, value|
    if METHYLS[key]
      combined_expressions << value.expression
    end
  end
  p(combined_expressions)
end

#### Playing around... ####
loop do
  input = get_input
  if input.match(/q/i)
    puts 'bye'
    exit
  end
  switch_expression(input)
  express_genes
end
