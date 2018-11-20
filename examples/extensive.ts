namespace HelloWorld {
}
let width: number = 500
let height: number = 400
let framerate: number = 1 / 60
let framedelay: number = framerate * 1000
let looptimer: number = false
namespace ModuleThing {
class ClassThing {

}}
new ModuleThing.ClassThing
class Vec2D {
x: number
y: number
constructor(x: number, y: number) {
this.x = x
this.y = y
}
}
class Entity {
position: Vec2D
velocity: Vec2D
mass: number
radius: number
restitution: number
constructor() {
this.position = new Vec2D(0, 0)
this.velocity = new Vec2D(0, 0)
this.mass = 0.1
this.radius = 15
this.restitution = -0.7
}
}
let entities: Entity[] = []
entities["ball"] = new Entity
let cd: number = 0.47
let rho: number = 1.22
let a: number = Math.PI * ball.radius ^ 2 / (100000)
let ag: number = 9.81
function loop() {
for (entity of entities()) {
let fx: Crystal::Call = (((((-0.5 * cd) * a) * rho) * entity.velocity.x) * entity.velocity.x) * entity.velocity.x / Math.abs(entity.velocity.x)
let fy: Crystal::Call = (((((-0.5 * cd) * a) * rho) * entity.velocity.y) * entity.velocity.x) * entity.velocity.y / Math.abs(entity.velocity.y)
if (isNaN(fx)) {
fx = 0
}
if (isNaN(fy)) {
fy = 0
}
let ax: Crystal::Call = fx / entity.mass
let ay: Crystal::Call = ag + (fy / entity.mass)
let entity.velocity.x(): Crystal::Call = entity.velocity.x + ax * frameRate
let entity.velocity.y(): Crystal::Call = entity.velocity.y + ay * frameRate
let entity.position.x(): Crystal::Call = entity.position.x + (entity.velocity.x * frameRate) * 100
let entity.position.y(): Crystal::Call = entity.position.y + (entity.velocity.y * frameRate) * 100
}
}