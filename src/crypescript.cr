require "compiler/crystal/syntax/virtual_file.cr"
require "compiler/crystal/syntax/exception.cr"
require "compiler/crystal/syntax/parser.cr"
require "logger"
require "./crypescript/**"

module Crypescript
  include Crypescript::Core
  include Crypescript::Expressions
  include Crypescript::Transpiler
  extend self

  @@log = Logger.new(STDOUT)
  @@log.level = Logger::DEBUG

  @@log.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    label = severity.unknown? ? "ANY" : severity.to_s
    io << label.rjust(5) << progname << ": " << message
  end

  def log
    @@log
  end

  def parse(crystal_source_code)
    parser = Crystal::Parser.new(crystal_source_code)
    node = Crystal::Expressions.from(parser.parse)
    result = ""
    result += transpile(node).strip
    result
  end

  CURRENT_CONTEXT = Array(NamedTuple(symbol: Symbol, node: Crystal::ASTNode)).new

  CONTEXTS = [:top]

  VARIABLES = Hash(String, Crystal::ASTNode).new

  private def context(context, &block)
    CONTEXTS.push context
    result = yield
    CONTEXTS.pop
    result
  end

  private def current_context(context)
    CONTEXTS.last
  end

  private def in_context?(context)
    CONTEXTS.any? { |ctx| ctx == context }
  end
end

# module Crypescript
#   include Crypescript::Core
#   include Crypescript::AST
#   include Crypescript::Expressions
#   include Crypescript::Literals
#   include Crypescript::Types
#   include Crypescript::Paths
#   include Crypescript::Conditionals
#   include Crypescript::Functions
#   include Crypescript::Variables
#   include Crypescript::Visibility
#   include Crypescript::Classes
#   include Crypescript::Modules
#   extend self

#   @@log = Logger.new(STDOUT)
#   @@log.level = Logger::DEBUG

#   @@log.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
#     label = severity.unknown? ? "ANY" : severity.to_s
#     io << label.rjust(5) << progname << ": " << message
#   end

#   @@variables = Hash(String, Crypescript::Variable).new

#   def parse(source_code)
#     parser = Crystal::Parser.new(source_code)
#     node = Crystal::Expressions.from(parser.parse)
#     result = ""
#     result += transpile(node).strip
#     puts "---"
#     result
#   end

#   def log
#     @@log
#   end

#   CURRENT_CONTEXT = [:top] of Symbol
# end
