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

  void render() {
    if (active) {
      pushMatrix();
        translate(position.x,position.y);
        rotate(angle);
        image(game.bulletImage, -game.bulletImage.width/2, -game.bulletImage.height/2);
      popMatrix();
    }
  }

  void update() {
    // Update position
    position.add(direction.normalize().mult(speed));

    // Check if inside view else de-activate
    if (position.x < 0 || position.x > width || position.y < 0 || position.y > height)
      active = false;
  }

  /**
  *  Returns the point at the head of the bullet.
  **/
  PVector getPoint() {
    return direction.mult(1);
  }

  int getDamage() {
    return damage;
  }
}
