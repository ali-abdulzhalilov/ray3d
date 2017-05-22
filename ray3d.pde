Map m;
Time t;
Camera cam;
Controls c;
Player p;



void setup() {
  size(640, 480);
  
  m = new Map();
  t = new Time();
  cam = new Camera();
  c = new Controls();
  p = new Player();
  
  cam.loadTextures();
}

void draw() {
  c.handleInput();
  update();
  cam.render();
  t.frame();
}

void update() {
  p.update();
}

void keyPressed() {
  c.setKey(key, keyCode, true);
}

void keyReleased() {
  c.setKey(key, keyCode, false);
}