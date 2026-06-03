PImage[] aiCardImgs = new PImage[5];
PImage leftArrowImg, rightArrowImg, start2Img;
int aiCardIndex = 0;
int selectedAI = -1;
int leftArrX = 370, leftArrY = 250, arrW = 60, arrH = 70;
int rightArrX = 650, rightArrY = 250;
int start2BtnX = 460, start2BtnY = 450, start2BtnW = 160, start2BtnH = 80;
boolean aiMusicStarted = false;

void setupPlayerVsAI() {
  aiCardImgs[0] = loadImage("eagleAI.png");
  aiCardImgs[1] = loadImage("chickenAI.png");
  aiCardImgs[2] = loadImage("ratAI.png");
  aiCardImgs[3] = loadImage("carabaoAI.png");
  aiCardImgs[4] = loadImage("cockroachAI.png");
  leftArrowImg = loadImage("leftarrow.png");
  rightArrowImg = loadImage("rightarrow.png");
  start2Img = loadImage("start2.png");
}

void drawPlayerVsAIScreen() {
  if (!aiMusicStarted) {
    playCharacterSound(aiCardIndex);
    aiMusicStarted = true;
  }

  background(0);

  imageMode(CENTER);
  if (aiCardImgs[aiCardIndex] != null) {
    image(aiCardImgs[aiCardIndex], 400, 300, 800, 600);
  }

  imageMode(CORNER);
  if (leftArrowImg != null) image(leftArrowImg, leftArrX, leftArrY, arrW, arrH);
  if (rightArrowImg != null) image(rightArrowImg, rightArrX, rightArrY, arrW, arrH);

  imageMode(CENTER);
  if (start2Img != null) {
    image(start2Img, start2BtnX + start2BtnW / 2, start2BtnY + start2BtnH / 2, start2BtnW, start2BtnH);
  }
  imageMode(CORNER);
}

void mousePressedPlayerVsAI() {
  if (mouseX >= rightArrX && mouseX <= rightArrX + arrW &&
      mouseY >= rightArrY && mouseY <= rightArrY + arrH) {
    aiCardIndex = (aiCardIndex + 1) % 5;
    playCharacterSound(aiCardIndex);
  } else if (mouseX >= leftArrX && mouseX <= leftArrX + arrW &&
             mouseY >= leftArrY && mouseY <= leftArrY + arrH) {
    aiCardIndex = (aiCardIndex - 1 + 5) % 5;
    playCharacterSound(aiCardIndex);
  } else if (mouseX >= start2BtnX && mouseX <= start2BtnX + start2BtnW &&
             mouseY >= start2BtnY && mouseY <= start2BtnY + start2BtnH) {
    stopAllCharacterSounds();

    selectedP1 = aiCardIndex;

    do {
      selectedAI = int(random(0, 5));
    } while (selectedAI == selectedP1);

    if (music != null && music.isPlaying()) music.stop();

    boardState = new int[3][3];
    turn = 1;
    winner = 0;
    resultSoundPlayed = false;
    isResultScreen = false;
    scoreUpdated = false;
    aiMusicStarted = false;

    gameState = 5;
  }
}
