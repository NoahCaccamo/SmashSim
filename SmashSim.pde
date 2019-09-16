import processing.sound.*;

SoundFile lifelight, tomorrowIsMine, lifeWillChange, gangplankGalleon, marchOfTheDeliverance, jumpUpSuperstar;

Table ultimateData;

String[] pickPercents;
String[] winPercents;

PImage bg;
PImage title;
PImage[] character = new PImage[78];

PVector defSize = new PVector(250, 550);
float picScale = 0.5;

PVector p1Pos = new PVector(320, 470);
PVector p1Clash = new PVector(600, 480);
PVector p1Peak = new PVector(325, 200);

PVector p2Pos = new PVector(960, 470);
PVector p2Clash = new PVector(680, 480);
PVector p2Peak = new PVector(955, 200);



int jumpHeight = 270;
int platformOffset = 170;
int clashOffset = 280;
int koOffset = 300;

int eventTimer;
int eventSpeed = 20;

int koType;

boolean p1Win;

SmashCharacter p1 = new SmashCharacter(width/2, height/2, p1Pos);
SmashCharacter p2 = new SmashCharacter(width/2, height/2, p2Pos);

int gameState = 0;

void setup() {
  size(1280, 720);
  imageMode(CENTER);
  rectMode(CENTER);

  ultimateData = loadTable("Ultimate Data.csv", "header");
  pickPercents = ultimateData.getStringColumn("Play %");
  winPercents = ultimateData.getStringColumn("Win %");


  bg = loadImage("battlefield.jpg");
  title = loadImage("title.jpg");
  for (int i=0; i< character.length; i++) {
    String filename = "char" + i + ".png";
    character[i] = loadImage(filename);
  }

  lifelight = new SoundFile(this, "Lifelight.wav");
  tomorrowIsMine = new SoundFile(this, "Tomorrow Is Mine.wav");
  lifeWillChange = new SoundFile(this, "Life Will Change.wav");
  gangplankGalleon = new SoundFile(this, "Gangplank Galleon.wav");
  marchOfTheDeliverance = new SoundFile(this, "March Of The Deliverance.wav");
  jumpUpSuperstar = new SoundFile(this, "Jump Up, Super Star!.wav");

  p1.other = p2;
  p2.other = p1;

  startNew();
}

void draw() {
  if (gameState == 0) {
    MainMenu();
  } else {
    BattleSim();
  }
}

void MainMenu() {
  image(title, width/2, height/2);
  textSize(25);
  fill(0);
  text("Press to start: 1. No Music  2. Lifelight  3. Tomorrow Is Mine 4. Life Will Change 5. Gangplank Galleon\n                      6. March of the Deliverance 7. Jump Up Super Star!", 20, height - 100);
  if (key == '1') {
    gameState = 1;
  }
  if (key == '2') {
    lifelight.loop();
    gameState = 1;
  }
  if (key == '3') {
    tomorrowIsMine.loop();
    gameState = 1;
  }
  if (key == '4') {
    lifeWillChange.loop();
    gameState = 1;
  }
  if (key == '5') {
    gangplankGalleon.loop();
    gameState = 1;
  }
  if (key == '6') {
    marchOfTheDeliverance.loop();
    gameState = 1;
  }
  if (key == '7') {
    jumpUpSuperstar.loop();
    gameState = 1;
  }
}

void BattleSim() {
  image(bg, width/2, height/2);

  eventHandler();

  p1.stateMachine(p1.currentAnchor, p1.currentClash, (int)p1.currentAnchor.x - koOffset);
  p1.travel();
  p1.display();
  p1.chacha();

  p2.stateMachine(p2.currentAnchor, p2.currentClash, (int)p2.currentAnchor.x + koOffset);
  p2.travel();
  p2.display();
  p2.chacha();
}


void startNew() {
  p1.scale = 0.5;
  p2.scale = 0.5;
  p1.rotateSpeed = 0;
  p2.rotateSpeed = 0;

  int charS = characterSelect();
  p1.rosterNum = charS;
  p2.rosterNum = int(random(78));

  float winP = float(winPercents[charS]);
  float winSelect = random(0, 1);
  if (winP >= winSelect) {
    p1Win = true;
  } else {
    p1Win = false;
  }

  p1.state = 3;
  p2.state = 3;

  p1.isReady = true;
  p2.isReady = true;
  p1.timer = 0;
  p2.timer = 0;
}


void eventHandler() {
  eventTimer++;

  if (p1.state == 4) {
    p2.isReady = false;
  }
  if (p2.state == 4) {
    p1.isReady = false;
  }

  if (eventTimer >= eventSpeed && p1.isReady == true && p2.isReady == true) {
    int chooseEventP1 = int(random(0, 4));
    int chooseEventP2 = int(random(0, 4));

    p1.isReady = false;
    p2.isReady = false;
    if (p1.state != 4 || p2.state != 4) {
      p1.canKO = false;
      p2.canKO = false;
    }
    p1.timer = 0;
    p2.timer = 0;
    p1.state = chooseEventP1;
    p2.state = chooseEventP2;

    if (chooseEventP1 == 1) {
      p1.isGrounded = false;
      p1.currentAnchor = new PVector(p1.currentAnchor.x, p1Pos.y - platformOffset);
    } else if (chooseEventP1 == 2) {
      if (p1Win) {
        int finishHit = int(random(0, 2));
        if (finishHit == 0) {
          p2.timer = 0;
          p1.isReady = false;
          p2.state = 4;
          koType = int(random(0, 6));
        }
      }
    } else if (chooseEventP1 == 3) {
      p1.isGrounded = true;
      p1.currentAnchor = p1Pos;
    }
    if (chooseEventP2 == 1) {
      p2.isGrounded = false;
      p2.currentAnchor = new PVector(p2.currentAnchor.x, p2Pos.y - platformOffset);
    } else if (chooseEventP2 == 2) {
      if (!p1Win) {
        int finishHit = int(random(0, 2));
        if (finishHit == 0) {
          p1.timer = 0;
          p2.isReady = false;
          p1.state = 4;
          koType = int(random(0, 6));
        }
      }
    } else if (chooseEventP2 == 3) {
      p2.isGrounded = false;
      p2.currentAnchor = p2Pos;
    }

    if (p1.state == 2 && p2.state == 2) {
      p1.currentClash = new PVector(p1Pos.x + clashOffset, p2.y);
      p2.currentClash = new PVector(p2Pos.x - clashOffset, p1.y);
    } else {
      p1.currentClash = new PVector(p2.x - 60, p2.y); 
      p2.currentClash = new PVector(p1.x + 60, p1.y);
    }
  }
}


int characterSelect() {
  float charSelect = random(0, 1);
  float charAccumulative = 0;
  for (int i = 0; i < pickPercents.length; i++) {
    charAccumulative += float(pickPercents[i]);
    if (charSelect <= charAccumulative) {
      return i;
    }
  } 
  return 77;
}
