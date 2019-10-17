//http://studio.sketchpad.cc/sp/pad/view/ro.91nVQMnL$v06L/latest

class Bullets {
/*** Attributes ***/
Players player;
//Bullets Attributes
int bulletsIdx, maxBullets;
PVector[] bullets;
PVector[] targets;
PVector[] bulletAngleSizeDamage;

PVector[] points = new PVector[4];

// ==================================================== //
/*** Methods ***/
Bullets(int maxBullets_, Players player_){       //constructor
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

        points[0] = new PVector(player.size, player.size);
        points[1] = new PVector(-player.size, player.size);
        points[2] = new PVector(player.size, -player.size);
        points[3] = new PVector(-player.size, -player.size);
}

// ==================================================== //
/*** Functions ***/
PVector rotatePoint(float angle_, PVector pos_){
        PVector positionPoint = new PVector();
        // player.position.x, player.position.y - center of square coordinates
        // x, y - coordinates of a corner point of the square
        // theta is the angle of rotation

        // translate point to origin
        float xc = player.position.x + pos_.x/2;
        float yc = player.position.y + pos_.y/2;
        float tempX = xc - player.position.x;
        float tempY = yc - player.position.y;
        angle_=radians(angle_);

        // now apply rotation
        float rotatedX = tempX*cos(angle_) - tempY*sin(angle_);
        float rotatedY = tempX*sin(angle_) + tempY*cos(angle_);

        // translate back
        xc = rotatedX + player.position.x;
        yc = rotatedY + player.position.y;

        positionPoint.set(xc, yc);
        return positionPoint;
}

boolean polygonPoint() {//PVector[] vertices, float px, float py
        boolean collision = false;
        PVector[] vertices = new PVector[4];

        for(int i = 0; i<points.length; i++) {
                vertices[i] = new PVector(rotatePoint(player.angle, points[i]).x, rotatePoint(player.angle, points[i]).y);
        }

        strokeWeight(0);
        fill(color(255,150,150));
        // for(int i = 0; i<points.length; i++) {
        //         rect(vertices[i].x, vertices[i].y, 5, 5);
        // }

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

void showBullets() {
        strokeWeight(0);
        fill(255);
        for (int i = 0; i != maxBullets;) {
                PVector b = bullets[i];
                float angle = bulletAngleSizeDamage[i].x;
                float size = bulletAngleSizeDamage[i].y;
                b.add(targets[i++]); // updates
                pushMatrix();
                translate(b.x, b.y);
                rotate(radians(angle));
                rect(0, 0, size, size);
                popMatrix();
        }
}

void showBulletsP2(){

}

// POLYGON/LINE
boolean polyLine(PVector[] vertices, float x1, float y1, float x2, float y2) {

        // go through each of the vertices, plus the next
        // vertex in the list
        int next = 0;
        for (int current=0; current<vertices.length; current++) {

                // get next vertex in list
                // if we've hit the end, wrap around to 0
                next = current+1;
                if (next == vertices.length) next = 0;

                // get the PVectors at our current position
                // extract X/Y coordinates from each
                float x3 = vertices[current].x;
                float y3 = vertices[current].y;
                float x4 = vertices[next].x;
                float y4 = vertices[next].y;

                // do a Line/Line comparison
                // if true, return 'true' immediately and
                // stop testing (faster)
                boolean hit = lineLine(x1, y1, x2, y2, x3, y3, x4, y4);
                if (hit) {
                        return true;
                }
        }

        // never got a hit
        return false;
}

// LINE/LINE
boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

        // calculate the direction of the lines
        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

        // if uA and uB are between 0-1, lines are colliding
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
                return true;
        }
        return false;
}

// POLYGON/POINT
// used only to check if the second polygon is INSIDE the first
boolean polyPoint(PVector[] vertices, float px, float py) {
        boolean collision = false;

        // go through each of the vertices, plus the next
        // vertex in the list
        int next = 0;
        for (int current=0; current<vertices.length; current++) {

                // get next vertex in list
                // if we've hit the end, wrap around to 0
                next = current+1;
                if (next == vertices.length) next = 0;

                // get the PVectors at our current position
                // this makes our if statement a little cleaner
                PVector vc = vertices[current]; // c for "current"
                PVector vn = vertices[next]; // n for "next"

                // compare position, flip 'collision' variable
                // back and forth
                if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) &&
                    (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
                        collision = !collision;
                }
        }
        return collision;
}
}
