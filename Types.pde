// ==================================================== //
class Types extends Players {
/*** Attributes ***/
String type;
int colorPlayer;

//Munition Attributes
int charge=0;
int maxCharge=6;
int ammoLeft=6;
int chargeRate=15;
boolean aiShoot=true;
float speed;

int tirs=0;
int tempReload=0;

PVector[] vertices;

// ==================================================== //
/*** Methods ***/
Types(String type_, boolean isPlayer_, int colorPlayer_, float x_, float y_, float size_, float speed_){
        super(type_, colorPlayer_, x_, y_, size_, speed_);
        colorPlayer = colorPlayer_;
        type = type_;
        size = size_;
        speed = speed_;


        if(debug) println("Init " + (isPlayer_ ? "player" : "ennemy")
                +" as type " + type_
                +", at x=" + x_ + ", y=" + y
                +", using color " +red(colorPlayer) +","+green(colorPlayer)+","+blue(colorPlayer));
}

// ==================================================== //
/*** Functions ***/
void dessiner(){         //Draws the player
        //Set la couleur, le contour, et l'epaisseur du joueur
        stroke(255);
        strokeWeight(5);
        fill(color(red(colorPlayer)*(life/100), green(colorPlayer)*(life/100), blue(colorPlayer)*(life/100)));

        //Calcule les positions des coins du joueur
        PVector[] vertices = calcVertices(6, playerPoints, angle, position);

        switch(type) {
        case "Zaba":
                //Dessine le joueur
                beginShape(); for(int i = 0; i<4; i++) vertex(vertices[i].array()); endShape(CLOSE);
                line(vertices[4].x, vertices[4].y, vertices[5].x, vertices[5].y);
                break;
        case "Oslo":
                ellipse(position.x, position.y, size, size);
                line(vertices[4].x, vertices[4].y, vertices[5].x, vertices[5].y);
                break;
        }
}

// ==================================================== //
/*** Bullet Functions ***/
void munitionDraw(Types joueur){
        type=joueur.type;
        switch(type) {
        case "Zaba":
                int temp=0;
                for(int i = 2; i>=0; i--) {
                        for(int j = 0; j<=2; j+=2) {
                                if(temp<ammoLeft) munitionDrawInternal(i-1, j-1);
                                temp++;
                        }
                }
                break;

        default:
                //Should not happen
                break;
        } //A rendre generique
}
void munitionDrawInternal(int i, float j){
        strokeWeight(0);
        fill(255);   //A rendre generique

        pushMatrix();
        translate(position.x, position.y);
        rotate(angle);
        rect(i*20, j*40, 15, 15);   //A rendre generique
        popMatrix(); //A rendre generique
}
void hold(int holdingTime_){
        aiShoot=true;
        if(ammoLeft>0 && holdingTime_>charge*chargeRate && charge < maxCharge) {
                charge++; ammoLeft--;
                if(debug) println("Charge level : " +charge);
        }
}
void shoot(Bullets bullets_, PVector target){
        if(debug) print("Shoot");
        aiShoot=false;
        bgColor+=charge*20;
        if(ammoLeft>0 || charge>=1) {
                if(debug) println(" with charge : "+ charge+", has "+ammoLeft+" ammos left");
                bullets_.spitFire(speed ,charge, target);
                charge=0;
                tempReload=0;
        } else if(debug) println(" failed : no ammo left");
}
void reload(boolean noReload){
  tempReload++;
  if (tempReload > chargeRate*1.5 && ammoLeft<maxCharge && !noReload) { ammoLeft++; tempReload=0;}
}
}
