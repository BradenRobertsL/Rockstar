class Star extends Entity {

  // Stats.
  int maxHealth = 0;
  int health = constrain(maxHealth, 0, maxHealth);
  float size = 100;

  PImage star;
  PVector position = new PVector(width/2, height/2);

  Star(Game game) {
    this.star = game.starImage;
    this.game = game;

    maxHealth = game.wave.difficulty * 200;
    health = constrain(maxHealth, 0, maxHealth);
  }

  // Draws the star.
  void render() {
    pushMatrix();
      translate(position.x - star.width/2, position.y - star.height/2);
      image(star, 0, 0);
    popMatrix();
  }

  // Updates health values and checks if star is dead.
  void update() {
    constrain(health, 0, maxHealth);
    if (health <= 0) {
      game.alive = false;
    }
  }

  // Applies damage to star.
  void damage(int d) {
    health = health - d;
  }

  // Health regenerated per wave end.
  void regen() {
    if (health < maxHealth) health = constrain(health += game.player.level * 50, 0, maxHealth);
  }
}
