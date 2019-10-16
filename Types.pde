// ==================================================== //
class Types extends Players{
  /*** Attributes ***/
  String type;
  int colorPlayer;

  //Munition Attributes
  float charge=0;
  int maxCharge=6;
  int ammoLeft=6;
  int chargeRate=30;

  int tirs=0;

   // ==================================================== //
   /*** Methods ***/
  Types(String type_, boolean isPlayer_, int colorPlayer_, float x_, float y_, float size_, float speed_){
    super(type_, isPlayer_, colorPlayer_, x_, y_, size_, speed_);
    colorPlayer = colorPlayer_;
    type = type_;
    size = size_;
  }

  // ==================================================== //
  /*** Functions ***/
  void dessiner(){     //Draws the player
    switch(type){
      case "Zaba":
        rectMode(CENTER);
        stroke(255);
        strokeWeight(5);
        fill(colorPlayer);

        pushMatrix();
        translate(position.x, position.y);
        rotate(radians(angle));
        rect(0, 0, size, size);
        line(size/4, 0, size/2, 0);
        popMatrix();
      break;

      default:
      break;
    }
  }
  // Méthode animer : héritée, donc pas besoin de la réécrire

  // ==================================================== //
  /*** Bullet Functions ***/
  void munitionUpdate(Types joueur){
    type=joueur.type;
    switch(type){
      case "Zaba" :
      int temp=0;
        for(int i = 0; i<=2; i++){
          for(int j = 0; j<=2; j+=2){
            if(temp<ammoLeft) munitionDraw(i-1, j-1);
            temp++;
          }
        }
      break;

      default :
        //Should not happen
      break;
    }
  }

  void munitionDraw(int i, float j){
    strokeWeight(0);
    fill(255); //A rendre generique

    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    rect(i*20, j*40, 15, 15); //A rendre generique
    popMatrix();
  }

  void hold(int holdTime, boolean isShoot, Bullets bullets_){
    if(!isShoot){
      //Phase de hold
      if(holdTime>chargeRate*charge){
        //Increase le nombre de balles chargées
        if(charge<maxCharge && ammoLeft>0){
          //Si le nombre de balles chargées ne depasse pas le max, incremente son nombre
          //Il doit rester des balles...
          println("charge en cour : " + (charge+1) + " balles chargees");
          charge++;
          bgColor=10*charge;
          ammoLeft--;
        }
      }
    //Release
    }else if(holdTime>chargeRate || charge==1){
      println("Release");
      println(charge);
      shoot(true, bullets_);
      charge=0;
      ammoLeft=maxCharge;
    }
  }

  void shoot(boolean superTir, Bullets bullet_){
    if(!superTir || charge==1){
      if(ammoLeft>0){
        tirs++; println("tir No " + tirs);
        ammoLeft--;
        bgColor+=20;
        bullet_.spitFire(25, 15);
     }
    }
    else{
      println("superTir de " + charge + " balles");
      bgColor=20*charge;
      bullet_.spitFire( int(25 / (1+(charge*0.05)) ) , int(15 + (1 * charge * 5)) );
    }
  }
}
