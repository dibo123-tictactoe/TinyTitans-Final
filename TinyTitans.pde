import gifAnimation.*;
import processing.sound.*;

Gif bg;
PImage titleImg, startBtnImg;

SoundFile music, duringGameMusic, selectSound;
SoundFile[] charSelectSounds = new SoundFile[5];
SoundFile youWonSound, youLoseSound, drawSound;

int gameState = 0;
float scaleH, scaleW;
int[][] boardState = new int[3][3];
int winner = 0;
int p1Score = 0;
int p2Score = 0;
boolean scoreUpdated = false;
boolean showSettings = false;
PImage settingsImg;

void setup() {
  size(800, 600);
  scaleW = (float)width / 800.0;
  scaleH = (float)height / 600.0;

  settingsImg = loadImage("gamesettings.png");
  titleImg    = loadImage("title.png");
  startBtnImg = loadImage("presstostart.png");

  music = new SoundFile(this, "INTRO SOUND.mp3");
  music.loop();

  duringGameMusic = new SoundFile(this, "DURING GAME.mp3");
  selectSound     = new SoundFile(this, "SELECT SOUND.mp3");

  bg = new Gif(this, "front.gif");
  bg.loop();

  setupGameMode();
  setupCharacterSelect();
  setupPlayerVsAI();
  setupDuringGame();
  setupDuringGameAI();
  setupGameResult();
  setupSounds();
}

void setupSounds() {
  charSelectSounds[0] = new SoundFile(this, "SELECTING AGILA 1.mp3");
  charSelectSounds[1] = new SoundFile(this, "SELECTING MANOK.mp3");
  charSelectSounds[2] = new SoundFile(this, "SELECTING DAGA.mp3");
  charSelectSounds[3] = new SoundFile(this, "SELECTING CARABAO.mp3");
  charSelectSounds[4] = new SoundFile(this, "SELECTING IPIS.mp3");

  youWonSound  = new SoundFile(this, "YOUWONSOUND.mp3");
  youLoseSound = new SoundFile(this, "YOULOSESOUND.mp3");
  drawSound    = new SoundFile(this, "DRAWSOUND.mp3");
}

void playCharacterSound(int index) {
  for (int i = 0; i < charSelectSounds.length; i++) {
    if (charSelectSounds[i] != null && charSelectSounds[i].isPlaying()) {
      charSelectSounds[i].stop();
    }
  }
  if (charSelectSounds[index] != null) {
    charSelectSounds[index].loop();
  }
}

void stopAllCharacterSounds() {
  for (int i = 0; i < charSelectSounds.length; i++) {
    if (charSelectSounds[i] != null && charSelectSounds[i].isPlaying()) {
      charSelectSounds[i].stop();
    }
  }
}

void playSelectSound() {
  if (selectSound != null) {
    if (selectSound.isPlaying()) selectSound.stop();
    selectSound.play();
  }
}

void draw() {
  if (gameState == 0 || gameState == 1) {
    if (music != null && !music.isPlaying()) music.loop();
  } else if (gameState != 2) {
    if (music != null && music.isPlaying()) music.stop();
  }

  if (gameState == 3 || gameState == 5) {
    if (winner == 0) {
      if (duringGameMusic != null && !duringGameMusic.isPlaying()) {
        stopAllCharacterSounds();
        duringGameMusic.loop();
      }
    } else {
      if (duringGameMusic != null && duringGameMusic.isPlaying()) {
        duringGameMusic.stop();
      }
    }
  } else {
    if (duringGameMusic != null && duringGameMusic.isPlaying()) duringGameMusic.stop();
  }

  switch (gameState) {
  case 0:
    drawStartScreen();
    break;
  case 1:
    drawGameModeScreen();
    break;
  case 2:
    drawCharacterSelectScreen();
    break;
  case 3:
    drawDuringGameScreen();
    if (winner != 0) drawGameResultScreen();
    break;
  case 4:
    drawPlayerVsAIScreen();
    break;
  case 5:
    drawDuringGameAIScreen();
    if (winner != 0) drawGameResultScreen();
    break;
  }

  if (gameState == 3 || gameState == 5) {
    if (showSettings) {
      fill(0, 0, 0, 150);
      rect(0, 0, width, height);
      if (settingsImg != null) {
        imageMode(CENTER);
        image(settingsImg, width/2, height/2);
        imageMode(CORNER);
      }
    }
  }
}

