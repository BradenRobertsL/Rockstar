class HUD {

  Game game;
  Star star;
  Ship player;

  // Colors
  color green = color(46,204,113);
  color red = color(231,76,60);
  color blue = color(52,152,219);

  HUD (Game _game) {
    game = _game;
    star = game.star;
    player = game.player;
  }

  void drawHUD() {
    healthBar();
    xpBar();
    level();
  }

  // Draw level
  void level() {
    pushMatrix();
      translate(2,2);
      rectMode(CORNER);
      fill(255, 255, 255);
      rect(0, 0, 50, 50);

      fill(blue);
      textSize(32);
      textAlign(CENTER, CENTER);
      text(player.level, 25, 21);
    popMatrix();
  }

  // Draw health bar
  void healthBar() {
    pushMatrix();
      translate(54, 2);
      fill(255,255,255);
      rectMode(CORNER);
      rect(0, 0, 250, 16);

      fill(lerpColor(red, green, (float) star.health/star.maxHealth));

      if (star.health > 0) rect(2, 2, (float) star.health/star.maxHealth * (250-4), 16-4);
      fill(255, 255, 255);
    popMatrix();
  }

  // Draw xp bar
  void xpBar() {
    pushMatrix();
      translate(54, 20);
      fill(255,255,255);
      rectMode(CORNER);
      rect(0, 0, 250, 16);

      fill(blue);

      if (star.health > 0) rect(2, 2, (float) player.xp/player.xpToLevel * (250-4), 16-4);
      fill(255, 255, 255);
    popMatrix();
  }
}
