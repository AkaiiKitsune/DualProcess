class Players {
/*** Attributes ***/
//Player Attributes
PVector position, velocity, acceleration;    //Vecteurs pour le deplacement du joueur.
boolean isLeft, isRight, isUp, isDown;    //Booleens permettant de savoir si l'utilisateur appuie sur le clavier.
float x, y, speed, size, txai, tyai;    //Variables utilisées pour l'affichage et les calculs de positions.
float angle=PI/2;
float life=100;
float[] timers = new float[6];
int[] triggers = new int[6];
int mode = 1; // Attack modes, 0 : idle
float timeForTravel;
// 1 : fast attack
// 2 : slow attack and avoid
// 3 : avoid and attack back
PVector correction = new PVector(19, 19);
PVector target;

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

        for(int i = 0; i < timers.length; i++) timers[i]=0; //Initialise tous les timers a 0
        for(int i = 0; i < timers.length; i++) triggers[i]=1; //Initialise tous les triggers a 6

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

void updateAi(Players player1_){
        timeForTravel = dist(player1_.position.x, player1_.position.y, position.x, position.y)/player1_.speed;
        target = PVector.add(player1_.position, PVector.mult(player1_.velocity, timeForTravel));
        target = new PVector(constrain((target.x), size/2, width-size/2), constrain(target.y, (height/2)+(size/2), height-(size/2)));
        if(player1_.acceleration.x == 0 && player1_.acceleration.y == 0)  target = new PVector(joueur1.position.x+joueur1.velocity.x*19, joueur1.position.y+joueur1.velocity.y*19);
        //target = new PVector(0,0);

        if(player1_.acceleration.x==0 && player1_.acceleration.y==0){
          timers[5]++;
          if(timers[5]>10 && mode!=1 && joueur2.ammoLeft > 2){
            mode = 1;
            timers[5]=0;
          }
        }else timers[5]=0;


        switch(mode) {
        case 0: //Idle
                txai = width/2 + sin(timers[0]/triggers[4])*200;
                tyai = height/4+ cos(timers[0]/triggers[5])*200;
                modeSelect();
                timers[0]++;
                acceleration = PVector.sub(new PVector(txai, tyai), position);

                break;

        case 1: //Fast shootsq
                txai = player1_.position.x*0.5+((joueur2.target.x*0.5));
                tyai = (player1_.position.y*0.5);
                acceleration = PVector.sub( new PVector(txai, tyai), position);
                acceleration.normalize();
                if(triggers[1]!=0) { //Initialisation des parametres de tir
                        triggers[1]=0; //Run once
                        triggers[2]=int(random(1, joueur2.ammoLeft+1)); //Nombres de balles a tirer
                        timers[1]=0; //Nombres de balles tirées;
                        timers[2]=0; //temps d'attente entre chaque tir
                        timers[3]=0; //frames passées entre chaque tir
                          if(debug) println("[AI] Tir rapide : " + joueur2.ammoLeft +  " balles restantes, " + triggers[2] + " balles a tirer...");
                }else if (triggers[2] > timers[1]) { //S'il reste des balles a tirer, faire la suite :
                        timers[3]++; //Incrementer le timer de tir a chaque frame
                        if(timers[2]<timers[3]) { //Lorsque le timer de tir atteint le   delai entre chaque tir, tirer :
                                timers[1]++; //Incrementer le nombre de balles tirées
                                timers[2]=int(random(3, 10)); //Regenerer un nouveau delai pour le prochain tir
                                timers[3]=0; //Reseter le timer de tir
                                joueur2.hold(1); //Tirer avec charge = 1
                                joueur2.shoot(bullets2, joueur2.target); //Tir
                                  if(debug) println("[AI] Balle " + timers[1] + " tirees, sur " + (triggers[2]) + " balles.");
                        }
                }else{ //Plus de balles a tirer...
                          if(debug) println("[AI] Tirs rapides termines, changement de mode...");
                        triggers[1]=1; //Reset de la fonction de tir
                        triggers[0]=0; //Reset de de la fonction modeSelect
                        modeSelect(); //Changement de mode
                }
                break;

        case 2: //Heavy shoot & avoid
                txai = width - (player1_.position.x*0.5+((joueur2.target.x*0.5))) + sin(timers[0]/triggers[4])*100;
                tyai = (player1_.position.y*0.3) + sin(timers[0]/triggers[4])*100;
                modeSelect();
                acceleration = PVector.sub(new PVector(txai, tyai), position);
                break;

        case 3:
                modeSelect();
                break;
        }



        if(debug) {
                fill(color(255,100,100));
                line(joueur1.position.x, joueur1.position.y, joueur1.position.x+joueur1.velocity.x*19, joueur1.position.y+joueur1.velocity.y*19);
                ellipse(txai, tyai,10,10);
                ellipse(joueur2.target.x, joueur2.target.y,10,10);
                line(position.x, position.y, target.x, target.y);
        }

        angle = angleBetweenPV_PV(position, new PVector(target.x, target.y));
        if(position.y-size/2<=0 || position.y+size/2>=height/2) velocity.set(velocity.x,0);
        if(position.x-size/2<=0 || position.x+size/2>=width ) velocity.set(0,velocity.y);
        updateMove(false);
}

int modeSelect(){
        timers[0]++;
        if(timers[0] >= triggers[0]) {
                timers[0]=0;
                triggers[0]=int(random(1, 150));
                int prevMode=mode;
                while(prevMode==mode) {
                        mode=int(random(0, 3));
                }
                triggers[4]=int(random(10, 40));
                triggers[5]=int(random(10, 40));
                  if(debug) println("[AI MODE] Changement de mode :" + mode + ", will change in :" + triggers[0]);
        }
        return mode;
}

void updateMove(boolean isPlayer){
        acceleration.setMag(.80); // Set la magnitude de l'acceleration
        velocity.add(acceleration); // Ajout du vecteur acceleration au vecteur velocité
        velocity.mult(0.95); // Amortissement de la velocité au fil du temps
        velocity.limit(speed); // Limite la vitesse max du joueur
        position.add(velocity); // Update la position du joueur en ajoutant le vecteur velocité au vecteur position
        if(isPlayer) position.set(constrain(position.x, 0+size/2, width-size/2), constrain(position.y, (height/2)+size/2, height-size/2));
        else position.set(constrain(position.x, 0+size/2, width-size/2), constrain(position.y, size/2, (height/2)-size/2));
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
