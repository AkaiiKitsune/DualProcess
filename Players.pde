// ==================================================== //
class Players {
  /*** Attributes ***/
 //Player Attributes
 PVector position, velocity, acceleration; //Vecteurs pour le deplacement du joueur.
 boolean isLeft, isRight, isUp, isDown, isPlayer; //Booleens permettant de savoir si l'utilisateur appuie sur le clavier.
 float x, y, speed, size, offset; //Variables utilisées pour l'affichage et les calculs de positions.
 float angle=90;
 String type; //Type du joueur.

  // ==================================================== //
  /*** Methods ***/
  Players(String type_, boolean isPlayer_, int colorPlayer, float x_, float y_, float size_, float speed_){     //constructor
          acceleration = new PVector(0.0, 0.0); //Initialise le vecteur acceleration
          position = new PVector(x_, y_); //Initialise le vecteur position
          velocity = new PVector(0,0); //Initialise le vecteur vélocité
          isPlayer = isPlayer_;
          speed = speed_; //Initialise la variable vitesse max
          size = size_; //Initialise la taille du joueur
  }

  // ==================================================== //
  /*** Player Functions ***/
  void update() {
     y = (isDown ? 1 : 0) - (isUp ? 1 : 0);
     x = (isRight ? 1 : 0) - (isLeft ? 1 : 0);

     acceleration.set(x,y);
     updatePosition();

     // float a = PI - atan2(position.y - mouseY, position.x - mouseX);
     // float dx = mouseX + (1 + cos(a));
     // float dy = mouseY + (1 - sin(a));

     angle = angleBetweenPV_PV(position, new PVector(mouseX, mouseY));
     angle = degrees(angle);

     //line(position.x, position.y, dx, dy);

     if(position.y-size/2<=1 || position.y+size/2>=height) velocity.set(velocity.x,0);
     if(position.x-size/2<=0 || position.x+size/2>=width ) velocity.set(0,velocity.y);

     position.set(constrain(position.x, 0+size/2, width-size/2), position.y);
     if(!isPlayer)position.set(position.x, constrain(position.y, 0+size/2, (height/2)-size/2));
     else position.set(position.x, constrain(position.y, (height/2)+size/2, height-size/2));
   }

  float angleBetweenPV_PV(PVector a, PVector mousePV) {
    PVector d = new PVector();
    // calc angle
    pushMatrix();
    translate(a.x, a.y);
    // delta
    d.x = mousePV.x - a.x;
    d.y = mousePV.y - a.y;
    // angle
    float angle1 = atan2(d.y, d.x);
    popMatrix();
    return angle1;
  }

  void updatePosition(){
    acceleration.setMag(2);      // Set magnitude of acceleration
    velocity.add(acceleration);    // Velocity changes according to acceleration
    velocity.set(velocity.x*(0.95),velocity.y*(0.95));
    velocity.limit(speed);         // Limit the velocity by topspeed
    position.add(velocity);        // Location changes by velocity
  }

  void setPos(int x_, int y_, int a_){
   position.set(x_, y_);
   angle = a_;
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
