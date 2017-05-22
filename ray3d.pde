Map m;
Time t;
Camera cam;
Controls c;
Player p;

int texWidth = 64, texHeight = 64;
color[][] texture = new color[8][texWidth * texHeight];

void setup() {
  size(640, 480);
  
  //generate some textures
  for(int x = 0; x < texWidth; x++)
    for(int y = 0; y < texHeight; y++) {
      int xorcolor = (x * 256 / texWidth) ^ (y * 256 / texHeight);
      //int xcolor = x * 256 / texWidth;
      int ycolor = y * 256 / texHeight;
      int xycolor = y * 128 / texHeight + x * 128 / texWidth;
      texture[0][texWidth * y + x] = color(x!=y && x!=texWidth-y ? 255 : 0); //flat red texture with black cross
      texture[1][texWidth * y + x] = color(xycolor); //sloped greyscale
      texture[2][texWidth * y + x] = color(xycolor, xycolor, 0); //sloped yellow gradient
      texture[3][texWidth * y + x] = color(xorcolor); //xor greyscale
      texture[4][texWidth * y + x] = color(0, xorcolor, 0); //xor green
      texture[5][texWidth * y + x] = color((x % 16 == 0 || y % 16 == 0) ? 0 : 255, 0, 0); //red bricks
      texture[6][texWidth * y + x] = color(ycolor); //red gradient
      texture[7][texWidth * y + x] = color(125); //flat grey texture
    }
  
  m = new Map();
  t = new Time();
  cam = new Camera();
  c = new Controls();
  p = new Player();
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