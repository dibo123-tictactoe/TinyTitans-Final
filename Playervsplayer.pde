int selectedP1 = -1;
int selectedP2 = -1;
boolean p1Locked = false;
boolean p2Locked = false;

PImage[] charImgs = new PImage[5];
PImage[] nameImgs = new PImage[5];
PImage charBoard, selectBtnImg;
PImage p1Img, p2Img, vsImg, startImg;

String errorMessage = "";
int errorTimer = 0;
PFont errorFont;

int[] gx = new int[5];
int[] gy = new int[5];
int cellW = 110, cellH = 110;

int startBtnX = 400 - 70;
int startBtnY = 460;
int startBtnW = 150, startBtnH = 100;

boolean isPvPResultScreen = false;

void setupCharacterSelect() {
  charImgs[0] = loadImage("eagle.png");
  charImgs[1] = loadImage("chicken.png");
  charImgs[2] = loadImage("rat.png");
  charImgs[3] = loadImage("carabao.png");
  charImgs[4] = loadImage("cockroach.png");

  nameImgs[0] = loadImage("AGILA.png");
  nameImgs[1] = loadImage("MANOK.png");
  nameImgs[2] = loadImage("DAGA.png");
  nameImgs[3] = loadImage("KALABAW.png");
  nameImgs[4] = loadImage("IPIS.png");

  charBoard = loadImage("charboard2.png");
  selectBtnImg = loadImage("selectbutton.png");
  p1Img = loadImage("player1.png");
  p2Img = loadImage("player2.png");
  vsImg = loadImage("vs.png");
  startImg = loadImage("start.png");
}

void drawCharacterSelectScreen() {
  background(0);
  stroke(255, 0, 0);
  noFill();
  rectMode(CORNER);

  if (bg != null) {
    image(bg, 0, 0, 800, 600);
  }

  int cW = 550, cH = 500;
  int cX = 140;
  int cY = 50;
  if (charBoard != null) {
    image(charBoard, cX, cY, cW, cH);
  } else {
    fill(30, 80, 120, 200);
    stroke(160, 220, 255);
    strokeWeight(2);
    rect(cX, cY, cW, cH, 10);
    noStroke();
  }

  int boardCenterX = cX + cW / 2;
  int row1Y = cY + 220;
  int row2Y = cY + 310;
  gx[0] = boardCenterX - 160; gy[0] = row1Y;
  gx[1] = boardCenterX;        gy[1] = row1Y;
  gx[2] = boardCenterX + 160; gy[2] = row1Y;
  gx[3] = boardCenterX - 80;  gy[3] = row2Y;
  gx[4] = boardCenterX + 80;  gy[4] = row2Y;

  for (int i = 0; i < 5; i++) {
    imageMode(CENTER);
    if (charImgs[i] != null) {
      if (i == 1) image(charImgs[i], gx[i], gy[i], 120, 130);
      else if (i == 4) image(charImgs[i], gx[i], gy[i], 120, 200);
      else if (i == 0) image(charImgs[i], gx[i], gy[i], 130, 150);
      else if (i == 2) image(charImgs[i], gx[i], gy[i], 120, 108);
      else image(charImgs[i], gx[i], gy[i], 120, 120);
    }
    imageMode(CORNER);
  }

  drawPlayerSlot(1, 100, 300, selectedP1, p1Locked);
  drawPlayerSlot(2, 700, 300, selectedP2, p2Locked);

  imageMode(CENTER);
  if (p1Img != null) image(p1Img, 100, 140, 240, 90);
  if (vsImg != null) image(vsImg, 400, 105, 160, 90);
  if (p2Img != null) image(p2Img
