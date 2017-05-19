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
    
    if (keys[0]) {
      p.dmov = 1;
    }
    if (keys[1]) {
      p.dmov = -1;
    }
    if (keys[2]) {
      p.drot = 1;
    }
    if (keys[3]) {
      p.drot = -1;
    }
    if (keys[4]) {
    
    }
  }
}