class Camera {
  float fov = 0.66;
  boolean showFPS = true;
  
  void render() {
    background(0);
    
    for(int x = 0; x < width; x++) {
      drawColumn(x);
    }
    
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
  
      //Calculate height of line to draw on screen
      int lineHeight = (int)(height / castHit[3]);
  
      //calculate lowest and highest pixel to fill in current stripe
      int drawStart = -lineHeight / 2 + height / 2;
      if(drawStart < 0)drawStart = 0;
      int drawEnd = lineHeight / 2 + height / 2;
      if(drawEnd >= height)drawEnd = height - 1;
  
      //choose wall color
      color c;
      switch(m.worldMap[int(map.x)][int(map.y)]) {
        case 1:  c = color(255,   0,   0); break; //red
        case 2:  c = color(  0, 255,   0); break; //green
        case 3:  c = color(  0,   0, 255); break; //blue
        case 4:  c = color(255, 255, 255); break; //white
        default: c = color(255, 255,   0); break; //yellow
      }
  
      //give x and y sides different brightness
      if (castHit[2] == 1) {c = color(red(c)/2, green(c)/2, blue(c)/2);}
      
      verLine(x, drawStart, drawEnd, c);
  }
  
  void verLine(float x, float y1, float y2, color c) {
    stroke(c);
    line(x, y1, x, y2);
  }
  
  void drawFPS() {
    textAlign(LEFT, TOP);
    textSize(20);
    text(int(1.0 / t.deltaTime), 0, 0);
  }
}