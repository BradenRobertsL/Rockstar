class Ship extends Entity {

  int sWidth  = 50;
  int sLength = 30;

  boolean boosting = false;

  // Movement Variables
  PVector position;
  PVector direction;
  PVector velocity = new PVector(0, 0);

  float fric  = 0.95;  // Friction in movement (1 being no friction and 0.1 being alot)
  float force = 1; // Strength of rocket booster

  int score = 0; // Players score (Total xp gained)

  // Stats
  int level = 1; // Level of ship
  float xpToLevel = 200 * level; // Amount of xp needed to level up
  float xp = 0;
  float damage = 20 + (level * 5); // Bullet damage on hit, scales with level
  float attackSpeed = 1 + (level * 0.75); // Attacks per second
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
  void render() {
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
        image(game.boostImage1, -sLength/2-11, -sWidth/2 - 2);
      // Draw ship
      image(game.shipImage1, -sLength/2, -sWidth/2);
    popMatrix();


  }

  // Updates the ships position and applies friction.
  void update() {
    position.add(velocity);
    velocity.mult(fric);

    if (fire) {
      fire();
    }
  }

  // Moves the ship in specified direction
  void move(String dir) {
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
  void fire() {
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

  void gainXP (float xp_) {
    xp += xp_;
    score += xp_;
    System.out.println("Gained " + xp_ + " xp");
    // If xp is at the required amount to level. levelUP.
    if (xp >= xpToLevel) levelUp();
  }

  void levelUp() {
    xp = 0;
    level++;
    System.out.println("Levelled up to " + level + "!");
    updateStats();
  }

// Updates the ships stats to correct values according to level
  void updateStats() {
    xpToLevel = 200 * level;
    damage = 20 + (level * 5);
    attackSpeed = 1 + (level * 0.75);
    health = 50 + (level * 2);
    game.star.maxHealth += health;
  }
}
