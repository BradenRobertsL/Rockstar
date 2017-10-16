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

  void render() {
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

  void update() {
    angle += 0.01;
    position.add(direction.normalize().mult(speed));

    if (health <= 0 && active)
      destroy(true);
  }

  void damage(int d){
    health -= d;
  }

  void destroy(boolean player){
    if (player) game.player.gainXP(xp);
    active = false;
  }

  boolean checkOverlap (Entity target) {
    if ((target.position.x - position.x) + (target.position.y - position.y) < (size/2)) {
      return true;
    }
    return false;
  }

  int getHealth() { return health; }
}
