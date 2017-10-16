class Game implements Scene {

  Ship player;
  Star star;
  WaveController wave;
  HUD hud;

  boolean alive = true;

  ArrayList<Entity> bullets = new ArrayList<Entity>();
  ArrayList<Entity> asteroids = new ArrayList<Entity>();

  // Assets
  PImage starImage;
  PImage shipImage1;
  PImage shipImage2;
  PImage boostImage1;
  PImage boostImage2;
  PImage bulletImage;
  PImage asteroidImage;
  PImage powerupHealImage;
  PImage powerupShieldImage;

  PImage asteroidIcon;

  PFont opensans;

  // Game over
  float fade = 0;
  Button exit;

  Game(int difficulty) {

    // Load assets
    starImage = loadImage("assets/star.png");
    bulletImage = loadImage("assets/bullet.png");
    shipImage1 = loadImage("assets/ship_1.png");
    shipImage2 = loadImage("assets/ship_2.png");
    boostImage1 = loadImage("assets/boost_1.png");
    boostImage2 = loadImage("assets/boost_2.png");
    asteroidImage = loadImage("assets/asteroid.png");
    asteroidIcon = loadImage("assets/asteroidIcon.png");
    powerupHealImage = loadImage("assets/powerup_heal.png");
    powerupShieldImage = loadImage("assets/powerup_shield.png");

    opensans = createFont("assets/OpenSans-SemiBold.ttf", 32);

    // Set loadFont
    textFont(opensans);

    wave = new WaveController(difficulty, this);
    star = new Star(this);
    player = new Ship(300, 300, this);
    hud = new HUD(this);

    // Buttons
    exit = new Button(width/2, height - 120, color(231,76,60), "RETURN TO MENU");
  }

  // Main scene loop
  void drawScene() {
    background(52,73,94);

    wave.play();

    checkBulletCollision();
    checkPlanetCollision();

    if (alive) player.update();
    star.update();

    bullets   = cleanUp(bullets);
    asteroids = cleanUp(asteroids);

    star.render();
    render(bullets);
    render(asteroids);
    player.render();

    if (alive) {
      update(bullets);
      update(asteroids);
    }

    hud.drawHUD();

    // Check movement
    if (up && alive) {
      player.move("forward");
    }

    if (down && alive) {
      player.move("reverse");
    }
    if (mousePressed && alive)
      player.fire = true;

    // Check game over
    if (!alive)
      gameOver(player.score);
  }

  // Mouse handlers
  void onMouseClick() {}
  void onMouseDrag() {}
  void onMouseRelease() {}
  void onMouseMoved() {}

  void addBullet(float x, float y) {
    bullets.add(new Bullet(x, y, this));
  }

  void addAsteroid(float size, float speed, float x, float y) {
    asteroids.add(new Asteroid(size, speed, x, y, this));
  }

  // Renders entities
  void render(ArrayList<Entity> entity) {
    for (Entity e : entity) {
      if (e.getActive()) {
        e.render();
      }
    }
  }

  // Updates entities
  void update(ArrayList<Entity> entity) {
    for (Entity e : entity) {
      e.update();
    }
  }

  // Cleans lists of inactive (dead) entities, returns a list without inactive entities
  ArrayList<Entity> cleanUp(ArrayList<Entity> entity) {
    ArrayList<Entity> cleanList = new ArrayList<Entity>();
    // Filter out active objects
    for (Entity e : entity) {
      if (e.getActive())
        cleanList.add(e);
    }
    return cleanList;
  }

  // Checks any asteroids being hit by bullets
  void checkBulletCollision() {
    for (Entity a : asteroids) {
      for (Entity b : bullets) {
        boolean collided = a.checkOverlap(b);
        if (collided) {
          a.damage(b.getDamage());
          b.destroy(true);
        }
      }
    }
  }

  // Checks any asteroids crashing into planet
  void checkPlanetCollision() {
    for (Entity a : asteroids) {
      if (abs(a.position.x - star.position.x) < (a.size/2 + star.size/2) && abs(a.position.y - star.position.y) < (a.size/2 + star.size/2)) {
        star.damage(a.getHealth());
        System.out.println(a.getHealth());
        a.destroy(false);
      }
    }
  }

  // Renders game over screen calculates score
  void gameOver(int score) {
    color bg = color(33, 33, 33, (fade * 255));
    color text = color(231, 76, 60, (fade * 255));
    color scoreText = color(255, 255, 255, (fade * 255));

    //System.out.println("Score : " + score);
    rectMode(CORNER);
    fill(bg);
    rect(0, 0, width, height);

    fill(text);
    textSize(100);
    textAlign(CENTER, BOTTOM);
    text("GAME OVER", width/2, height/2 - 50);

    fill(scoreText);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("SCORE: " + (score * wave.difficulty), width/2, height/2 + 10);

    if (fade < 1) fade += 0.01;
    else {
      exit.render();
      if (exit.onButton && mousePressed) currentScene = mainMenu;
    }
  }
}
