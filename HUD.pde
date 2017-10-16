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

  HUD (Game _game) {
    game = _game;
    star = game.star;
    player = game.player;
  }

  // Draws all HUD components
  void drawHUD() {
    pushMatrix();
    translate(0, height-54);
      healthBar();
      xpBar();
      level();
    popMatrix();
  }

  // Draw level
  void level() {
    pushMatrix();
      translate(2,2);

      // Box
      rectMode(CORNER);
      fill(255, 255, 255);
      rect(0, 0, 50, 50);

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
      rect(0, 0, 250, 24);

      // Bar
      if (star.health > star.maxHealth/2) fill(lerpColor(yellow, green, (float) (star.health/star.maxHealth/2)));
      if (star.health > 0) rect(2, 2, (float) star.health/star.maxHealth * (250-4), 24-4);

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
      rect(0, 0, 250, 24);

      // Bar
      fill(blue);
      if (star.health > 0) rect(2, 2, (float) player.xp/player.xpToLevel * (250-4), 24-4);
      fill(255, 255, 255);

      // Label
      textSize(10);
      fill(white);
      text("Experience: " + player.xp + "/" + player.xpToLevel , 250/2 , 24/2+4);
    popMatrix();
  }
}
