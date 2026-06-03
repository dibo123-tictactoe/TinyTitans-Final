float boardAIX = 400; 
float boardAIY = 320;
PImage p1TurnImg, aiTurnImg;
PImage duringGameBgAiImg;
float aiMoveTimer = 0;
boolean isWaitingForAI = false;
int turn = 1;
boolean resultSoundTriggered = false;
boolean isResultScreen = false;

void setupDuringGameAI() {
  duringGameBgAiImg = loadImage("DuringgameBgAi.png");
  p1TurnImg = loadImage("PLRTURN.png");
  aiTurnImg = loadImage("AITURN.png");
}

void drawDuringGameAIScreen() {
  imageMode(CORNER);
  if (duringGameBgAiImg != null) {
    image(duringGameBgAiImg, 0, 0, width, height);
  } else {
    background(0);
  }

  // Turn indicator
  if (winner == 0) {
    imageMode(CENTER);
    if (turn == 1) {
      if (p1TurnImg != null) image(p1TurnImg, 400, 580, 100, 60);
    } else {
      if (aiTurnImg != null) image(aiTurnImg, 400, 580, 300, 60);
    }
    imageMode(CORNER);
  }

  // Audio Priority Switch
  if (winner != 0) {
    if (!isResultScreen) {
      if (duringGameMusic != null) {
        duringGameMusic.amp(0.0);
        duringGameMusic.stop(); 
      }
      if (winner == 1) {
        youWonSound.amp(1.0);
        youWonSound.loop();
      } else if (winner == 2) {
        youLoseSound.amp(1.0);
        youLoseSound.loop();
      } else if (winner == 3) {
        drawSound.amp(1.0);
        drawSound.loop();
      }
      isResultScreen = true;
    }
  } else {
    if (!isResultScreen && duringGameMusic != null && !duringGameMusic.isPlaying()) {
      duringGameMusic.amp(0.5);
      duringGameMusic.loop();
    }
  }

  // 1-second AI delay
  if (isWaitingForAI) {
    if (millis() - aiMoveTimer >= 1000) {
      makeAIMove();
      winner = checkWinner();
      if (winner != 0 && !scoreUpdated) {
        if (winner == 1) p1Score++;
        else if (winner == 2) p2Score++;
        scoreUpdated = true;
      }
      isWaitingForAI = false;
      turn = 1;
    }
  }

  // Player character icon — LEFT side (blue side)
  imageMode(CENTER);
  if (selectedP1 != -1 && selectedP1 < charImgs.length) {
    image(charImgs[selectedP1], 170, 300, 70, 70);
  }

  // AI character icon — RIGHT side
  if (selectedAI != -1 && selectedAI < charImgs.length) {
    image(charImgs[selectedAI], 630, 300, 70, 70);
  }
  imageMode(CORNER);

  // Score Display
  fill(255); 
  textSize(16); 
  textAlign(CENTER, CENTER);
  text("SCORE: " + p1Score, 85, 300);
  text("AI SCORE: " + p2Score, 715, 300);

  // Grid rendering
  float cellSize = 120;
  float boardLeft = boardAIX - 180;
  float boardTop  = boardAIY - 180;
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      float x = boardLeft + (c * cellSize) + (cellSize / 2);
      float y = boardTop  + (r * cellSize) + (cellSize / 2);
      imageMode(CENTER);
      if (boardState[r][c] == 1) {
        if (selectedP1 >= 0 && selectedP1 < charImgs.length)
          image(charImgs[selectedP1], x, y, 100, 100);
      } else if (boardState[r][c] == 2) {
        if (selectedAI >= 0 && selectedAI < charImgs.length)
          image(charImgs[selectedAI], x, y, 100, 100);
      }
      imageMode(CORNER);
    }
  }
}

void mousePressedDuringGameAI() {
  if (gameState != 5 || winner != 0 || isWaitingForAI || turn != 1) return;
  int r = (mouseY - 150) / 100;
  int c = (mouseX - 250) / 100;
  if (r >= 0 && r < 3 && c >= 0 && c < 3 && boardState[r][c] == 0) {
    boardState[r][c] = 1;
    winner = checkWinner();
    if (winner == 0) {
      isWaitingForAI = true;
      turn = 2;
      aiMoveTimer = millis();
    } else {
      if (winner == 1 && !scoreUpdated) {
        p1Score++;
        scoreUpdated = true;
      }
    }
  }
}

void makeAIMove() {
  ArrayList<Integer> emptyCells = new ArrayList<Integer>();
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (boardState[i][j] == 0) emptyCells.add(i * 3 + j);
    }
  }
  if (emptyCells.size() > 0) {
    int randomChoice = emptyCells.get(int(random(emptyCells.size())));
    boardState[randomChoice / 3][randomChoice % 3] = 2;
  }
}
