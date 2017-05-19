class Camera {
  float fov = 0.66;
  boolean showFRS = true;
  
  void render() {
    background(0);
    
    for(int x = 0; x < width; x++) {
      //calculate ray position and direction
      float cameraX = 2 * x / float(width) - 1; //x-coordinate in camera space
      PVector rayPos = new PVector(p.pos.x, p.pos.y);
      PVector plane = new PVector(p.dir.y, -p.dir.x);
      plane.normalize();
      plane.mult(fov);
      PVector rayDir = new PVector(p.dir.x + plane.x * cameraX, p.dir.y + plane.y * cameraX);
      
      float[] castHit = m.cast(rayPos, rayDir);
      PVector map = new PVector(castHit[0], castHit[1]);
      int side = int(castHit[2]);
      float perpWallDist = castHit[3];
  
      //Calculate height of line to draw on screen
      int lineHeight = (int)(height / perpWallDist);
  
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
      if (side == 1) {c = color(red(c)/2, green(c)/2, blue(c)/2);}
  
      stroke(c);
      line(x, drawStart, x, drawEnd);
      //draw the pixels of the stripe as a vertical line
    }
  }
}