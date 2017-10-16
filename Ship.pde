class Ship extends Entity {

  // Ship size.
  int sWidth  = 50;
  int sLength = 30;

  boolean boosting = false;

  // Movement Variables.
  PVector position;
  PVector direction;
  PVector velocity = new PVector(0, 0);

  float fric  = 0.95;  // Friction in movement (1 being no friction and 0.1 being alot).
  float force = 1;     // Strength of rocket booster.

  int score = 0;        // Players score (Total xp gained).

  // Stats.
  int level = 1;                          // Level of ship.
  float xpToLevel = 200 * level;          // Amount of xp needed to level up.
  float xp = 0;
  float damage = 20 + (level * 5);        // Bullet damage on hit, scales with level.
  float attackSpeed = 1 + (level * 0.75); // Attacks per second.
  float health = 50 + (level * 2);        // Max health points.
  float upgradeLevel = 0;                 // Level of upgrades the ship has.

  // Shooting timers.
  long lastShot;
  boolean fire = false;

  PImage ship;
  PImage boost;

  Ship (float x, float y, Game game) {
    position = new PVector(x,y);
    direction = new PVector(mouseX, mouseY).sub(position);
    this.game = game;

    ship = game.shipImage1;
    boost = game.boostImage1;
  }

  // Draws ship and attatchments/effects.
  void render() {
    fill(200);
    noStroke();

    // Calculating direction to face towards mouse.
    PVector direction = new PVector(mouseX, mouseY).sub(position);
    float angle = atan2(direction.y, direction.x);

    pushMatrix();
      translate(position.x, position.y);
      rotate(angle);
      // Draw boost.
      if (boosting && keyPressed)
        image(boost, -sLength/2-11, -sWidth/2 - 1);
      // Draw ship.
      image(ship, -sLength/2, -sWidth/2);
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

  // Moves the ship in specified direction.
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

  // Shoots a bullet.
  void fire() {
    // Check if cool down is complete.
    long timeSince = millis() - lastShot;

    if (timeSince > (60 / attackSpeed) * 10) {

      if (upgradeLevel == 0) {
        // Spawn bullet in correct position/direction.
        PVector dir = new PVector(mouseX, mouseY).sub(position).normalize().mult(2);
        game.addBullet(position.x + dir.x, position.y + dir.y);
      }

      // Upgraded ship gun.
      if (upgradeLevel > 0) {
        // Double barrel!
        PVector left = new PVector(mouseX, mouseY).sub(position).rotate(90).normalize().mult(10);
        PVector right = new PVector(mouseX, mouseY).sub(position).rotate(-90).normalize().mult(10);

        PVector leftGun = new PVector(position.x, position.y).add(left);
        PVector rightGun = new PVector(position.x, position.y).add(right);

        game.addBullet(leftGun.x, leftGun.y);
        game.addBullet(rightGun.x, rightGun.y);
      }

      // Reset timer and input.
      fire = false;
      lastShot = millis();
    }

    // Reset input if couldn't shoot.
    fire = false;
  }

  // Increases ship xp level and updates stats.
  void gainXP (float xp_) {
    xp += xp_;
    score += xp_;
    System.out.println("Gained " + xp_ + " xp");
    // If xp is at the required amount to level. levelUP.
    if (xp >= xpToLevel) {
      int leftOverXP = xp - xpToLevel;
      levelUp();
      xp = leftOverXP;
    }
  }

  // Levels up ship and updates stats.
  void levelUp() {
    xp = 0;
    level++;
    System.out.println("Levelled up to " + level + "!");
    updateStats();

    if (level >= 12/game.wave.difficulty && upgradeLevel == 0) {
      ship = game.shipImage2;
      boost = game.boostImage2;
      upgradeLevel++;
    }
  }

  // Updates the ships stats to correct values according to level.
  void updateStats() {
    xpToLevel = 200 * level;
    damage = 20 + (level * 5);
    attackSpeed = 1 + (level * 0.75);
    health = 50 + (level * 2);
    game.star.maxHealth += health;
  }
}
