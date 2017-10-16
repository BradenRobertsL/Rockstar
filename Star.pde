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

  void render() {
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

  void update() {
    if (health <= 0) {
      game.alive = false;
    }
  }

  void damage(int d) {
    health = health - d;
  }

  // Health regen per round
  void regen() {
    health += game.player.level * 10;
  }
}
