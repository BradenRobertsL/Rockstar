class Bullet extends Entity {

  // Bullet stats.
  float speed = 25;   // Speed the bullet travels.

  PVector direction;  // Direction the bullet should move.
  float angle;        // Angle in which the bullet should face.

  Bullet(float x, float y, Game game) {
    position = new PVector(x, y);
    direction = new PVector(mouseX, mouseY).sub(position);
    angle = atan2(direction.y, direction.x);
    this.game = game;
  }

  // Draws bullet.
  void render() {
    if (active) {
      pushMatrix();
        translate(position.x, position.y);
        pushMatrix();
          rotate(angle);
          translate(-game.bulletImage.width/2, -game.bulletImage.height/2);
          image(game.bulletImage, 0, 0);
        popMatrix();
      popMatrix();
    }
  }

  // Updates bullets position and checks if the bullet is still alive.
  void update() {
    position.add(direction.normalize().mult(speed));

    if (position.x < 0 || position.x > width || position.y < 0 || position.y > height)
      active = false;
  }
}
