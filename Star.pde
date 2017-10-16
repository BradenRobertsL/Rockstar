class Star extends Entity {

  int maxHealth = 1000;
  int health = constrain(maxHealth, 0, maxHealth);
  float size = 100;

  PImage star;
  PVector position = new PVector(width/2, height/2);

  // Health bar colors from green to red
  color green = color(46,204,113);
  color red = color(231,76,60);

  Star(Game game) {
    this.star = game.starImage;
    this.game = game;
  }

  void render() {
    pushMatrix();
      translate(position.x - star.width/2, position.y - star.height/2);
      image(star, 0, 0);
    popMatrix();

    // Draw healthbar
    pushMatrix();
      fill(255,255,255);
      rectMode(CORNER);
      rect(0, - 20, star.width, 10);
      fill(lerpColor(red, green, (float) health/maxHealth));
      if (health > 0) rect(2, - 18, (float) health/1000 * (star.width-4), 6);
      fill(255, 255, 255);
      textAlign(CENTER);
      text(health < 0 ? 0 : health, star.width/2, -22);
    popMatrix();
  }

  void update() {
    constrain(health, 0, maxHealth);
    if (health <= 0) {
      game.alive = false;
    }
  }

  void damage(int d) {
    health = health - d;
  }

  // Health regen per round
  void regen() {
    if (health < maxHealth) health = constrain(health += game.player.level * 50, 0, maxHealth);
  }
}
