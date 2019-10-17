//http://studio.sketchpad.cc/sp/pad/view/ro.91nVQMnL$v06L/latest
class Bullets {
  /*** Attributes ***/
  Players player;
  //Bullets Attributes
  int bulletsIdx, maxBullets;
  PVector[] bullets;
  PVector[] targets;
  PVector[] bulletAngleSizeDamage;

  // ==================================================== //
  /*** Methods ***/
  Bullets(int maxBullets_, Players player_){     //constructor
    bullets = new PVector[maxBullets_];
    targets = new PVector[maxBullets_];
    bulletAngleSizeDamage = new PVector[maxBullets_];
    player = player_;
    maxBullets = maxBullets_;

    for (int i = 0; i != maxBullets_; i++) { //Initialise les tableaux de vecteurs contenants les balles et leur cibles
      bullets[i] = new PVector(1e5, 1e5);
      targets[i] = new PVector();
      bulletAngleSizeDamage[i] = new PVector(0, 15, 25);
    }

  }

  // ==================================================== //
  /*** Functions ***/
  void spitFire(int speed_, int size_) {
    bulletsIdx=(bulletsIdx + 1) % maxBullets; // Incremente la table stoquant les balles
    bullets[bulletsIdx].set(player.position); // Set la position de la balle a la position du joueur

    bulletAngleSizeDamage[bulletsIdx].set(player.angle,
      bulletAngleSizeDamage[bulletsIdx].y,
      bulletAngleSizeDamage[bulletsIdx].z);

    bulletAngleSizeDamage[bulletsIdx].set(bulletAngleSizeDamage[bulletsIdx].x,
      size_,
      bulletAngleSizeDamage[bulletsIdx].z);

    PVector t = targets[bulletsIdx]; // Vise la souris
    t.set( PVector.sub(new PVector(mouseX, mouseY), player.position) ); // Calcule la direction de la trajectoire de la balle
    t.normalize(); // Normalise le vecteur direction
    t.mult(speed_); // Multiplie le vecteur par la vitesse de la balle
  }

  void showBullets() {
    strokeWeight(0);
    fill(255);
      for (int i = 0; i != maxBullets;) {
        PVector b = bullets[i];
        float angle = bulletAngleSizeDamage[i].x;
        float size = bulletAngleSizeDamage[i].y;
        b.add(targets[i++]);  // updates
        pushMatrix();
        translate(b.x, b.y);
        rotate(radians(angle));
        rect(0, 0, size, size);
        popMatrix();
    }
  }

  void showBulletsP2(){

  }
}
