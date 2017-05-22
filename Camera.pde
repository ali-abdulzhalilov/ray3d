class Camera {
  float fov = 0.66;
  boolean showFPS = true;
  PImage buffer = createImage(width, height, RGB);
  PImage[] textures = new PImage[8];
  
  void loadTextures() {
    textures[0] = loadImage("img/eagle.png");
    textures[1] = loadImage("img/redbrick.png");
    textures[2] = loadImage("img/purplestone.png");
    textures[3] = loadImage("img/greystone.png");
    textures[4] = loadImage("img/bluestone.png");
    textures[5] = loadImage("img/mossy.png");
    textures[6] = loadImage("img/wood.png");
    textures[7] = loadImage("img/colorstone.png");
    for (int i = 0; i < textures.length; i++)
      textures[i].loadPixels();
  }
  
  void render() {
    buffer.loadPixels();
    for (int i = 0; i < buffer.pixels.length; i++) buffer.pixels[i] = color(0);
    
    for(int x = 0; x < width; x++) {
      drawColumn(x);
    }
    buffer.updatePixels();
    image(buffer, 0, 0);
    
    if (showFPS) {
      drawFPS();
    }
  }
  
  void drawColumn(int x) {
    //calculate ray position and direction
      float cameraX = 2 * x / float(width) - 1; //x-coordinate in camera space
      PVector rayPos = new PVector(p.pos.x, p.pos.y);
      PVector plane = (new PVector(p.dir.y, -p.dir.x)).normalize().mult(fov);
      PVector rayDir = new PVector(p.dir.x + plane.x * cameraX, p.dir.y + plane.y * cameraX);
      
      float[] castHit = m.cast(rayPos, rayDir);
      PVector map = new PVector(castHit[0], castHit[1]);
      int side = int(castHit[2]);
      float perpWallDist = castHit[3];
  
      //Calculate height of line to draw on screen
      int lineHeight = (int)(height / perpWallDist);
  
      //calculate lowest and highest pixel to fill in current stripe
      int drawStart = -lineHeight / 2 + height / 2;
      if(drawStart < 0) drawStart = 0;
      int drawEnd = lineHeight / 2 + height / 2;
      if(drawEnd >= height) drawEnd = height - 1;
      
      //texturing calculations
      int texNum = m.worldMap[int(map.x)][int(map.y)] - 1; //1 subtracted from it so that texture 0 can be used!
      
      //calculate value of wallX
      float wallX; //where exactly the wall was hit
      if (side == 0) wallX = rayPos.y + perpWallDist * rayDir.y;
      else           wallX = rayPos.x + perpWallDist * rayDir.x;
      wallX -= floor((wallX));
      
      //x coordinate on the texture
      int texX = int(wallX * textures[texNum].width);
      if(side == 0 && rayDir.x > 0) texX = textures[texNum].width - texX - 1;
      if(side == 1 && rayDir.y < 0) texX = textures[texNum].width - texX - 1;
      
      
      for(int y = drawStart; y < drawEnd; y++) {
        int d = y * 256 - height * 128 + lineHeight * 128;  //256 and 128 factors to avoid floats
        int texY = ((d*textures[texNum].width) / lineHeight) / 256;
        if (texY > textures[texNum].width-1) texY = textures[texNum].width-1;
        if (texY < 0) texY = 0;
        color c = textures[texNum].pixels[textures[texNum].width * texY + texX];
        //make color darker for y-sides: R, G and B byte each divided through two with a "shift" and an "and"
        if(side == 1) c = color(red(c)/2, green(c)/2, blue(c)/2);
        buffer.pixels[buffer.width * y + x] = c;
      }
  }
  
  void drawFPS() {
    textAlign(LEFT, TOP);
    textSize(20);
    text(int(1.0 / t.deltaTime), 0, 0);
  }
  
  color[] createTexture(String path) {
    PImage tmp = loadImage(path);
    tmp.loadPixels();
    return tmp.pixels;
  }
}