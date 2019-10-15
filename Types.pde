// ==================================================== //
class Types extends Players{
  /*** Attributes ***/
  String type;
  int colorPlayer;

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
}
