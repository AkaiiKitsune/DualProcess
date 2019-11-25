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
PVector[] osloBallPoints = new PVector[8];

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
                bullets[i] = new PVector(1e5, 1e5, 0);
                targets[i] = new PVector();
                bulletAngleSizeDamage[i] = new PVector(10, 15, 20);
        }
}

// ==================================================== //
/*** Functions ***/
boolean isHitting(String type) {//PVector[] vertices, float px, float py
        boolean hit = polyPoly(vertices, calcVertices(6, player2.playerPoints, player2.angle, player2.position));
        if (hit) {
                bullet.set(5e5, 5e5); //Fait partir les balles tres loin de l'aire de jeu
                return true;
        }
        return false;
}
void spitFire(float speed_, int charge_, PVector target) {
        bulletsIdx=(bulletsIdx + 1) % maxBullets; // Incremente la table stoquant les balles
        bullets[bulletsIdx].set(player.position.x, player.position.y, player.angle); // Set la position de la balle a la position du joueur

        bulletAngleSizeDamage[bulletsIdx].set((15+((charge_-1)*5)), (charge_)*16.67);

        if(debug) println("Projectile has damage : " + bulletAngleSizeDamage[bulletsIdx].y);

        PVector t = targets[bulletsIdx]; // Vise la souris
        t.set( PVector.sub(target, player.position) ); // Calcule la direction de la trajectoire de la balle
        t.normalize(); // Normalise le vecteur direction
        t.mult(speed_); // Multiplie le vecteur par la vitesse de la balle
}
void updateBullets(String type) { //Mise a jour des positions des balles
        strokeWeight(0);
        fill(255);
        boolean hit=false;
        float tempDamage;

        for (int i = 0; i != maxBullets;) {
                bullet = bullets[i];
                size = bulletAngleSizeDamage[i].x;
                tempDamage = bulletAngleSizeDamage[i].y;
                angle = bullet.z;

                bullet.add(targets[i++]); // updates

                switch(type) {
                case "Zaba": //A termes il y aura d'autres types de joueurs, faites pas attention au cases qui se baladent un peu partout dans le code :)
                        zabaBallPoints[0] = new PVector( size, size);
                        zabaBallPoints[1] = new PVector( size,-size);
                        zabaBallPoints[2] = new PVector(-size,-size);
                        zabaBallPoints[3] = new PVector(-size, size); //alors c'est pas beau, mais j'ai pas trouvé mieux

                        vertices = new PVector[4];
                        for(int j = 0; j<vertices.length; j++)
                                vertices[j] = new PVector(rotatePoint(angle, zabaBallPoints[j], bullet).x,
                                                          rotatePoint(angle, zabaBallPoints[j], bullet).y);

                        beginShape();
                        for(int k = 0; k<4; k++) {
                                vertex(vertices[k].array());
                        }
                        endShape(CLOSE);
                        break;
                }

                if(isHitting(type)) {
                        player2.life -= tempDamage;
                        if(debug) println("Damage done : " + tempDamage);
                        if(debug) println("Player2's life : " + player2.life);
                }
        }
}
}
