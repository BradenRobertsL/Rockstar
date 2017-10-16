import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Rockstar extends PApplet {

// Game scenes
Scene mainMenu;
Scene game;
Scene currentScene;

// Input Booleans
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean fire = false;

boolean enter = false;

public void setup() {

  
  //fullScreen();
  frameRate(30);

  mainMenu = new Main();
  game = new Game();

  currentScene = mainMenu;
}

public void draw() {
  currentScene.drawScene();
}

// Input Events
public void mouseClicked() { currentScene.onMouseClick(); }
public void mouseDragged() { currentScene.onMouseDrag(); }
public void mouseMoved() { currentScene.onMouseMoved(); }

public void keyPressed() {
  // Checking key input
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

public void keyReleased() {

  // Checking key input
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
class Asteroid extends Entity {

  PVector direction;
  float angle = 0;

  // Asteroid stats
  int healthMultiplier = 2;    // Size multiplied to calculate health
  int health;                  // Health points of asteroid
  float size;                  // Size of asteroid and damage it deals
  float xp;                    // Amount of xp gained on kill
  float speed;                 // Movement speed of asteroid

  Asteroid (float size, float speed, float x, float y, Game game) {
    health = (int) size * healthMultiplier;
    this.size = size;
    this.xp = size;
    this.speed = speed;

    this.game = game;

    position = new PVector(x, y);
    direction = new PVector(width/2, height/2).sub(position);
  }

  public void render() {
    if (active) {
      pushMatrix();
        noStroke();
        fill(255, 20, 20);
        //rectMode(RADIUS);
        translate(position.x, position.y);
        rotate(angle);
        ellipse(0, 0, size/2, size/2);
        fill(255, 255, 255);
        text(health, 0, 0);
      popMatrix();
    }
  }

  public void update() {
    angle += 0.01f;
    position.add(direction.normalize().mult(speed));

    if (health <= 0)
      active = false;
  }

  public void damage(int d){
    health -= d;
  }

  public void destroy(){
    active = false;
    game.player.gainXP(xp);
  }

  public boolean checkOverlap (Entity target) {
    if (Math.pow(target.position.x - position.x, 2.0f) + Math.pow(target.position.y - position.y, 2.0f) < Math.pow(size/2, 2.0f)) {
      return true;
    }
    return false;
  }

  public int getHealth() { return health; }
}
class Bullet extends Entity {
  
  // Temporary Bullet variables
  float bWidth = 2;
  float bHeight = 10;
  
  // Bullet stats
  float speed = 20;
  int damage = 50;
  
  PVector direction;  // Direction the bullet should move
  float angle;        // Angle in which the bullet should face
  
  Bullet(float x, float y, Game game) {
    position = new PVector(x, y);
    direction = new PVector(mouseX, mouseY).sub(position);
    angle = atan2(direction.y, direction.x);
    this.game = game;
  }
  
  public void render() {
    if (active) {
      pushMatrix();
        rectMode(RADIUS);
        fill(255);
        noStroke();
        translate(position.x, position.y);
        rotate(angle);
        rect(0, 0, bHeight, bWidth);
      popMatrix();
    }
  }
    
  public void update() {
    // Update position
    position.add(direction.normalize().mult(speed));
    
    // Check if inside view else de-activate
    if (position.x < 0 || position.x > width || position.y < 0 || position.y > height)
      active = false;
  }
  
  /**
  *  Returns the point at the head of the bullet.
  **/
  public PVector getPoint() {
    return direction.mult(1);
  }
  
  public int getDamage() {
    return damage;
  }
}
class Entity {
  
  Game game;
  boolean active = true;
  
  PVector position; // Entity position
  int health;       // Entities health points
  int damage;       // Entities damage
  float size;       // Size of entity
  
  // Main methods
  
  /**
  * Renders the entity on screen
  **/
  public void render(){};
  
  /**
  * Updates the entities values (position, health etc.)
  **/
  public void update(){
    if (health <= 0)
      active = false;
  }
  
  /**
  *  Applies damage to entities health
  **/
  public void damage(int d){
    health -= d;
  }
  
  /**
  *  De-activates and removes
  **/
  public void destroy(){
    active = false;
  }
  
  /**
  *  Checks if object is within bounds
  **/
  public boolean checkOverlap(Entity target) {
    return false;
  }
  
  /**
  * Gets head point in direction
  **/
  public PVector getPoint() { return null; }
  
  // Getters / Setters
  public boolean getActive() { return active; }
  public void setActive(boolean a) { this.active = a; }
  
  public int getHealth() { return health; }
  public void setHealth(int hp) { this.health = hp; }
  
  public int getDamage() { return damage; }
  public void setDamage(int d) { damage = d; }
}
class Game implements Scene {

  Ship player;
  Star star;
  WaveController wave;

  boolean alive = true;

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

    wave = new WaveController(2, this);
    star = new Star(this);
    player = new Ship(300, 300, this);
  }

  // Main scene loop
  public void drawScene() {
    background(52,73,94);

    wave.play();

    checkBulletCollision();
    checkPlanetCollision();

    if (alive) player.update();
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
    if (up && alive) {
      player.move("forward");
    }

    if (down && alive) {
      player.move("reverse");
    }
    if (mousePressed && alive)
      player.fire = true;
  }

  // Mouse handlers
  public void onMouseClick() {}
  public void onMouseDrag() {}
  public void onMouseRelease() {}
  public void onMouseMoved() {}

  public void addBullet(float x, float y) {
    bullets.add(new Bullet(x, y, this));
  }

  public void addAsteroid(float size, float speed, float x, float y) {
    asteroids.add(new Asteroid(size, speed, x, y, this));
  }

  // Renders entities
  public void render(ArrayList<Entity> entity) {
    for (Entity e : entity) {
      if (e.getActive()) {
        e.render();
      }
    }
  }

  // Updates entities
  public void update(ArrayList<Entity> entity) {
    for (Entity e : entity) {
      e.update();
    }
  }

  // Cleans lists of inactive (dead) entities, returns a list without inactive entities
  public ArrayList<Entity> cleanUp(ArrayList<Entity> entity) {
    ArrayList<Entity> cleanList = new ArrayList<Entity>();
    // Filter out active objects
    for (Entity e : entity) {
      if (e.getActive())
        cleanList.add(e);
    }
    return cleanList;
  }

  public void checkBulletCollision() {
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

  public void checkPlanetCollision() {
    for (Entity a : asteroids) {
      if (abs(a.position.x - star.position.x) < (a.size/2 + star.size/2) && abs(a.position.y - star.position.y) < (a.size/2 + star.size/2)) {
        star.damage(a.getHealth());
        System.out.println(a.getHealth());
        a.destroy();
      }
    }
  }
}
class Main implements Scene {

  PImage header;
  PImage buttonPlay;
  PImage buttonExit;
  PImage buttonSelected;

  int selectedButton = 0;

  Main() {

    // Load assets
    header = loadImage("assets/header.png");
    buttonPlay = loadImage("assets/button_play.png");
    buttonExit = loadImage("assets/button_exit.png");
    buttonSelected = loadImage("assets/button_selected.png");
  }

  // Main scene loop
  public void drawScene() {
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
  }

  // Mouse handlers
  public void onMouseClick() {
    if (mouseInsideButton(buttonPlay, 400))
      currentScene = game;
    if (mouseInsideButton(buttonExit, 550))
      exit();
  }

  public void onMouseDrag() {}
  public void onMouseRelease() {}
  public void onMouseMoved() {
    if (mouseInsideButton(buttonPlay, 400))
      selectedButton = 0;
    if (mouseInsideButton(buttonExit, 550))
      selectedButton = 1;
  }

  public boolean mouseInsideButton(PImage button, int yPos) {
    if ( mouseX < width/2 + button.width/2 && mouseX > width/2 - button.width/2) {
      return ( mouseY < yPos + button.height/2 && mouseY > yPos - button.height/2);
    }

    // Not inside
    return false;

  }
}
interface Scene {
  // Main scene loop
  public void drawScene();
  
  // Mouse handlers
  public void onMouseClick();
  public void onMouseDrag();
  public void onMouseRelease();
  public void onMouseMoved();
}
class Ship extends Entity {

  // Temporary variables for ship shape
  int sWidth  = 50;
  int sLength = 30;

  boolean boosting = false;

  // Movement Variables
  PVector position;
  PVector direction;
  PVector velocity = new PVector(0, 0);

  float fric  = 0.95f;  // Friction in movement (1 being no friction and 0.1 being alot)
  float force = 1;    // Strength of rocket booster

  // Stats
  int level = 1; // Level of ship
  float xpToLevel = 200 * level; // Amount of xp needed to level up
  float xp = 0;
  float damage = 20 + (level * 5); // Bullet damage on hit, scales with level
  float attackSpeed = 1 + (level * 0.5f); // Attacks per second
  float health = 50 + (level * 2); // Max health points

  // Shooting timers
  long lastShot;
  boolean fire = false;

  // Constructor
  Ship (float x, float y, Game game) {
    position = new PVector(x,y);
    this.game = game;
  }

  // Draws ship and attatchments/effects
  public void render() {
    fill(200);
    noStroke();

    // Calculating direction to face towards mouse
    PVector dir = new PVector(mouseX, mouseY).sub(position);
    float angle = atan2(dir.y, dir.x);

    pushMatrix();
      translate(position.x, position.y);
      rotate(angle);

      // Draw boost
      if (boosting && keyPressed)
        image(game.boostImage1, -sLength/2-11, -sWidth/2);
      // Draw ship
      image(game.shipImage1, -sLength/2, -sWidth/2);
    popMatrix();


  }

  // Updates the ships position and applies friction.
  public void update() {
    position.add(velocity);
    velocity.mult(fric);

    if (fire) {
      fire();
    }
  }

  // Moves the ship in specified direction
  public void move(String dir) {
    direction = new PVector(mouseX, mouseY).sub(position);

    switch (dir) {
      case "forward":
        velocity.add(direction.normalize().mult(force));
        boosting = true;
        break;
      case "reverse":
        velocity.sub(direction.normalize().mult(force));
        break;
    }
  }

  // Shoots a bullet
  public void fire() {
    // Check if cool down is complete
    long timeSince = millis() - lastShot;

    if (timeSince > (60 / attackSpeed) * 10) {
      // Spawn bullet in correct position/direction
      PVector dir = new PVector(mouseX, mouseY).sub(position).normalize().mult(2);
      game.addBullet(position.x + dir.x, position.y + dir.y);

      // Reset timer and input
      fire = false;
      lastShot = millis();
    }

    // Reset input if couldn't shoot
    fire = false;
  }

  public void gainXP (float xp_) {
    xp += xp_;
    // If xp is at the required amount to level. levelUP.
    if (xp >= xpToLevel) levelUp();
  }

  public void levelUp() {
    xp = 0;
    level++;

    updateStats();
  }

// Updates the ships stats to correct values according to level
  public void updateStats() {
    xpToLevel = 200 * level;
    damage = 20 + (level * 5);
    attackSpeed = 1 + (level * 0.5f);
    health = 50 + (level * 2);
  }
}
class Star extends Entity {

  int maxHealth = 1000;
  int health = constrain(maxHealth, 0, maxHealth);
  float size = 100;

  PImage star;
  PVector position = new PVector(width/2, height/2);

  Star(Game game) {
    this.star = game.starImage;
    this.game = game;
  }

  public void render() {
    pushMatrix();
      translate(position.x - star.width/2, position.y - star.height/2);
      image(star, 0, 0);

      // Health Bar
      fill(255,255,255);
      rectMode(CORNER);
      rect(0, - 20, star.width, 10);
      fill(0, 255, 0);
      if (health > 0) rect(2, - 18, (float) health/1000 * (star.width-4), 6);
      fill(255, 255, 255);
      textAlign(CENTER);
      text(health < 0 ? 0 : health, star.width/2, -22);
    popMatrix();
  }

  public void update() {
    if (health <= 0) {
      game.alive = false;
    }
  }

  public void damage(int d) {
    health = health - d;
  }

  // Health regen per round?
  public void regen() {
  }
}
class WaveController {
  
  Game game;
  
  // Triggers
  boolean waveEnded = false;
  
  // Timers
  int finishedTime = millis();   // Time the last waved finished
  int breakTime = 10;             // Time (seconds) in between waves
  
  int spawnTime = millis();      // Time the last asteroid spawned
  
  // Wave stats 
  int difficulty     = 1;
  
  int currentWave    = 1;
  int waveMultiplier = 1 + difficulty;
  int asteroidCount  = currentWave * waveMultiplier;
  
  float spawnTimeMultiplier = 3 - (currentWave * (0.1f * difficulty)); // Spawn rate
  float sizeMultiplier = 1 + (currentWave * (0.4f * difficulty));   // Size cap
  float speedMultiplier = 1.0f + (currentWave * (0.4f * difficulty));  // Speed cap
  
  float baseSize = 25;
  float baseSpeed = 1;
  
  // Special Events
  float bigBoyChance = 0.20f; // 20% chance to spawn a bigBoy asteroid (double size)
  
  WaveController(int difficulty, Game game) {
    this.difficulty = difficulty;
    this.game = game;
    
    System.out.println("Wave " + currentWave + " starting!!");
  }
  
  // Handles waves and timing
  public void play() {
      
    // Wave finished
    if (waveEnded && (millis() - finishedTime > breakTime * 1000)) {
      nextWave();
      System.out.println("Wave " + currentWave + " starting!!");
      waveEnded = false;
    }
    
    if (!waveEnded) {
      wave();
    }
    
    textAlign(CENTER);
    fill(255, 255 - currentWave * 25, 255 - currentWave * 25);
    text("Difficulty: " + difficulty + " | Wave: " + currentWave + " | Asteroids left: " + (asteroidCount + game.asteroids.size()), width/2, 40);
    
  }
  
  // Sets up next wave
  public void nextWave() {
    currentWave++;
    
    // Refresh wave stats
    asteroidCount  = currentWave * waveMultiplier;
  
    spawnTimeMultiplier = 3 - (currentWave * (0.1f * difficulty)); // Spawn rate
    sizeMultiplier = 1.0f + (currentWave * (0.4f * difficulty));   // Size cap
    speedMultiplier = 1.0f + (currentWave * (0.4f * difficulty));  // Speed cap
  }
  
  public void wave() {
    
    // Check if wave is cleared
    if (asteroidCount <= 0 && game.asteroids.size() == 0) {
      waveEnded = true;
      finishedTime = millis();
      return;
    }
    
    // Spawn asteroid if ready
    if (millis() - spawnTime > spawnTimeMultiplier * 1000) {
      spawnAsteroid();
      spawnTime = millis();
    }
  }
  
  // Spawn new random asteroid
  public void spawnAsteroid() {
    if (asteroidCount > 0) {
      float xPos, yPos;
      int bigBoySpawn = Math.random() < bigBoyChance ? 2 : 1;
      
      // Calculate side
      int side = (int) Math.floor(Math.random() * 4);
      
      // Randomize
      if (side == 0) {
        xPos = 0;
        yPos = (float) Math.floor(Math.random() * height);
      } else if (side == 1) {
        xPos = width;
        yPos = (float) Math.floor(Math.random() * height);
      } else if (side == 2) {
        xPos = (float) Math.floor(Math.random() * width);
        yPos = 0;
      } else {
        xPos = (float) Math.floor(Math.random() * width);
        yPos = height;
      }
      
      game.addAsteroid((sizeMultiplier * baseSize) * bigBoySpawn, speedMultiplier * baseSpeed, xPos, yPos);
      asteroidCount--;
    }
  }
}
  public void settings() {  size(1360, 765); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Rockstar" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
