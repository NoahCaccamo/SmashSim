class SmashCharacter extends PointHandler {

  SmashCharacter other;

  int rosterNum = 0;
  int state = 0;
  float scale = 0.5;
  float timer;

  boolean isReady = true;
  boolean isGrounded = true;
  boolean canKO = false;
  boolean stopNow = false;

  int dashDanceDist = 100;

  PVector currentAnchor;
  PVector currentClash;

  SmashCharacter(float _x, float _y, PVector _currentAnchor) {
    x = _x;
    y = _y;
    currentAnchor = _currentAnchor;
  }

  void stateMachine(PVector pos, PVector clash, int koX) {
    switch (state) {
    case 0:
      //idle
      dashDance(pos);
      break;
    case 1:
      jump(pos);
      break;
    case 2:
      groundClash(pos, clash);
      break;
    case 3:
      drop();
      break;
    case 4:
      KO(pos, koX);
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
      canKO = true;
      goTo(anchor.x, anchor.y, 30);
      rotateSpeed = -4;
    } else if (timer == 100) {
      rotateSpeed = 0;
      isReady = true;
    }
  }

  void jump(PVector anchor) {
    timer++;
    if (timer == 1) {
      goToSmooth(anchor.x, anchor.y - jumpHeight, 0.06);
    } else if (timer == 20) {
      goToSmooth(anchor.x, anchor.y, 0.1);
    } else if (timer == 40) {
      isReady = true;
      eventTimer = 0;
    }
  }

  void dashDance(PVector anchor) {
    timer++;
    if (timer == 1) {
      goTo(anchor.x + dashDanceDist, y, 7);
    } else if (timer == 8) {
      goTo(anchor.x - dashDanceDist, y, 7);
    } else if (timer == 15) {
      goTo(anchor.x + dashDanceDist, y, 7);
    } else if (timer == 22) {
      goTo(anchor.x - dashDanceDist, y, 7);
    } else if (timer == 29) {
      goTo(anchor.x, y, 7);
    } else if (timer == 36) {
      isReady = true;
    }
  }

  void drop() {
    timer++;
    goToSmooth(currentAnchor.x, currentAnchor.y, 0.1);
    if (timer == 40) {
      isReady = true;
    }
  }

  void KO(PVector anchor, int koX) {
    if (other.canKO) {

      timer++;

      if (koType < 4) {
        if (timer == 1) { 
          goTo(koX, anchor.y, 30);
        } else if (timer == 30) {
          goTo(koX, height + 200, 30);
        } else if (timer == 80) {
          isReady = true;
          startNew();
        }
      } else {
        if (timer == 1) {
          goTo(width/2 + 300, -200, 20);
        } else if (timer == 20) {
          rotateSpeed = 30;
          scale = 0.15;
          goTo(width/2, 150, 150);
        } else if (timer == 150) {
          isReady = true;
          startNew();
        }
      }
    }
  }

  void chacha() {
    pushMatrix();
    translate(x, y);
    rotateIt();
    scale(scale);
    image(character[rosterNum], 0, 0);
    popMatrix();
  }
}
