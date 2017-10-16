class Button {

  String text;      // Text on button.
  PVector position; // Button Position (Top Left Corner).

  float bWidth;     // Button width.
  float bHeight;    // Button height.

  int textSize = 30;
  float scalar = 0.8; // Text size multiplier.

  float padding = 20; // Text padding from button border.

  // Colors.
  color main = color(236,240,241);
  color hover = color(52,152,219);
  color textColor = color(52,152,219);
  color textColorH = color(236,240,241);

  boolean onButton = false;

  Button(float x, float y, String text_) {
    position = new PVector(x, y);
    text = text_;

    calculateSize();
  }

  Button(float x, float y, color c, String text_) {
    position = new PVector(x, y);
    text = text_;
    hover = c;
    textColor = c;

    calculateSize();
  }

  // Calculating button size (width/height) based on text.
  void calculateSize() {
    textSize(textSize);
    bWidth = textWidth(text) + 10;
    bHeight = (textAscent() * scalar) + (textDescent() * scalar) + 10;
  }

  // Draw the button.
  void render() {
    mouseHover();

    pushMatrix();
      translate(position.x - bWidth/2, position.y);
      // Box.
      noStroke();
      fill(onButton ? hover : main);
      rectMode(CORNER);
      rect(0, 0, bWidth + (padding * 2), bHeight + (padding * 2), 7);

      // Label.
      fill(onButton ? textColorH : textColor);
      textSize(textSize);
      textAlign(LEFT, TOP);
      text(text, padding + 3, padding + 2);
    popMatrix();
  }

  // Checks if mouse is withing buttons bounds and sets color appropriately.
  void mouseHover() {
    if (mouseX < (position.x - bWidth/2) + (bWidth + (padding*2)) && mouseX > (position.x - bWidth/2)&& mouseY < position.y + (bHeight + (padding*2)) && mouseY > position.y)
      onButton = true;
    else
      onButton = false;
  }

  // Changes text and updates sizes for text to fit inside.
  void updateText(String text_) {
    text = text_;
    calculateSize();
  }
}
