class WaveController {

  Game game;

  // Triggers
  boolean waveEnded = false;

  // Timers
  int finishedTime = millis();   // Time the last waved finished
  int breakTime = 10;             // Time (seconds) in between waves

  int spawnTime = millis();      // Time the last asteroid spawned

  // Wave stats
  int difficulty     = 1;

  int currentWave    = 1;
  int waveMultiplier = 1 + difficulty;
  int asteroidCount  = currentWave * waveMultiplier;

  float spawnTimeMultiplier = 3 - (currentWave * (0.1 * difficulty)); // Spawn rate
  float sizeMultiplier = 1 + (currentWave * (0.4 * difficulty));   // Size cap
  float speedMultiplier = 1.0 + (currentWave * (0.4 * difficulty));  // Speed cap

  float baseSize = 25;
  float baseSpeed = 1;

  // Special Events
  float bigBoyChance = 0.20; // 20% chance to spawn a bigBoy asteroid (double size)

  WaveController(int difficulty, Game game) {
    this.difficulty = difficulty;
    this.game = game;

    System.out.println("Wave " + currentWave + " starting!!");
  }

  // Handles waves and timing
  void play() {

    // Wave finished
    if (waveEnded && (millis() - finishedTime > breakTime * 1000)) {
      nextWave();
      System.out.println("Wave " + currentWave + " starting!!");
      waveEnded = false;
    }

    if (!waveEnded) {
      wave();
    }

    textAlign(CENTER);
    fill(255, 255 - currentWave * 25, 255 - currentWave * 25);
    text("Difficulty: " + difficulty + " | Wave: " + currentWave + " | Asteroids left: " + (asteroidCount + game.asteroids.size()), width/2, 40);

  }

  // Sets up next wave
  void nextWave() {
    currentWave++;

    // Star regen health
    game.star.regen();

    // Refresh wave stats
    asteroidCount  = currentWave * waveMultiplier;

    spawnTimeMultiplier = 3 - (currentWave * (0.1 * difficulty)); // Spawn rate
    sizeMultiplier = 1.0 + (currentWave * (0.4 * difficulty));   // Size cap
    speedMultiplier = 1.0 + (currentWave * (0.4 * difficulty));  // Speed cap
  }

  void wave() {

    // Check if wave is cleared
    if (asteroidCount <= 0 && game.asteroids.size() == 0) {
      waveEnded = true;
      finishedTime = millis();
      return;
    }

    // Spawn asteroid if ready
    if (millis() - spawnTime > spawnTimeMultiplier * 1000) {
      spawnAsteroid();
      spawnTime = millis();
    }
  }

  // Spawn new random asteroid
  void spawnAsteroid() {
    if (asteroidCount > 0) {
      float xPos, yPos;
      int bigBoySpawn = Math.random() < bigBoyChance ? 2 : 1;

      // Calculate side
      int side = (int) Math.floor(Math.random() * 4);

      // Randomize
      if (side == 0) {
        xPos = 0;
        yPos = (float) Math.floor(Math.random() * height);
      } else if (side == 1) {
        xPos = width;
        yPos = (float) Math.floor(Math.random() * height);
      } else if (side == 2) {
        xPos = (float) Math.floor(Math.random() * width);
        yPos = 0;
      } else {
        xPos = (float) Math.floor(Math.random() * width);
        yPos = height;
      }

      game.addAsteroid((sizeMultiplier * baseSize) * bigBoySpawn, speedMultiplier * baseSpeed, xPos, yPos);
      asteroidCount--;
    }
  }
}
