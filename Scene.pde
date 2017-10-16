interface Scene {
  // Main scene loop.
  void drawScene();

  // Mouse handlers.
  void onMouseClick();
  void onMouseDrag();
  void onMouseRelease();
  void onMouseMoved();
}
