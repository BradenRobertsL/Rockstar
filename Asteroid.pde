class Asteroid extends Entity {

  PVector direction;            // Direction asteroids moving
  float angle = 0;              // Angle value for rotating image

  // Asteroid stats.
  int healthMultiplier = 2;    // Size multiplied to calculate health.
  int health;                  // Health points of asteroid.
  float size;                  // Size of asteroid and damage it deals.
  float xp;                    // Amount of xp gained on kill.
  float speed;                 // Movement speed of asteroid.

  Asteroid (float size, float speed, float x, float y, Game game) {
    health = (int) size * healthMultiplier;
    this.size = size;
    this.xp = size;
    this.speed = speed;
    this.game = game;

    position = new PVector(x, y);
    direction = new PVector(width/2, height/2).sub(position);
  }

  // Draw asteroid.
  void render() {
    if (active) {
      pushMatrix();
        translate(position.x, position.y);
        pushMatrix();
          scale((size/2)/100);
          rotate(angle);
          translate(-game.asteroidImage.width/2, -game.asteroidImage.height/2);
          image(game.asteroidImage, 0, 0);
        popMatrix();
      popMatrix();
    }
  }

  // Update asteroids position, check if still alive.
  void update() {
    angle += 0.04;
    position.add(direction.normalize().mult(speed));

    if (health <= 0 && active)
      destroy(true);
  }

  // Applies damage to asteroid.
  void damage(int d){
    health -= d;
    size -= d/4;
  }

  // Destroys asteroid, gives player xp if killed by.
  void destroy(boolean player){
    if (player) game.player.gainXP(xp);
    active = false;
  }

  // Checks to see if the @target overlaps with the asteroid
  boolean checkOverlap (Entity target) {

    if (target.position.dist(position) < (size/2)) {
      return true;
    }
    return false;
  }

  // Returns the asteorids health
  int getHealth() { return health; }
}
