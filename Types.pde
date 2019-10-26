// ==================================================== //
class Types extends Players {
/*** Attributes ***/
String type;
int colorPlayer;

//Munition Attributes
int charge=0;
int maxCharge=6;
int ammoLeft=6;
int chargeRate=30;

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


        println("Init " + (isPlayer_ ? "player" : "ennemy")
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
        }
}

void munitionDrawInternal(int i, float j){
        strokeWeight(0);
        fill(255);   //A rendre generique

        pushMatrix();
        translate(position.x, position.y);
        rotate(angle);
        rect(i*20, j*40, 15, 15);   //A rendre generique
        popMatrix();
}

void hold(int holdingTime_){
        if(ammoLeft>0 && holdingTime_>charge*chargeRate && charge < maxCharge) {
                charge++; ammoLeft--;
                println("Charge level : " +charge);
        }
}

void reload(){
  tempReload++;
  if (tempReload > chargeRate*1.5 && ammoLeft<maxCharge && !holdingMouse) { ammoLeft++; tempReload=0;}
}

void shoot(Bullets bullets_){
        print("Shoot");
        bgColor+=charge*20;
        if(ammoLeft>0 || charge>=1) {
                println(" with charge : "+ charge+", has "+ammoLeft+" ammos left");
                bullets_.spitFire(25,charge);
                charge=0;
                tempReload=0;
        } else println(" failed : no ammo left");
}
}
