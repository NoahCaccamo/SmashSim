
Table ultimateData;

String[] pickPercents;

PImage bg;
PImage[] character = new PImage[45];

SmashCharacter p1 = new SmashCharacter(width/2, height/2);

PVector defSize = new PVector(250, 550);
float picScale = 0.5;

PVector p1Pos = new PVector(320, 470);
PVector p1Clash = new PVector(600, 480);
PVector p1Peak = new PVector(325, 200);


void setup() {
  size(1280, 720);
  imageMode(CENTER);
  rectMode(CENTER);

  ultimateData = loadTable("Ultimate Data.csv", "header");
  pickPercents = ultimateData.getStringColumn("Play %");

print(ultimateData.getStringColumn("Character")[characterSelect()]);
  bg = loadImage("battlefield.jpg");
  for (int i=0; i< character.length; i++) {
    String filename = "char" + i + ".png";
    character[i] = loadImage(filename);
  }
}

void draw() {
  background(0);
  image(bg, width/2, height/2);

  p1.stateMachine();
  p1.travel();
  p1.display();
  p1.chacha();
  //println(mouseX, mouseY);
}


void mousePressed() {
  p1.timer = 0;
  p1.state = 2;
  p1.rosterNum++;
  //p1.goTo(mouseX, mouseY, 100);
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
