// Game scenes.
Scene mainMenu;
Scene game;
Scene currentScene; // Scene visible.

// Input Booleans.
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean fire = false;
boolean enter = false;

void setup() {

  size(1360, 765);
  frameRate(30);

  mainMenu = new Main();
  currentScene = mainMenu;
}

// Draws the current scene.
void draw() {
  currentScene.drawScene();
}

// Input Events passed on to current scene.
void mouseClicked() { currentScene.onMouseClick(); }
void mouseDragged() { currentScene.onMouseDrag(); }
void mouseMoved() { currentScene.onMouseMoved(); }

// Checks for key pressed.
void keyPressed() {
  // Checking key input.
  if (key != CODED) {
    switch (key) {
      case 'w':
        up = true;
        break;
      case 's':
        down = true;
        break;
      case 'a':
        left = true;
        break;
      case 'd':
        right = true;
        break;
      case ENTER:
        enter = true;
        break;
    }
  } else {
    switch (keyCode) {
      case UP:
        up = true;
        break;
      case DOWN:
        down = true;
        break;
      case LEFT:
        left = true;
        break;
      case RIGHT:
        right = true;
        break;
    }
  }
}

// Checks for key released.
void keyReleased() {
  // Checking key input.
  if (key != CODED) {

    switch (key) {
      case 'w':
        up = false;
        break;
      case 's':
        down = false;
        break;
      case 'a':
        left = false;
        break;
      case 'd':
        right = false;
        break;
      case ENTER:
        enter = false;
        break;
    }

  } else {

    switch (keyCode) {
      case UP:
        up = false;
        break;
      case DOWN:
        down = false;
        break;
      case LEFT:
        left = false;
        break;
      case RIGHT:
        right = false;
        break;

    }
  }
}
