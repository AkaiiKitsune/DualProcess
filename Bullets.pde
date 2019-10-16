//http://studio.sketchpad.cc/sp/pad/view/ro.91nVQMnL$v06L/latest
class Bullets {
  /*** Attributes ***/
  Players player;
  //Bullets Attributes
  int bulletsIdx, maxBullets;
  PVector[] bullets;
  PVector[] targets;

  // ==================================================== //
  /*** Methods ***/
  Bullets(int maxBullets_, Players player_){     //constructor
    bullets = new PVector[maxBullets_];
    targets = new PVector[maxBullets_];
    maxBullets = maxBullets_;
    player = player_;

    for (int i = 0; i != maxBullets_; i++) { //Initialise les tableaux de vecteurs contenants les balles et leur cibles
      bullets[i] = new PVector(1e5, 1e5);
      targets[i] = new PVector();
    }

  }

  // ==================================================== //
  /*** Functions ***/
  void spitFire(int speed_) {
    bullets[bulletsIdx = (bulletsIdx + 1) % maxBullets].set(player.position); // Set la position de la balle a la position du joueur
    final PVector t = targets[bulletsIdx]; // Vise la souris
    t.set( PVector.sub(new PVector(mouseX, mouseY), player.position) ); // Calcule la direction de la trajectoire de la balle
    t.normalize(); // Normalise le vecteur direction
    t.mult(speed_); // Multiplie le vecteur par la vitesse de la balle
  }

  void showBullets() {
    strokeWeight(0);
    fill(255);
      for (int i = 0; i != maxBullets;) {
        PVector b = bullets[i];
        b.add(targets[i++]);  // updates
        pushMatrix();
        translate(b.x, b.y);
        rotate(radians(player.angle));
        rect(0, 0, 15, 15);
        popMatrix();
    }
  }
}
