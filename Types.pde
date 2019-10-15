// ==================================================== //
class Types extends Players{
  /*** Attributes ***/
  String type;

   // ==================================================== //
   /*** Methods ***/
  Types(String type_, float x_, float y_, float speed_){
    super(type_, x_, y_, speed_);
    type = type_;
  }

  // ==================================================== //
  /*** Functions ***/
  void dessiner(){     //Draws the player
    switch(type){
      case "Zaba":
        rectMode(CENTER);
        rect(position.x, position.y, 80, 80);
      break;

      default:
        println("AAAAAAAAAAAAAAAA");
      break;
    }
  }
  // Méthode animer : héritée, donc pas besoin de la réécrire


 void compute(){
   this.update();
   this.dessiner();
 }


}
