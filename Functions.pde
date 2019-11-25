//Ce fichier contient toutes les fonctions universelles du jeu.

// Game loop + lobbys:
//=======================================================================================================================
void game(){
        if(bgColor>5) bgColor*=0.95;   //Decremente la valeur de la couleur du background, donne de l'effet

        if(holdingMouse) {holdingTime++; joueur1.hold(holdingTime);}   //Tir droit maintenu du joueur 1


        drawBackground(50, 5, bgColor);   //Affiche le background

        bullets1.updateBullets(joueur1.type); //Mise à jour des balles pour le joueur 1
        bullets2.updateBullets(joueur2.type); //Mise à jour des balles pour le joueur 2

        joueur1.updatePlayer(); //Mise à jour de la position du joueur 1
        joueur2.updateAi(joueur1); //Mise à jour de la position du joueur 2 en mode AI

        joueur1.reload(holdingMouse); //Gere le reload du joueur 1
        joueur1.munitionDraw(); //Gere l'affichage des munitions du joueur 1
        joueur2.reload(joueur2.aiShoot); //Gere le reload du joueur 2
        joueur2.munitionDraw(); //Gere l'affichage des munitions du joueur 2

        joueur1.dessiner(); //Affiche le joueur 1
        joueur2.dessiner(); //Affiche le joueur 2

        if(joueur1.life < 0 || joueur2.life < 0) { //Teste si la vie d'un des deux joueurs est nulle
                game=false; //Quite la game loop
                if(joueur1.life<0) {
                        if(debug) println("Player 2 won");
                } else if(joueur2.life<0) {
                        if(debug) println("Player 1 won");
                }
        }
}
void endGame(){ //Pas codé... oupsi :)
        int temp=0; //Oooooopsiiiii
}
void lobby(){ //Lobby (ce commentaire est très utile, oui oui)
        background(color(239, 44, 107)); //ROUGE :)

        if(keyPressed && (key == ' ' || key == ENTER)) { //Si la touche appuiée est ESPACE ou Entrée...
                animTemp+=8; //Incrémente la valeur de l'animation
        }else if(animTemp>0) animTemp *=.9; //Sinon, la reduit jusqu'a 0 de façon exponencielle (c'est plus joli)

        tint(255); //Contours blancs
        image(s_duel_fill.get(0, 0, s_duel_fill.width, animTemp), width/2-s_duel_fill.width/2, height/2-s_duel_fill.height/2); //Affiche le remplissage du logo en fonction de animTemp
        image(s_duel, width/2-s_duel.width/2, height/2-s_duel.height/2, s_duel.width, s_duel.height); //Affiche le logo

        tint(40, 40, 40, 100); //Gris
        fill(40, 40, 40, 100);
        image(s_duel_header, (width/2)-(400/2), (height/3-(99/2)), 400, 99); //Petit dessin joli au dessus du logo

        textSize(32);
        text("HOLD SPACE OR ENTER TO CONTINUE", width/2, height/1.35);

        if(s_duel_fill.height*1.2<animTemp) game=true; //si animTemp est superieur a un certain threshold : lance le jeu

        if(game) { //Set des objets pour le jeu
                joueur1 = new Types("Zaba", true, color(150,120,120), width/2, 3*height/4, 50, 20); //Declare le joueur 1 : A BOUGER DANS LE LOBBY
                joueur2 = new Types("Zaba", false, color(200), width/2, height/4, 50, 20); //Declare le joueur 2 : A BOUGER DANS LE LOBBY
                bullets1 = new Bullets(20, joueur1, joueur2); //Same as above
                bullets2 = new Bullets(20, joueur2, joueur1); //Again, same as above
        }
}
//=======================================================================================================================



// Fonctions Utiles
//=======================================================================================================================
void cursor(){
        fill(bgColor*3); stroke(255); strokeWeight(3); rect(mouseX, mouseY, 10, 10);   //Curseur de la souris
}
/* **void drawBackground(){}
   --> Affiche le background et l'ui du jeu.
 */
void drawBackground(int bgGridScale, int bgScale, float bgColor){ //Affichage du background
        background(0);
        strokeWeight(2);
        stroke(bgColor);
        fill(0); //Des sets sans importance

        float x_, y_;
        for(int x = 0; x < width*1.2; x += bgGridScale) { //Affiche la grille de petits carrés blancs à l'arriere du terrain de jeu
                for(int y = 0; y < height*1.2; y += bgGridScale) {
                        y_ = y-((joueur1.position.y)*0.1);
                        x_ = x-((joueur1.position.x)*0.1);
                        if(y_>height/2) rect(x_, y_, bgScale, bgScale);
                        y_ = y-((joueur2.position.y)*0.1);
                        x_ = x-((joueur2.position.x)*0.1);
                        if(y_<height/2) rect(x_, y_, bgScale, bgScale);
                }
        }

        stroke(255);
        strokeWeight(10);
        line(0, height/2, width, height/2); //Ligne du centre du terrain
}
//=======================================================================================================================



