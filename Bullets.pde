//http://studio.sketchpad.cc/sp/pad/view/ro.91nVQMnL$v06L/latest

class Bullets {
/*** Attributes ***/
Types player, player2;
//Bullets Attributes
int bulletsIdx, maxBullets;
PVector[] bullets;
PVector[] targets;
PVector[] bulletAngleSizeDamage;
PVector[] vertices;
PVector[] zabaBallPoints = new PVector[4];

PVector bullet;

float angle;
float size;

// ==================================================== //
/*** Methods ***/
Bullets(int maxBullets_, Types player_, Types player2_){       //constructor
        bullets = new PVector[maxBullets_];
        targets = new PVector[maxBullets_];
        bulletAngleSizeDamage = new PVector[maxBullets_];
        player = player_;
        player2 = player2_;
        maxBullets = maxBullets_;

        for (int i = 0; i != maxBullets; i++) { //Initialise les tableaux de vecteurs contenants les balles et leur cibles
                bullets[i] = new PVector(1e5, 1e5);
                targets[i] = new PVector();
                bulletAngleSizeDamage[i] = new PVector(0, 15, 25);
        }
}

// ==================================================== //
/*** Functions ***/
boolean isHitting() {//PVector[] vertices, float px, float py
        boolean hit = polyPoly(vertices, player2.calcVertices());
        if (hit) println("HIT");
        return true;
}

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

void updateBullets() {
        strokeWeight(0);
        fill(255);
        for (int i = 0; i != maxBullets;) {
                bullet = bullets[i];

                angle = bulletAngleSizeDamage[i].x;
                size = bulletAngleSizeDamage[i].y;

                bullet.add(targets[i++]); // updates

                zabaBallPoints[0] = new PVector( size, size);
                zabaBallPoints[1] = new PVector( size,-size);
                zabaBallPoints[2] = new PVector(-size,-size);
                zabaBallPoints[3] = new PVector(-size, size);

                vertices = new PVector[4];
                for(int j = 0; j<vertices.length; j++) vertices[j] = new PVector(rotatePoint(angle, zabaBallPoints[j], bullet).x, rotatePoint(angle, zabaBallPoints[j], bullet).y);
                beginShape();for(int k = 0; k<4; k++)vertex(vertices[k].array());endShape(CLOSE);

                isHitting();
        }
}
}
