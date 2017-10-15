class Game implements Scene {
  
  Ship player;
  Star star;
  WaveController wave;
  
  ArrayList<Entity> bullets = new ArrayList<Entity>();
  ArrayList<Entity> asteroids = new ArrayList<Entity>();
  
  PImage starImage;
  PImage shipImage1;
  PImage boostImage1;
  
  Game() {
    
    // Load assets
    starImage = loadImage("assets/star.png");
    shipImage1 = loadImage("assets/ship_1.png");
    boostImage1 = loadImage("assets/boost_1.png");
    
    wave = new WaveController(1, this);
    star = new Star(this);
    player = new Ship(300, 300, this);
  }
  
  // Main scene loop
  void drawScene() {
    background(52,73,94);
    
    wave.play();
    
    checkBulletCollision();
    checkPlanetCollision();
    
    player.update();
    star.update();
    
    bullets   = cleanUp(bullets);
    asteroids = cleanUp(asteroids);
    
    update(bullets);
    
    update(asteroids);
    render(asteroids);
    
    star.render();
    render(bullets);
    player.render();
    

    
    // Check movement
    if (up) {
      player.move("forward");
    }
    
    if (down) {
      player.move("reverse");
    }
    if (mousePressed)
      player.fire = true;
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
          b.destroy();
        }
      }
    }
  }
  
  void checkPlanetCollision() {
    for (Entity a : asteroids) {
      if (abs(a.position.x - star.position.x) < (a.size/2 + star.size/2) && abs(a.position.y - star.position.y) < (a.size/2 + star.size/2)) {
        star.damage(a.getHealth());
        System.out.println(a.getHealth());
        a.destroy();
      }
    }
  }
}