void drawStartScreen() {
  image(bg, 0, 0, width, height);
  image(titleImg, 100, 150, 600, 300);
  image(startBtnImg, 250, 430, 300, 100);
}

void mousePressed() {
  println("CLICK: " + mouseX + ", " + mouseY);

  if ((gameState == 3 || gameState == 5) &&
    mouseX >= 30 && mouseX <= 70 && mouseY >= 20 && mouseY <= 50) {
    playSelectSound();
    showSettings = !showSettings;
    return;
  }

  if (showSettings) {
    if (mouseX >= 314 && mouseX <= 414 && mouseY >= 221 && mouseY <= 261) {
      playSelectSound();
      showSettings = false;
      return;
    }
    if (mouseX >= 323 && mouseX <= 423 && mouseY >= 278 && mouseY <= 318) {
      playSelectSound();
      p1Score = 0;
      p2Score = 0;
      for (int r = 0; r < 3; r++)
        for (int c = 0; c < 3; c++)
          boardState[r][c] = 0;
      winner            = 0;
      turn              = 1;
      scoreUpdated      = false;
      isResultScreen    = false;
      resultSoundPlayed = false;
      showSettings      = false;
      if (duringGameMusic != null) {
        duringGameMusic.amp(0.5);
        duringGameMusic.loop();
      }
      return;
    }
    if (mouseX >= 327 && mouseX <= 427 && mouseY >= 329 && mouseY <= 369) {
      playSelectSound();
      System.exit(0);
    }
    return;
  }

  if (gameState == 0) {
    if (mouseX > 250 && mouseX < 550 && mouseY > 430 && mouseY < 530) {
      playSelectSound();
      gameState = 1;
    }
  } else if (gameState == 1) {
    mousePressedGameMode();
  } else if (gameState == 2) {
    playSelectSound();
    mousePressedCharacterSelect();
  } else if (gameState == 4) {
    playSelectSound();
    mousePressedPlayerVsAI();
  } else if (gameState == 5 || gameState == 3) {
    if (winner != 0) {
      playSelectSound();
      mousePressedGameResult();
    } else {
      if (gameState == 5) {
        playSelectSound();
        mousePressedDuringGameAI();
      } else {
        mousePressedDuringGame();
      }
    }
  }
}

void mousePressedDuringGame() {
  if (gameState != 3) return;

  float cellSize  = 120;
  float boardLeft = boardX - 225 + 48;
  float boardTop  = boardY - 225 + 30;

  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      float x = boardLeft + (c * cellSize) + (cellSize / 2);
      float y = boardTop  + (r * cellSize) + (cellSize / 2);

      if (dist(mouseX, mouseY, x, y) < cellSize / 2 && boardState[r][c] == 0) {
        playSelectSound();
        boardState[r][c] = turn;
        turn = (turn == 1) ? 2 : 1;
        winner = checkWinner();
        return;
      }
    }
  }
}

void transitionToGameState(int newState) {
  if (music != null)           music.stop();
  if (duringGameMusic != null) duringGameMusic.stop();
  stopAllCharacterSounds();

  gameState = newState;  // ← was outside the function, now moved inside

  if (gameState == 3 || gameState == 5) {
    if (duringGameMusic != null) duringGameMusic.loop();
  } else if (gameState == 0 || gameState == 1) {
    if (music != null) music.loop();
  }
}
