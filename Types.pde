// ==================================================== //
class Types extends Players{
  /*** Attributes ***/
  String type;

   // ==================================================== //
   /*** Methods ***/
  Types(float x_, float y_, float speed_){
    super(x_, y_, speed_);
  }

  // ==================================================== //
  /*** Functions ***/
  void dessiner(){     //Draws the player
    switch(type){
      case "Square":
        rectMode(CENTER);
        rect(position.x, position.y, 80, 80);
      break;

      default:
        println("AAAAAAAAAAAAAAAA");
      break;
    }
  }
  // Méthode animer : héritée, donc pas besoin de la réécrire





}
