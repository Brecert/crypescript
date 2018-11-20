module HelloWorld
end

width : Number = 500
height : Number = 400
framerate : Number = 1 / 60
framedelay : Number = framerate * 1000
looptimer : Number = false

module ModuleThing
  class ClassThing
  end
end

ModuleThing::ClassThing.new

class Vec2D
  x : Number
  y : Number

  def initialize(@x : Number, @y : Number)
  end
end

class Entity
  position : Vec2D
  velocity : Vec2D
  mass : Number
  radius : Number
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

cd : Number = 0.47
rho : Number = 1.22
a : Number = Math.PI * ball.radius ^ 2 / (100000)
ag : Number = 9.81

def loop
  entities.each do |entity|
    fx = -0.5 * cd * a * rho * entity.velocity.x * entity.velocity.x * entity.velocity.x / Math.abs(entity.velocity.x)
    fy = -0.5 * cd * a * rho * entity.velocity.y * entity.velocity.x * entity.velocity.y / Math.abs(entity.velocity.y)

    fx = 0 if isNaN(fx)
    fy = 0 if isNaN(fy)

    ax = fx / entity.mass
    ay = ag + (fy / entity.mass)

    entity.velocity.x += ax * frameRate
    entity.velocity.y += ay * frameRate
    entity.position.x += entity.velocity.x * frameRate * 100
    entity.position.y += entity.velocity.y * frameRate * 100
  end
end
