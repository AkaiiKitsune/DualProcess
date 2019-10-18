import processing.net.*; //Import network libs
boolean holdingMouse, isServer, reset = false, isOnline=false; //Declaration des booleens
int packetsLost, //Compteur de packets perdus
    holdingTime, //Compeur de temps de mouse hold
    packetsLostLimit=20; //Nombre maximum de packets perdus avant que la connection soit reset
float bgColor=30; //Variable gerant la couleur du background

Server server; //Objet serveur
Client client; //Objet client
String input = " ", //String reçu par le client;
       data[]; //Tableau dans le quel les données reçues sont stoquées

Types joueur1, joueur2; //Objets joueurs
Bullets bullets1, bullets2; //Objets balles


/* Main :
//=======================================================================================================================
 ** void setup(){}
    --> Initialise les variables et les connections
 ** void draw(){}
    --> Boucle principale du programme*/
void setup(){
        size(800, 1000); //Set la taille de la fenetre
        background(0); //Set la couleur du background
        noCursor(); //Empeche l'affichage du curseur
        smooth(6); //Antialiasing
        rectMode(CENTER);

        joueur1 = new Types("Zaba", true, color(150,120,120), width/2, 3*height/4, 50, 20); //Declare le joueur 1 : A BOUGER DANS LE LOBBY
        joueur2 = new Types("Zaba", false, color(200), width/2, height/4, 50, 20); //Declare le joueur 2 : A BOUGER DANS LE LOBBY
        bullets1 = new Bullets(20, joueur1, joueur2); //Same as above
        bullets2 = new Bullets(20, joueur2, joueur1); //Again, same as above

        if(isOnline) {
                background(color(100,50,50));
                connect(reset);
        }
}

void draw(){
        drawBackground(50, 5, bgColor); //Affiche le background
        if(bgColor>5) bgColor*=0.95; //Decremente la valeur de la couleur du background, donne de l'effet

        if(holdingMouse && mouseButton == RIGHT) {holdingTime++; joueur1.hold(holdingTime, false, bullets1);} //Tir droit maintenu


        joueur1.update();
        joueur1.munitionDraw(joueur1);
        joueur2.munitionDraw(joueur2);

        bullets1.updateBullets();
        joueur1.dessiner();
        joueur2.dessiner();

        fill(bgColor*3); strokeWeight(3); rect(mouseX, mouseY, 10, 10); //Curseur de la souris

        //Multiplayer
        if(isOnline) send(int(bgColor) + " " +
                          int(joueur1.position.x) + " " +
                          int(joueur1.position.y) + " " +
                          int(180+joueur1.angle) + " " +
                          int(joueur1.ammoLeft) + "\n");
}
//=======================================================================================================================
