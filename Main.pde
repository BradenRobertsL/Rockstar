class Main implements Scene {

  PImage header;

  ArrayList<Button> menu;

  Button play;
  Button difficulty;
  Button exit;

  int dLevel = 1;         // Difficulty int level (default 1 - easy)
  String dText = "EASY";  // Difficulty button text

  Main() {

    // Load assets
    header = loadImage("assets/header.png");

    play = new Button(width/2, height/2 - 40, "PLAY");
    exit = new Button(width/2, height/2 + 160, "EXIT");
    difficulty = new Button(width/2, height/2 + 60, "DIFFICULTY: " + dText);

    // Initiate menu
    menu = new ArrayList<Button>();

    menu.add(play);
    menu.add(difficulty);
    menu.add(exit);
  }

  // Main scene loop
  void drawScene() {
    //background(52,73,94);
    background(41,128,185);

    image(header, width/2 - header.width/2, 100);

    play.render();
    difficulty.render();
    exit.render();
  }

  // Check for clicks on buttons
  void onMouseClick() {
    for (Button b : menu) {
      if (b.onButton) {
        switch (b.text) {
          case "PLAY":
            currentScene = new Game(dLevel);
            break;
          case "EXIT":
            exit();
            break;
          default:
            setDifficulty();
            break;
        }
      }
    }
  }

  void setDifficulty() {
    switch (dLevel) {
      case 1:
        dLevel = 2;
        dText = "NORMAL";
        break;
      case 2:
        dLevel = 3;
        dText = "INSANE";
        break;
      case 3:
        dLevel = 1;
        dText = "EASY";
        break;
    }

    // Update button text
    difficulty.updateText("DIFFICULTY: " + dText);
  }

  void onMouseDrag() {}
  void onMouseRelease() {}
  void onMouseMoved() {}
}
