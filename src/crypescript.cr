require "compiler/crystal/syntax/virtual_file.cr"
require "compiler/crystal/syntax/exception.cr"
require "compiler/crystal/syntax/parser.cr"
require "logger"
require "./crypescript/**"

module Crypescript
  include Crypescript::Core
  include Crypescript::AST
  include Crypescript::Expressions
  include Crypescript::Types
  include Crypescript::Paths
  include Crypescript::Variables
  include Crypescript::Functions
  include Crypescript::Modifiers
  include Crypescript::Classes
  extend self

  @@log = Logger.new(STDOUT)
  @@log.level = Logger::DEBUG

  @@log.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    label = severity.unknown? ? "ANY" : severity.to_s
    io << label.rjust(5) << progname << ": " << message
  end

  @@variables = Hash(String, Crypescript::Variable).new

  def parse(source_code)
    parser = Crystal::Parser.new(source_code)
    node = Crystal::Expressions.from(parser.parse)
    result = ""
    result += transpile(node).strip
    puts "---"
    result
  end

  CURRENT_CONTEXT = [:top] of Symbol
end

code = %q(
puts : Any
puts = console.log

class Math
  private max : String

  def initialize
    @max = 255
    @min = -255
  end

  def add(one : Number, two : Number) : Number
    one + two
  end

  def pow(num : Number) : Number
    num ** num
  end

  private def use
    self.pow(@max)
  end
end

class AdvancedMath < Math
  def sqrt(num)
    Math.sqrt(num)
  end
end

Math.pow(10)

def add(one : Number, two : Number) : Number
	one + two
end

x = 1
x = 2
x = 3
puts x
)

puts Crypescript.parse(code)
