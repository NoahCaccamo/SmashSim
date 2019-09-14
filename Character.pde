class SmashCharacter extends PointHandler {

  int rosterNum = 0;
  int state = 0;
  float timer;

  SmashCharacter(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void stateMachine() {
    switch (state) {
    case 0:
      //idle
      break;
    case 1:
      jump(p1Pos, p1Peak);
      break;
    case 2:
      groundClash(p1Pos, p1Clash);
      break;
    }
  }

  void groundClash(PVector anchor, PVector clash) {
    timer ++;
    if (timer == 1) {
      goTo(anchor.x, anchor.y, 20);
    } else if (timer == 20) {
      goTo(clash.x, clash.y, 20); 
      rotateSpeed = 20;
    } else if (timer == 70) {
      goTo(anchor.x, anchor.y, 30);
      rotateSpeed = -4;
    } else if (timer == 100) {
      rotateSpeed = 0;
    }
  }

  void jump(PVector anchor, PVector peak) {
    timer++;
    if (timer == 1) {
      goToSmooth(peak.x, peak.y, 0.06);
    } else if (timer == 20) {
      goToSmooth(anchor.x, anchor.y, 0.1);
    }
  }

  void chacha() {
    scale(0.5);
    image(character[rosterNum], 0, 0);
  }
}
