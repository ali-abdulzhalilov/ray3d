class Time {
  float time = 0; //time of current frame
  float deltaTime = 0;
  float oldTime = 0; //time of previous frame
  
  void frame() {
    oldTime = time;
    time = millis();
    deltaTime = (time - oldTime) / 1000.0; //frameTime is the time this frame has taken, in seconds
    //print(1.0 / frameTime); //FPS counter  
  }
}