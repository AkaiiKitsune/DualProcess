class Munitions {
/*** Attributes ***/
float charge=1;
String type;
Types player;

int maxCharge=6,
    ammoLeft=6,
    chargeRate=30;

// ==================================================== //
/*** Methods ***/
Munitions(Types player_){         //constructor
        player = player_;
        type = player_.type;
}

// ==================================================== //
/*** Functions ***/
void hold(int holdTime, boolean isShoot){
        if(!isShoot) {
                //Phase de hold
                if(holdTime>chargeRate*charge) {
                        //Increase le nombre de balles chargées
                        if(charge<maxCharge && ammoLeft>0) {
                                //Si le nombre de balles chargées ne depasse pas le max, incremente son nombre
                                //Il doit rester des balles...
                                println("charge en cour : " + (charge+1) + " balles chargees");
                                charge++;
                                bgColor=15*charge;
                                ammoLeft--;
                        }
                }

                //Release
        }else if(holdTime>chargeRate && charge>1) {
                shoot(true);
                charge=1;
                ammoLeft=maxCharge;
        }
}


void shoot(boolean superTir){
        if(!superTir) {
                if(ammoLeft>0) ammoLeft--;
                bgColor+=20;
        }
        else{
                println("superTir de " + charge + " balles");
                bgColor=25*charge;
        }
}
}
