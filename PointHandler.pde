class PointHandler {
  float x, y;
  float oldX, oldY;
  float targetX, targetY;
  float time;
  boolean isMoving;
  boolean isMovingSmooth;
  int rotateSpeed;
  int counter = 0;

  int rotator = 0;

  PointHandler() {
  }

  PointHandler(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void goTo(float newX, float newY, float _time) {
    oldX = x;
    oldY = y;
    targetX = newX;
    targetY = newY;
    time = _time;
    counter = 0;
    isMoving = true;
    isMovingSmooth = false;
  }

  void goToSmooth(float newX, float newY, float percent) {
    targetX = newX;
    targetY = newY;
    time = percent;
    isMovingSmooth = true;
    isMoving = false;
  }

  void travel() {
    if (isMoving) {
      float timePosition = counter/time;
      counter ++;
      x = lerp(oldX, targetX, timePosition);
      y = lerp(oldY, targetY, timePosition);
    } else if (isMovingSmooth) {
      x = lerp(x, targetX, time);
      y = lerp(y, targetY, time);
    }
    if (x == targetX && y == targetY) {
      isMoving = false; 
      isMovingSmooth = false;
    }
  }

  void rotateIt() {
    rotate(radians(rotator));
    rotator += rotateSpeed;
    if (rotator >= 360) {
      rotator = 0;
    }
    if (rotateSpeed == 0) {
      rotator = 0;
    }
  }

  void display() {
    translate(x, y);
    rotateIt();
    //rect(0, 0, 60, 60);
  }
}
