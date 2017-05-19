class Controls {
  boolean[] keys = new boolean[5];
  
  boolean setKey(int k, int kCode, boolean value) {
    switch (k){
    case CODED:
      switch (kCode) {
      case UP:
        return keys[0] = value;
      case DOWN:
        return keys[1] = value;
      case RIGHT:
        return keys[2] = value;
      case LEFT:
        return keys[3] = value;
      }
    case ' ':
      return keys[4] = value;
    default: return value;
    }
  }

  void handleInput() {
    float moveSpeed = t.deltaTime * 5.0; //the constant value is in squares/second
    float rotSpeed = t.deltaTime * 3.0; //the constant value is in radians/second
    if (keys[0]) {
      if(m.worldMap[int(p.pos.x + p.dir.x * moveSpeed)][int(p.pos.y)] == 0) p.pos.x += p.dir.x * moveSpeed;
      if(m.worldMap[int(p.pos.x)][int(p.pos.y + p.dir.y * moveSpeed)] == 0) p.pos.y += p.dir.y * moveSpeed;
    }
    if (keys[1]) {
      if(m.worldMap[int(p.pos.x - p.dir.x * moveSpeed)][int(p.pos.y)] == 0) p.pos.x -= p.dir.x * moveSpeed;
      if(m.worldMap[int(p.pos.x)][int(p.pos.y - p.dir.y * moveSpeed)] == 0) p.pos.y -= p.dir.y * moveSpeed;
    }
    if (keys[2]) {
      float oldDirX = p.dir.x;
      p.dir.x = p.dir.x * cos(-rotSpeed) - p.dir.y * sin(-rotSpeed);
      p.dir.y = oldDirX * sin(-rotSpeed) + p.dir.y * cos(-rotSpeed);
    }
    if (keys[3]) {
      float oldDirX = p.dir.x;
      p.dir.x = p.dir.x * cos(rotSpeed) - p.dir.y * sin(rotSpeed);
      p.dir.y = oldDirX * sin(rotSpeed) + p.dir.y * cos(rotSpeed);
    }
    if (keys[4]) {
    
    }
  }
}