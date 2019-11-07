class Players {
/*** Attributes ***/
//Player Attributes
PVector position, velocity, acceleration;    //Vecteurs pour le deplacement du joueur.
boolean isLeft, isRight, isUp, isDown;    //Booleens permettant de savoir si l'utilisateur appuie sur le clavier.
float x, y, speed, size;    //Variables utilisées pour l'affichage et les calculs de positions.
float angle=PI/2;
float life=100;

String type;    //Type du joueur.

PVector[] playerPoints = new PVector[6];

//=======================================================================================================================
/*** Methods ***/
Players(String type_, int colorPlayer, float x_, float y_, float size_, float speed_){         //constructor
        acceleration = new PVector(0.0, 0.0);     //Initialise le vecteur acceleration
        position = new PVector(x_, y_);     //Initialise le vecteur position
        velocity = new PVector(0,0);     //Initialise le vecteur vélocité
        speed = speed_;     //Initialise la variable vitesse max
        size = size_;     //Initialise la taille du joueur

        playerPoints[0] = new PVector( size, size); playerPoints[1] = new PVector( size,-size); playerPoints[2] = new PVector(-size,-size);
        playerPoints[3] = new PVector(-size, size); playerPoints[4] = new PVector( size, 0   ); playerPoints[5] = new PVector( size/2, 0 );
}

//=======================================================================================================================
/*** Player Functions ***/
void updatePlayer() {
        acceleration.set((isRight ? 1 : 0)-(isLeft ? 1 : 0),         //Convertis les booleens en int pout permettre-
                         (isDown  ? 1 : 0)-(isUp   ? 1 : 0));        // -De definir le sens du vecteur acceleration
        angle = angleBetweenPV_PV(position, new PVector(mouseX, mouseY));         //Calcule
        if(position.y-size/2<=height/2 || position.y+size/2>=height) velocity.set(velocity.x,0);
        if(position.x-size/2<=0 || position.x+size/2>=width ) velocity.set(0,velocity.y);
        updateMove(true);
}

void updateAi(Players player1){
        angle = angleBetweenPV_PV(position, new PVector(player1.position.x, player1.position.y));
        if(position.y-size/2<=0 || position.y+size/2>=height/2) velocity.set(velocity.x,0);
        if(position.x-size/2<=0 || position.x+size/2>=width ) velocity.set(0,velocity.y);
        updateMove(false);
}

void updateMove(boolean isPlayer){
        acceleration.setMag(2); // Set la magnitude de l'acceleration
        velocity.add(acceleration); // Ajout du vecteur acceleration au vecteur velocité
        velocity.mult(0.95); // Amortissement de la velocité au fil du temps
        velocity.limit(speed); // Limite la vitesse max du joueur
        position.add(velocity); // Update la position du joueur en ajoutant le vecteur velocité au vecteur position
        if(isPlayer) position.set(constrain(position.x, 0+size/2, width-size/2), constrain(position.y, (height/2)+size/2, height-size/2));
        else position.set(constrain(position.x, 0+size/2, width-size/2), constrain(position.y, size/2, (height/2)+size/2));
}

boolean setMove(int k, boolean b) {     //Permet de verifier si plusieurs touches sont appuiées en même temps.
        switch (k) {
        case 'Z': //Fleche du haut ou Z appuyé.
        case UP:
                return isUp = b;

        case 'S':  //Fleche du bas ou S appuyé.
        case DOWN:
                return isDown = b;

        case 'Q': //Fleche de gauche ou Q appuyé.
        case LEFT:
                return isLeft = b;

        case 'D': //Fleche de droite ou D appuyé.
        case RIGHT:
                return isRight = b;

        default:
                return b;   //Valeur par défaut : Si une autre touche est appuyée, retourne b (true si keyPressed, false si keyReleased;
        }
}
}
