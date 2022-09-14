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
    root = expr
    current = expr

    expression.each_char do |char|
      if char == " "
        next
      elsif char.to_i.to_s == char # Hacky integer test
        if current.last.is_a?(Int)
          current.last << char
        else
          current << Int.new(char)
        end
      elsif ['+','-','*','/'].include?(char)
        current << Op.new(char)
      elsif char == "("
        # Begin a nested expression
        sub = Expr.new
        expr << sub
        current = sub
      elsif char == ")"
        # Close out this sub-expression
        current = root
      else
        raise "unknown character: `#{char}`"
      end
    end

    return expr
  end

  def self.evaluate(expr)
    expr.evaluate
  end

  class State
    attr_reader :running

    def initialize
      @result = nil
      @has_operator = false
      @terms = []
    end

    def <<(term)
      if @running == nil
        @running = term
      end

      @terms << term
      if @terms[-2].is_a?(Op)
        @running = @terms[-2].evaluate(@running, term)
      end
    end
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

    def to_i
      @int.to_i
    end

    def evaluate
      to_i
    end
  end

  class Op
    def initialize(op)
      @op = op
    end

    def to_s
      @op
    end

    def evaluate(operant, operand)
      operant.to_i.send(self.to_s, operand.to_i)
    end
  end

  class Expr
    def initialize
      @expr = []
    end

    def last
      @expr[-1]
    end

    def each(&blk)
      @expr.each(&blk)
    end

    def <<(term)
      @expr << term
    end

    def to_s
      @expr.map do |term|
        term.to_s
      end
    end

    def evaluate
      running = nil
      current_operator = nil
      list = []

      @expr.each do |term|
        if running == nil
          running = term
        end

        list << term

        if term.is_a?(Op)
          current_operator = term
          next
        end

        if list[-2].is_a?(Op)
          running = Int.new(running.evaluate.send(current_operator.to_s, term.evaluate))
          current_operator = nil
        end
      end

      running.to_i
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
assert_equal(["3", "+", ["3", "*", "5"], "-", "1"], Rithm.parse("3 + (3 * 5) - 1").to_s)

assert_equal(4, Rithm.calc("3 + 1"))
assert_equal(6, Rithm.calc("10 - 4"))
assert_equal(6, Rithm.calc("10 - (2 + 2)"))
assert_equal(5, Rithm.calc("3 + 1 + 1"))
assert_equal(6, Rithm.calc("3 + 1 + 1 + 1"))
assert_equal(17, Rithm.calc("3 + (3 * 5) - 1"))
assert_equal(13, Rithm.calc("1 + (1 * 5 * 2) + 1 + 1"))
