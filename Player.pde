class Player {
  PVector pos = new PVector(22, 11.5);
  PVector dir = new PVector(-1, 0);
  float dmov = 0, drot = 0;
  
  float moveSpeed = 5; //the constant value is in squares/second
  float rotSpeed = 3; //the constant value is in radians/second
  
  void update() {
    mov();
    rot();
  }
  
  void mov() {
    if(m.worldMap[int(p.pos.x + dir.x * moveSpeed * dmov * t.deltaTime)][int(pos.y)] == 0) pos.x += dir.x * moveSpeed * dmov * t.deltaTime;
    if(m.worldMap[int(p.pos.x)][int(pos.y + dir.y * moveSpeed * dmov * t.deltaTime)] == 0) pos.y += dir.y * moveSpeed * dmov * t.deltaTime;
    dmov = 0;
  }
  
  void rot() {
    float oldDirX = p.dir.x;
    p.dir.x = p.dir.x * cos(-rotSpeed * drot * t.deltaTime) - p.dir.y * sin(-rotSpeed * drot * t.deltaTime);
    p.dir.y = oldDirX * sin(-rotSpeed * drot * t.deltaTime) + p.dir.y * cos(-rotSpeed * drot * t.deltaTime);
    drot = 0;
  }
}