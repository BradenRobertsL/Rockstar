class Entity {
  
  Game game;
  boolean active = true;
  
  PVector position; // Entity position
  int health;       // Entities health points
  int damage;       // Entities damage
  float size;       // Size of entity
  
  // Main methods
  
  /**
  * Renders the entity on screen
  **/
  void render(){};
  
  /**
  * Updates the entities values (position, health etc.)
  **/
  void update(){
    if (health <= 0)
      active = false;
  }
  
  /**
  *  Applies damage to entities health
  **/
  void damage(int d){
    health -= d;
  }
  
  /**
  *  De-activates and removes
  **/
  void destroy(){
    active = false;
  }
  
  /**
  *  Checks if object is within bounds
  **/
  boolean checkOverlap(Entity target) {
    return false;
  }
  
  /**
  * Gets head point in direction
  **/
  PVector getPoint() { return null; }
  
  // Getters / Setters
  boolean getActive() { return active; }
  void setActive(boolean a) { this.active = a; }
  
  int getHealth() { return health; }
  void setHealth(int hp) { this.health = hp; }
  
  int getDamage() { return damage; }
  void setDamage(int d) { damage = d; }
}