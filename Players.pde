// ==================================================== //
class Players {
  /*** Attributes ***/
  boolean isLeft, isRight, isUp, isDown;
  float x, y, speed;
  PVector position, velocity;
  PVector acceleration;
  String type;

  // ==================================================== //
  /*** Methods ***/
  Players(String type_, float x_, float y_, float speed_){     //constructor
          acceleration = new PVector(0.0, 0.0);
          position = new PVector(x_, y_);
          velocity = new PVector(0,0);
          speed = speed_;
          type = type_;
  }

  // ==================================================== //
  /*** Functions ***/
  void update() {
     y = (isDown ? 1 : 0) - (isUp ? 1 : 0);
     x = (isRight ? 1 : 0) - (isLeft ? 1 : 0);

     acceleration.set(x,y);
     acceleration.setMag(0.5);      // Set magnitude of acceleration

     velocity.add(acceleration);    // Velocity changes according to acceleration
     velocity.limit(speed);         // Limit the velocity by topspeed
     position.add(velocity);        // Location changes by velocity
   }

  void dessiner(){     //Draws the player
    switch(type){
      case "Square":
        rectMode(CENTER);
        rect(position.x, position.y, 80, 80);
      break;

      default:
        println("AAAAAAAAAAAAAAAA");
      break;
    }
  }

  boolean setMove(int k, boolean b) { //Permet de verifier si plusieurs touches sont appuiées en même temps.
    switch (k) {
      case 'Z':
      case UP: //Fleche du haut ou Z appuyé.
        return isUp = b;

      case 'S':
      case DOWN: //Fleche du bas ou S appuyé.
        return isDown = b;

      case 'Q':
      case LEFT: //Fleche de gauche ou Q appuyé.
        return isLeft = b;

      case 'D':
      case RIGHT: //Fleche de droite ou D appuyé.
        return isRight = b;

      default:
        return b; //Valeur par défaut : Si une autre touche est appuyée, retourne b (true si keyPressed, false si keyReleased;
    }
  }
}
