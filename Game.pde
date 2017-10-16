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
  PImage boostImage1;
  PImage bulletImage;
  PImage asteroidImage;

  PFont opensans;

  // Game over
  float fade = 0;

  Game() {

    // Load assets
    starImage = loadImage("assets/star.png");
    bulletImage = loadImage("assets/bullet.png");
    shipImage1 = loadImage("assets/ship_1.png");
    boostImage1 = loadImage("assets/boost_1.png");
    asteroidImage = loadImage("assets/asteroid.png");

    opensans = createFont("assets/OpenSans-SemiBold.ttf", 32);

    // Set loadFont
    textFont(opensans);

    wave = new WaveController(2, this);
    star = new Star(this);
    player = new Ship(300, 300, this);
    hud = new HUD(this);
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

  void checkPlanetCollision() {
    for (Entity a : asteroids) {
      if (abs(a.position.x - star.position.x) < (a.size/2 + star.size/2) && abs(a.position.y - star.position.y) < (a.size/2 + star.size/2)) {
        star.damage(a.getHealth());
        System.out.println(a.getHealth());
        a.destroy(false);
      }
    }
  }

  void gameOver(int score) {
    color bg = color(33, 33, 33, (fade * 255));
    color text = color(231, 76, 60, (fade * 255));

    //System.out.println("Score : " + score);
    rectMode(CORNER);
    fill(bg);
    rect(0, 0, width, height);

    fill(text);
    textSize(100);
    textAlign(CENTER, BOTTOM);
    text("GAME OVER", width/2, height/2 - 50);

    if (fade < 1) fade += 0.01;
  }
}
