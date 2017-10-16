class Main implements Scene {

  PImage header;
  PImage buttonPlay;
  PImage buttonExit;
  PImage buttonSelected;

  int selectedButton = 0;

  Button a;
  Button b;
  Button c;

  Main() {

    // Load assets
    header = loadImage("assets/header.png");
    buttonPlay = loadImage("assets/button_play.png");
    buttonExit = loadImage("assets/button_exit.png");
    buttonSelected = loadImage("assets/button_selected.png");

    b = new Button(10, 10, "PLAY");
    a = new Button(10, 300, "EXIT");
    c = new Button(10, 90, "DIFFICULTY: EASY");
  }

  // Main scene loop
  void drawScene() {
    background(52,73,94);
    image(header, width/2 - header.width/2, 75);
    image(buttonPlay, width/2 - buttonPlay.width/2, 400 - buttonPlay.height/2);
    image(buttonExit, width/2 - buttonExit.width/2, 550 - buttonExit.height/2);

    // Draw selected button marker
    if (selectedButton == 0)
      image(buttonSelected, width/2 - buttonSelected.width/2, 400 - buttonSelected.height/2);
    else
      image(buttonSelected, width/2 - buttonSelected.width/2, 550 - buttonSelected.height/2);

    // Check input
    if (up) {
      if (selectedButton == 1)
        selectedButton = 0;
    }

    if (down) {
      if (selectedButton == 0)
        selectedButton = 1;
    }

    if (enter) {
      if (selectedButton == 0)
        currentScene = game;
      else
        exit();
    }

    a.render();
    b.render();
    c.render();
  }

  // Mouse handlers
  void onMouseClick() {
    if (mouseInsideButton(buttonPlay, 400))
      currentScene = new Game();
    if (mouseInsideButton(buttonExit, 550))
      exit();
  }

  void onMouseDrag() {}
  void onMouseRelease() {}
  void onMouseMoved() {
    if (mouseInsideButton(buttonPlay, 400))
      selectedButton = 0;
    if (mouseInsideButton(buttonExit, 550))
      selectedButton = 1;
  }

  boolean mouseInsideButton(PImage button, int yPos) {
    if ( mouseX < width/2 + button.width/2 && mouseX > width/2 - button.width/2) {
      return ( mouseY < yPos + button.height/2 && mouseY > yPos - button.height/2);
    }

    // Not inside
    return false;
  }
}
