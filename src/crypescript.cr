require "compiler/crystal/syntax/virtual_file.cr"
require "compiler/crystal/syntax/exception.cr"
require "compiler/crystal/syntax/parser.cr"
require "logger"
require "./crypescript/**"

module Crypescript
  include Crypescript::Core
  include Crypescript::AST
  include Crypescript::Expressions
  include Crypescript::Literals
  include Crypescript::Types
  include Crypescript::Paths
  include Crypescript::Functions
  include Crypescript::Variables
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
width       : Number = 500
height      : Number = 400
framerate   : Number = 1 / 60
framedelay  : Number = framerate * 1000
looptimer   : Number = false

class Vec2D
  x : Number
  y : Number

  def initialize(@x : Number, @y : Number)
  end
end

class Entity
  position    : Vec2D
  velocity    : Vec2D
  mass        : Number
  radius      : Number
  restitution : Number

  def initialize
    @position = Vec2D.new(0, 0)
    @velocity = Vec2D.new(0, 0)
    @mass = 0.1
    @radius = 15
    @restitution = -0.7
  end
end

entities = [] of Entity
entities["ball"] = Entity.new

cd  : Number = 0.47
rho : Number = 1.22
a   : Number = Math.PI * ball.radius^2 / (100000)
ag  : Number = 9.81

def loop
  entities.each do |entity|
    fx = -0.5 * cd * a * rho * ball.velocity.x * ball.velocity.x * ball.velocity.x / Math.abs(ball.velocity.x)
  end
end
)

puts Crypescript.parse(code)
