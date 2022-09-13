# 3 + (3 *5) -1
# Detect integer, operator, grouping
# TODO: How to detect a missing operand?

module Rithm
  def self.calc(expression)
    parsed = parse(expression)
    evaluate(parsed)
  end

  def self.parse(expression)
    expr = Expr.new

    expression.each_char do |char|
      if char == " "
        next
      elsif char.to_i.to_s == char # Hacky integer test
        if expr.last.is_a?(Int)
          expr.last << char
        else
          expr << Int.new(char)
        end
      elsif ['+','-','*','/'].include?(char)
        expr << Op.new(char)
      else
        raise "unknown character: `#{char}`"
      end
    end

    return expr
  end

  def self.evaluate(stack)
    raise "not implemented"
  end

  class Int
    def initialize(int)
      @int = int
    end

    def <<(int)
      @int += int
    end

    def to_s
      @int
    end
  end

  class Op
    def initialize(op)
      @op = op
    end

    def to_s
      @op
    end
  end

  class Expr
    def initialize
      @expr = []
    end

    def last
      @expr[-1]
    end

    def <<(term)
      @expr << term
    end

    def to_s
      @expr.map do |expr|
        expr.to_s
      end
    end
  end
end

def assert_equal(expected, actual)
  if expected == actual
    puts '.'
  else
    puts "F #{expected} != #{actual}"
  end

end

assert_equal([], Rithm.parse("").to_s)
assert_equal(["44"], Rithm.parse("44").to_s)
assert_equal(["3", "+", "1"], Rithm.parse("3 + 1").to_s)
# assert_equal("4", Rithm.calc("3 + 1")