// Maths
//=======================================================================================================================
/* **float angleBetweenPV_PV(PVector a, PVector mousePV){}
   --> Calcule l'angle entre la souris et un vecteur
 */
float angleBetweenPV_PV(PVector a, PVector mousePV) { //Permet de calculer un angle entre deux vecteurs
        PVector d = new PVector();
        // calc angle
        pushMatrix();
        translate(a.x, a.y);
        // delta
        d.x = mousePV.x - a.x;
        d.y = mousePV.y - a.y;
        // angle
        float angle1 = atan2(d.y, d.x);
        popMatrix();
        return angle1;
}
PVector[] calcVertices(int nbr_, PVector[] points_, float angle, PVector position){ //Permet de calculer la position des points d'une shape en fonction de son angle
        PVector[] vertices = new PVector[nbr_];
        for(int i = 0; i<vertices.length; i++) vertices[i] = new PVector(rotatePoint(angle, points_[i], position).x,
                                                                         rotatePoint(angle, points_[i], position).y);
        return vertices;
}
PVector rotatePoint(float angle_, PVector pos_, PVector ref_){ //Permet d'afficher un vecteur en fonction d'un angle
        PVector positionPoint = new PVector();
        float xc = ref_.x + pos_.x/2;
        float yc = ref_.y + pos_.y/2;
        positionPoint.set((xc - ref_.x)*cos(angle_) - (yc - ref_.y)*sin(angle_) + ref_.x,
                          (xc - ref_.x)*sin(angle_) + (yc - ref_.y)*cos(angle_) + ref_.y);

        return positionPoint;
}
//=======================================================================================================================



// Intéraction :
//=======================================================================================================================
void keyPressed()  { //Utilisé pour la detection des touches
        if(game) joueur1.setMove(keyCode, true);
}
void keyReleased() { //Utilisé pour la detection des touches
        if(game) joueur1.setMove(keyCode, false);
}
void mousePressed() { //La souris est maintenue
        holdingMouse=true;
}
void mouseReleased() { //La souris est relachée
        holdingMouse=false; //Reset du booleen
        if(game) joueur1.shoot(bullets1, new PVector(mouseX, mouseY));
        holdingTime=0; //Reset du temps de maintien
}
//=======================================================================================================================



/* Collisions :
   //=======================================================================================================================
 ** boolean connect(polyPoly(PVector[] p1, PVector[] p2){}
 ** boolean polyLine(PVector[] p2, float x1, float y1, float x2, float y2){}
 ** boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4){}
 */
boolean polyPoly(PVector[] p1, PVector[] p2) { //aled
        // La on passe en anglais par ce que j'etait fatigué
        // go through each of the vertices, plus the next
        // vertex in the list
        int next = 0;
        for (int current=0; current<p1.length; current++) {

                // get next vertex in list
                // if we've hit the end, wrap around to 0
                next = current+1;
                if (next == p1.length) next = 0;

                // get the PVectors at our current position
                // this makes our if statement a little cleaner
                PVector vc = p1[current]; // c for "current"
                PVector vn = p1[next]; // n for "next"

                // now we can use these two points (a line) to compare
                // to the other polygon's vertices using polyLine()
                boolean collision = polyLine(p2, vc.x,vc.y,vn.x,vn.y);
                if (collision) return true;
        }

        return false;
}
boolean polyLine(PVector[] p2, float x1, float y1, float x2, float y2) { //vraiment, a l'aide

        // go through each of the vertices, plus the next
        // vertex in the list
        int next = 0;
        for (int current=0; current<p2.length; current++) {

                // get next vertex in list
                // if we've hit the end, wrap around to 0
                next = current+1;
                if (next == p2.length) next = 0;

                // get the PVectors at our current position
                // extract X/Y coordinates from each
                float x3 = p2[current].x;
                float y3 = p2[current].y;
                float x4 = p2[next].x;
                float y4 = p2[next].y;

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
boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) { //envoyez la police

        // calculate the direction of the lines
        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

        // if uA and uB are between 0-1, lines are colliding
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
                return true;
        }
        return false;
}
//=======================================================================================================================
