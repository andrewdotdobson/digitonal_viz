//drawing agent: https://generateme.wordpress.com/2016/05/04/curvature-from-noise/
class Agent {
  PVector pos; // position of the agent
  float angle; // current angle of the agent
 
  void update() {
    // modify position using current angle
    pos.x += cos(angle);
    pos.y += sin(angle);
 
    // get point coordinates
    float xx = map(pos.x, 0, width, -1, 1);
    float yy = map(pos.y, 0, height, -1, 1);
 
    PVector v = new PVector(xx, yy);
   v.add(new PVector(5,-3));
    // modify an angle using noise information
    angle += map( noise(v.x, v.y), 0, 1, -1, 1);
  }
}
 
// all agents in the list
ArrayList<Agent> agents = new ArrayList<Agent>();
 
void setup() {
  size(800, 800);
  background(240);
  stroke(20, 10);
  smooth(8);
  strokeWeight(0.7);
 
  // initialize in random positions
  for (int i=0; i<5000; i++) {
    Agent a = new Agent();
    float posx = random(200, 600);
    float posy = random(200, 600);
    a.pos = new PVector(posx, posy);
    a.angle = random(TWO_PI);
    agents.add(a);
  }
}
 
float time = 0;
void draw() {
  for (Agent a : agents) {
    pushMatrix();
    // position
    translate(a.pos.x, a.pos.y);
    // rotate
    rotate(a.angle);
    // paint
    point(0, 0);
    popMatrix();
    // update
    a.update();
  }
  time += 0.001;
}
