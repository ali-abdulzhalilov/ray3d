int[][] worldMap =
{
  {1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,2,2,2,0,0,3,0,3,0,1},
  {1,0,2,0,2,0,0,0,0,0,0,1},
  {1,0,2,2,2,0,0,3,0,3,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,0,0,0,0,0,0,1},
  {1,4,0,5,4,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1}
};

float posX = 2, posY = 2;  //x and y start position
float dirX = -1, dirY = 0; //initial direction vector
float planeX = 0, planeY = 0.66; //the 2d raycaster version of camera plane

float time = 0; //time of current frame
float frameTime = 0;
float oldTime = 0; //time of previous frame

void setup() {
  size(512, 384);
}

void draw() {
  background(0);
  
  for(int x = 0; x < width; x++)
  {
    //calculate ray position and direction
    float cameraX = 2 * x / float(width) - 1; //x-coordinate in camera space
    float rayPosX = posX;
    float rayPosY = posY;
    float rayDirX = dirX + planeX * cameraX;
    float rayDirY = dirY + planeY * cameraX;
    //which box of the map we're in
    int mapX = int(rayPosX);
    int mapY = int(rayPosY);

    //length of ray from current position to next x or y-side
    float sideDistX;
    float sideDistY;

     //length of ray from one x or y-side to next x or y-side
    float deltaDistX = sqrt(1 + (rayDirY * rayDirY) / (rayDirX * rayDirX));
    float deltaDistY = sqrt(1 + (rayDirX * rayDirX) / (rayDirY * rayDirY));
    float perpWallDist;

    //what direction to step in x or y-direction (either +1 or -1)
    int stepX;
    int stepY;

    int hit = 0; //was there a wall hit?
    int side = 0; //was a NS or a EW wall hit?
    //calculate step and initial sideDist
    if (rayDirX < 0)
    {
      stepX = -1;
      sideDistX = (rayPosX - mapX) * deltaDistX;
    }
    else
    {
      stepX = 1;
      sideDistX = (mapX + 1.0 - rayPosX) * deltaDistX;
    }
    if (rayDirY < 0)
    {
      stepY = -1;
      sideDistY = (rayPosY - mapY) * deltaDistY;
    }
    else
    {
      stepY = 1;
      sideDistY = (mapY + 1.0 - rayPosY) * deltaDistY;
    }
    //perform DDA
    while (hit == 0)
    {
      //jump to next map square, OR in x-direction, OR in y-direction
      if (sideDistX < sideDistY)
      {
        sideDistX += deltaDistX;
        mapX += stepX;
        side = 0;
      }
      else
      {
        sideDistY += deltaDistY;
        mapY += stepY;
        side = 1;
      }
      //Check if ray has hit a wall
      if (worldMap[mapX][mapY] > 0) hit = 1;
    }
    //Calculate distance projected on camera direction (oblique distance will give fisheye effect!)
    if (side == 0) perpWallDist = (mapX - rayPosX + (1 - stepX) / 2) / rayDirX;
    else           perpWallDist = (mapY - rayPosY + (1 - stepY) / 2) / rayDirY;

    //Calculate height of line to draw on screen
    int lineHeight = (int)(height / perpWallDist);

    //calculate lowest and highest pixel to fill in current stripe
    int drawStart = -lineHeight / 2 + height / 2;
    if(drawStart < 0)drawStart = 0;
    int drawEnd = lineHeight / 2 + height / 2;
    if(drawEnd >= height)drawEnd = height - 1;

    //choose wall color
    color c;
    switch(worldMap[mapX][mapY])
    {
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
  //timing for input and FPS counter
  oldTime = time;
  time = millis();
  frameTime = (time - oldTime) / 1000.0; //frameTime is the time this frame has taken, in seconds
  //print(1.0 / frameTime); //FPS counter

  //speed modifiers
  
}

void keyPressed() {
float moveSpeed = frameTime * 5.0; //the constant value is in squares/second
float rotSpeed = frameTime * 3.0; //the constant value is in radians/second
  
  //move forward if no wall in front of you
  if (keyCode == UP)
  {
    if(worldMap[int(posX + dirX * moveSpeed)][int(posY)] == 0) posX += dirX * moveSpeed;
    if(worldMap[int(posX)][int(posY + dirY * moveSpeed)] == 0) posY += dirY * moveSpeed;
  }
  //move backwards if no wall behind you
  if (keyCode == DOWN)
  {
    if(worldMap[int(posX - dirX * moveSpeed)][int(posY)] == 0) posX -= dirX * moveSpeed;
    if(worldMap[int(posX)][int(posY - dirY * moveSpeed)] == 0) posY -= dirY * moveSpeed;
  }
  //rotate to the right
  if (keyCode == RIGHT)
  {
    //both camera direction and camera plane must be rotated
    float oldDirX = dirX;
    dirX = dirX * cos(-rotSpeed) - dirY * sin(-rotSpeed);
    dirY = oldDirX * sin(-rotSpeed) + dirY * cos(-rotSpeed);
    float oldPlaneX = planeX;
    planeX = planeX * cos(-rotSpeed) - planeY * sin(-rotSpeed);
    planeY = oldPlaneX * sin(-rotSpeed) + planeY * cos(-rotSpeed);
  }
  //rotate to the left
  if (keyCode == LEFT)
  {
    //both camera direction and camera plane must be rotated
    float oldDirX = dirX;
    dirX = dirX * cos(rotSpeed) - dirY * sin(rotSpeed);
    dirY = oldDirX * sin(rotSpeed) + dirY * cos(rotSpeed);
    float oldPlaneX = planeX;
    planeX = planeX * cos(rotSpeed) - planeY * sin(rotSpeed);
    planeY = oldPlaneX * sin(rotSpeed) + planeY * cos(rotSpeed);
  }
}