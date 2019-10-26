import processing.net.*; //Import network libs
boolean holdingMouse, game; //Declaration des booleens
int holdingTime; //Compeur de temps de mouse hold
float bgColor=5; //Variable gerant la couleur du background

PImage s_duel, s_duel_fill, s_duel_header;
PFont font;
int animTemp=0;

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
        textAlign(CENTER);

        s_duel = loadImage("images/s_duel.png");
        s_duel.resize(600, 156);
        s_duel_fill = loadImage("images/s_duel_fill.png");
        s_duel_fill.resize(600, 156);


        s_duel_header = loadImage("images/s_duel_header.png");
        font = createFont("images/font.ttf", 32, true);
        textFont(font);

        game=false;

        lobby();
        rectMode(CENTER);
}
void draw(){
        if(!game) lobby();
        else if(game) game();
        else endGame();
        cursor();
}
void game(){
        if(bgColor>5) bgColor*=0.95;   //Decremente la valeur de la couleur du background, donne de l'effet

        if(holdingMouse) {holdingTime++; joueur1.hold(holdingTime);}   //Tir droit maintenu


        drawBackground(50, 5, bgColor);   //Affiche le background

        bullets1.updateBullets(joueur1.type);
        bullets2.updateBullets(joueur2.type);

        joueur1.update();

        joueur1.reload();
        joueur1.munitionDraw(joueur1);
        joueur2.reload();
        joueur2.munitionDraw(joueur2);

        joueur1.dessiner();
        joueur2.dessiner();

        if(joueur1.life < 0 || joueur2.life < 0) {
                game=false;
                if(joueur1.life<0) {
                        println("Player 2 won");
                }else if(joueur2.life<0) {
                        println("Player 1 won");
                }
        }
}
void endGame(){
        int temp=0;
}
void lobby(){
        background(color(239, 44, 107));

        if(keyPressed && key == ' ') {
                animTemp+=8;
        }else if(animTemp>0) animTemp *=.9;

        tint(255);
        image(s_duel_fill.get(0, 0, s_duel_fill.width, animTemp), width/2-s_duel_fill.width/2, height/2-s_duel_fill.height/2);
        image(s_duel, width/2-s_duel.width/2, height/2-s_duel.height/2, s_duel.width, s_duel.height);

        //   image(img, dx, dy, dw, dh, sx, sy, sw, sh);
        // dx, dy, dw, dh   = the area of your display that you want to draw to.
        // sx, sy, sw, sh  = the part of the image to draw

        tint(40, 40, 40, 100);
        fill(40, 40, 40, 100);
        image(s_duel_header, (width/2)-(400/2), (height/3-(99/2)), 400, 99);

        textSize(32);
        text("HOLD SPACE TO CONTINUE", width/2, height/1.35);

        if(s_duel_fill.height*1.2<animTemp) game=true;

        if(game) {
                joueur1 = new Types("Zaba", true, color(150,120,120), width/2, 3*height/4, 50, 20); //Declare le joueur 1 : A BOUGER DANS LE LOBBY
                joueur2 = new Types("Zaba", false, color(200), width/2, height/4, 50, 20); //Declare le joueur 2 : A BOUGER DANS LE LOBBY
                bullets1 = new Bullets(20, joueur1, joueur2); //Same as above
                bullets2 = new Bullets(20, joueur2, joueur1); //Again, same as above
        }
}
//=======================================================================================================================
