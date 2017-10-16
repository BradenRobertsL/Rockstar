class HUD {

  Game game;
  Star star;
  Ship player;

  // Colors
  color green = color(46,204,113);
  color red = color(231,76,60);
  color yellow = color(241,196,15);
  color blue = color(52,152,219);
  color white = color(236,240,241);
  color silver = color(189,195,199);

  float angle = 0;

  int rounding = 5; // Box rounding value

  HUD (Game _game) {
    game = _game;
    star = game.star;
    player = game.player;
  }

  // Draws all HUD components
  void drawHUD() {
    pushMatrix();
    //translate(0, height-54);
      healthBar();
      xpBar();
      level();
      stats();
    popMatrix();
  }

  // Draw level
  void level() {
    pushMatrix();
      translate(2,2);

      // Box
      rectMode(CORNER);
      fill(255, 255, 255);
      rect(0, 0, 50, 50, rounding);

      // Level
      fill(blue);
      textSize(32);
      textAlign(CENTER, CENTER);
      text(player.level, 25, 17);

      // Label
      textSize(10);
      textAlign(CENTER, BOTTOM);
      text("Level", 26, 50);
    popMatrix();
  }

  // Draw health bar
  void healthBar() {
    pushMatrix();
      translate(54, 2);

      // Box
      fill(255,255,255);
      rectMode(CORNER);
      rect(0, 0, 250, 24, rounding);

      fill(silver);
      rect(2, 2, 250-4, 24-4, rounding);

      // Bar
      // Calculate percentage of health and set color accordingly
      if (star.health > star.maxHealth/2)
        fill(lerpColor(yellow, green, (float) (star.health-(star.maxHealth/2))/(star.maxHealth/2)));
      else
        fill(lerpColor(red, yellow, (float) (star.health)/(star.maxHealth/2)));

      if (star.health > 0) rect(2, 2, (float) star.health/star.maxHealth * (250-4), 24-4, rounding);

      // Label
      textSize(10);
      fill(white);
      text("Star health: " + star.health + "/" + star.maxHealth , 250/2 , 24/2+4);
    popMatrix();
  }

  // Draw xp bar
  void xpBar() {
    pushMatrix();
      translate(54, 28);

      // Box
      fill(255,255,255);
      rectMode(CORNER);
      rect(0, 0, 250, 24, rounding);

      fill(silver);
      rect(2, 2, 250-4, 24-4, rounding);

      // Bar
      fill(blue);
      if (star.health > 0) rect(2, 2, (float) player.xp/player.xpToLevel * (250-4), 24-4, rounding);
      fill(255, 255, 255);

      // Label
      textSize(10);
      fill(white);
      text("Experience: " + Math.round(player.xp) + "/" + player.xpToLevel , 250/2 , 24/2+4);
    popMatrix();
  }

  // Draw stats box
  void stats() {
    // Asteroids Left Counter
    pushMatrix();
      translate(width - (168), 2);

      // Box
      fill(255, 255, 255);
      rectMode(CORNER);
      rect(0, 0, 80, 24, rounding);

      // Label
      String aLeft = String.format("%02d", (game.asteroids.size() + game.wave.asteroidCount));

      fill(blue);
      textAlign(LEFT, CENTER);
      textSize(20);
      text("x", 30, 6.5);
      text(aLeft, 47, 8);

      // Icon
      translate(12,12);
      pushMatrix();
        rotate(angle);
        translate(-10,-10);
        scale(0.9);
        image(game.asteroidIcon, 0, 0);
        angle += 0.01;
      popMatrix();
    popMatrix();

    // Wave Counter
    pushMatrix();
      translate(width/2 , 2);

      // Box
      fill(255, 255, 255);
      rectMode(CORNER);
      rect(-50, 0, 100, 24, rounding);

      // Label
      fill(blue);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("WAVE " + game.wave.currentWave, -1, 8.5);
    popMatrix();

    // Score Counter
    pushMatrix();
      translate(width-86, 2);

      // Box
      fill(255, 255, 255);
      rectMode(CORNER);
      rect(0, 0, 84, 24, rounding);

      // Label
      String score = String.format("%07d", game.player.score * game.wave.difficulty);

      fill(yellow);
      textAlign(LEFT, CENTER);
      textSize(20);
      text(score, 2, 8);
    popMatrix();
  }
}
