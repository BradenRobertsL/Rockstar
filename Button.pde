class Button {

  String text; // Text on button
  PVector position; // Button Position (Top Left Corner);

  float bWidth;
  float bHeight;

  int textSize = 30;
  float scalar = 0.8; // Text size multiplier

  float padding = 20; // Text padding from button border

  // Colors
  color main = color(231,76,60);
  color hover = color(46,204,113);
  color textColor = color(236,240,241);

  boolean onButton = false;

  Button(float x, float y, String text_) {
    position = new PVector(x, y);
    text = text_;

    calculateSize();
  }

  Button(PVector pos, String text_, color main_, color hover_, color textColor_) {
    position = pos;
    text = text_;
    main = main_;
    hover = hover_;
    textColor = textColor_;

    calculateSize();
  }

  // Calculating button size based on text
  void calculateSize() {
    textSize(textSize);
    bWidth = textWidth(text) + 10;
    bHeight = (textAscent() * scalar) + (textDescent() * scalar) + 10;
  }

  void render() {
    mouseHover();

    pushMatrix();
      translate(position.x, position.y);
      // Box
      noStroke();
      fill(onButton ? hover : main);
      rectMode(CORNER);
      rect(0, 0, bWidth + (padding * 2), bHeight + (padding * 2), 7);

      fill(textColor);
      textSize(textSize);
      textAlign(LEFT, TOP);
      text(text, padding + 3, padding + 2);
    popMatrix();
  }

  // Checks if mouse is withing buttons bounds and sets color appropriately
  void mouseHover() {
    if (mouseX < position.x + (bWidth + (padding*2)) && mouseX > position.x && mouseY < position.y + (bHeight + (padding*2)) && mouseY > position.y)
      onButton = true;
    else
      onButton = false;
  }

}
