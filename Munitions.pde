//http://studio.sketchpad.cc/sp/pad/view/ro.91nVQMnL$v06L/latest

class Munitions {
  /*** Attributes ***/
  float playerX, playerY, playerAngle,
        charge=1;
  String type;
  Types player;

  int maxCharge=6,
      ammoLeft=6,
      chargeRate=30;

  int[][] zabaBullets = { {-1,0}, {1,0},
                          {-1,1}, {1,1},
                          {-1,2}, {1,2}};

  // ==================================================== //
  /*** Methods ***/
  Munitions(Types player_){     //constructor
    player = player_;
    type = player_.type;
  }

  // ==================================================== //
  /*** Functions ***/
  void dessiner(){
    playerX = player.position.x;
    playerY = player.position.y;
    playerAngle = player.angle;

    switch(type){
      case "Zaba" :
      int temp=0;
        for(int i = 0; i<=2; i++){
          for(int j = 0; j<=2; j+=2){
            if(temp<ammoLeft) draW(i-1, j-1);
            temp++;
          }
        }
      break;

      default :
        //Should not happen
      break;
    }
  }


  void draW(int i, float j){
    pushMatrix();
    translate(playerX, playerY);
    rotate(radians(playerAngle));
    rect(i*20, j*40, 5, 5);
    popMatrix();
  }


  void hold(int holdTime, boolean isShoot){
    if(!isShoot){
      //Phase de hold
      if(holdTime>chargeRate*charge){
        //Increase le nombre de balles chargées
        if(charge<maxCharge && ammoLeft>0){
          //Si le nombre de balles chargées ne depasse pas le max, incremente son nombre
          //Il doit rester des balles...
          println("charge en cour : " + (charge+1) + " balles chargees");
          charge++;
          bgColor=15*charge;
          ammoLeft--;
        }
      }

    //Release
    }else if(holdTime>chargeRate && charge>1){
      shoot(true);
      charge=1;
      ammoLeft=maxCharge;
    }
  }


  void shoot(boolean superTir){
    if(!superTir){
      if(ammoLeft>0) ammoLeft--;
      bgColor+=20;
    }
    else{
      println("superTir de " + charge + " balles");
      bgColor=25*charge;
    }
  }
}
