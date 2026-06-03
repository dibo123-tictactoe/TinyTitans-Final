PImage p1WonImg, p2WonImg, drawImg;
PImage youWonImg, youLoseImg;
boolean resultSoundPlayed = false;

void setupGameResult() {
  p1WonImg   = loadImage("PLR1won.png");
  p2WonImg   = loadImage("PLR2won.png");
  drawImg    = loadImage("DRAWwon.png");
  youWonImg  = loadImage("YOUWON.png");
  youLoseImg = loadImage("YOULOSE.png");
}

void drawGameResultScreen() {
  if (!resultSoundPlayed) {
    if (duringGameMusic != null && duringGameMusic.isPlaying()) {
      duringGameMusic.stop();
    }
    if (gameState == 5) {
      if (winner == 1) {
        if (youWonSound != null) { youWonSound.stop(); youWonSound.loop(); }
      } else if (winner == 2) {
        if (youLoseSound != null) { youLoseSound.stop(); youLoseSound.loop(); }
      } else if (winner == 3) {
        if (drawSound != null) { drawSound.stop(); drawSound.loop(); }
      }
    } else {
      if (winner == 1 || winner == 2) {
        if (youWonSound != null) { youWonSound.stop(); youWonSound.loop(); }
      } else if (winner == 3) {
        if (drawSound != null) { drawSound.stop(); drawSound.loop(); }
      }
    }
    resultSoundPlayed = true;
  }

  fill(0, 0, 0, 150);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height);
  imageMode(CENTER);

  if (gameState == 5) {
    if (winner == 1 && youWonImg != null)       image(youWonImg,  width/2, height/2, 700, 500);
    else if (winner == 2 && youLoseImg != null)  image(youLoseImg, width/2, height/2, 700, 500);
    else if (winner == 3 && drawImg != null)     image(drawImg,    width/2, height/2, 700, 500);
  } else {
    if (winner == 1 && p1WonImg != null)         image(p1WonImg, width/2, height/2, 700, 500);
    else if (winner == 2 && p2WonImg != null)     image(p2WonImg, width/2, height/2, 700, 500);
    else if (winner == 3 && drawImg != null)      image(drawImg,  width/2, height/2, 700, 500);
  }

  imageMode(CORNER);
}

void mousePressedGameResult() {
  println("Clicked at: " + mouseX + ", " + mouseY);

  if (mouseX > 280 && mouseX < 400 && mouseY > 420 && mouseY < 520) {
    if (youWonSound  != null && youWonSound.isPlaying())  youWonSound.stop();
    if (youLoseSound != null && youLoseSound.isPlaying()) youLoseSound.stop();
    if (drawSound    != null && drawSound.isPlaying())    drawSound.stop();

    resultSoundPlayed = false;
    isResultScreen    = false;
    isPvPResultScreen = false;

    if (duringGameMusic != null) {
      duringGameMusic.amp(0.5);
      duringGameMusic.loop();
    }

    winner       = 0;
    turn         = 1;
    boardState   = new int[3][3];
    scoreUpdated = false;
    gameState    = (gameState == 5) ? 5 : 3;
  }

  else if (mouseX > 440 && mouseX < 560 && mouseY > 420 && mouseY < 520) {
    if (youWonSound  != null && youWonSound.isPlaying())  youWonSound.stop();
    if (youLoseSound != null && youLoseSound.isPlaying()) youLoseSound.stop();
    if (drawSound    != null && drawSound.isPlaying())    drawSound.stop();
    exit();
  }
}

int checkWinner() {
  for (int r = 0; r < 3; r++) {
    if (boardState[r][0] != 0 &&
        boardState[r][0] == boardState[r][1] &&
        boardState[r][1] == boardState[r][2])
      return boardState[r][0];
  }
  for (int c = 0; c < 3; c++) {
    if (boardState[0][c] != 0 &&
        boardState[0][c] == boardState[1][c] &&
        boardState[1][c] == boardState[2][c])
      return boardState[0][c];
  }
  if (boardState[0][0] != 0 &&
      boardState[0][0] == boardState[1][1] &&
      boardState[1][1] == boardState[2][2]) return boardState[0][0];
  if (boardState[0][2] != 0 &&
      boardState[0][2] == boardState[1][1] &&
      boardState[1][1] == boardState[2][0]) return boardState[0][2];

  for (int r = 0; r < 3; r++)
    for (int c = 0; c < 3; c++)
      if (boardState[r][c] == 0) return 0;

  return 3;
}
