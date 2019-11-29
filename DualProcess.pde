import processing.net.*; //Import network libs
boolean holdingMouse; //Declaration des booleens
int game;
int holdingTime; //Compeur de temps de mouse hold
float bgColor=5; //Variable gerant la couleur du background
boolean debug=false;

PImage s_duel, s_duel_fill, s_duel_header;
PFont font;
int animTemp=0;

Types joueur1, joueur2; //Objets joueurs
Bullets bullets1, bullets2; //Objets balles

boolean ready=false;


/* Main :
   //=======================================================================================================================
 ** void setup(){}
    --> Initialise les variables et les connections
 ** void draw(){}
    --> Boucle principale du programme*/
void setup(){
        size(700, 900); //Set la taille de la fenetre
        background(0); //Set la couleur du background
        noCursor(); //Empeche l'affichage du curseur
        smooth(4); //Antialiasing
        textAlign(CENTER); //Mode d'alignement du texte
        rectMode(CENTER); //Le mode d'affichage de rectangle : Centré
        frame.setTitle("Dual! Un projet Open Source");

        if(!debug) frameRate(60); //Full speed
        else frameRate(30); //Debug

        s_duel = loadImage("images/s_duel.png"); //chargement des assets du menu
        s_duel_fill = loadImage("images/s_duel_fill.png"); //chargement des assets du menu
        s_duel.resize(600, 156); //Resize les images
        s_duel_fill.resize(600, 156); //Resize les images

        s_duel_header = loadImage("images/s_duel_header.png"); //chargement des assets du menu
        font = createFont("images/font.ttf", 32, true); //Charge la font du menu
        textFont(font); //Set la font du menu

        game=0; //Set le gamestate a false : Permet de rester sur le lobby au demarrage du programme
}
void draw(){ //Game loop
        if(game == 0) lobby(); //Lobby
        else if(game == 1) game(); //Jeu
        else endGame(); //Ecran de fin : pas codé pour le moment
        cursor(); //Affiche le curseur de la souris
}
//=======================================================================================================================
