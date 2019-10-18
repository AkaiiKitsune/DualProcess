      // Fonctions Utiles
//=======================================================================================================================
/* **void updatePlayer2(String input){}
    --> Update la position du joueur2.
    String input : Requete raw envoyée par le serveur / client, elle y sera parsée et convertie en INT
*/
void updatePlayer2(String input){
        input = input.substring(0, input.indexOf("\n")); // Only up to the newline
        data = split(input, ' '); // Split values into an array

        bgColor = int(data[0]);
        joueur2.setPos(width - int(data[1]), //x
                       height - int(data[2]), //y
                       int(data[3])); //angle
        joueur2.ammoLeft = int(data[4]); //Balles
        joueur2.dessiner(); //Draw le joueur 2
}

/* **void drawBackground(){}
   --> Affiche le background et l'ui du jeu.
*/
void drawBackground(int bgGridScale, int bgScale, float bgColor){
        background(0);
        strokeWeight(2);
        stroke(bgColor);
        fill(0);

        float x_, y_;
        for(int x = 0; x < width*1.2; x += bgGridScale) {
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
        line(0, height/2, width, height/2);
}

/* **float angleBetweenPV_PV(PVector a, PVector mousePV){}
   --> Calcule l'angle entre la souris et un vecteur
*/
float angleBetweenPV_PV(PVector a, PVector mousePV) {
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

PVector rotatePoint(float angle_, PVector pos_, PVector ref_){
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
        joueur1.setMove(keyCode, true);
}
void keyReleased() { //Utilisé pour la detection des touches
        joueur1.setMove(keyCode, false);
}
void mousePressed() { //La souris est maintenue
        holdingMouse=true; //Booleen modifié
        if(mouseButton == LEFT) joueur1.shoot(false, bullets1); //Si le click est un click gauche, prepare l'attaque lourde
}

void mouseReleased() { //La souris est relachée
        holdingMouse=false; //Reset du booleen
        joueur1.hold(holdingTime, true, bullets1); //Tir puissant
        holdingTime=0; //Reset du temps de maintien
}
//=======================================================================================================================



      // Networking :
//=======================================================================================================================
/* ** void connect(boolean reset){}
   --> determine si l'app doit se lancer en client ou en serveur, puis initialise les connections
   boolean reset : permet de specifier si le client/serveur doit reset une ancienne connection.*/
void connect(boolean reset){
        packetsLost=0;
        if(reset) {
                if(isServer) server.stop();
                else client.stop();
        }
        println("About to try to connect...");//client
        client = new Client(this, "127.0.0.1", 12345); // Connection to localhost
        println("Is client connected ?");
        if(client.active()) {
                println("Yes, connected to " + client.ip() + ", starting main loop.");
                isServer=false;
        }else{
                println("No, entering server mode.");
                isServer=true;
                client.stop();
                server = new Server(this, 12345); // Start a simple server on a port
                println("Server started on " + server.ip() + ", Waiting for client...");

                while(!serverSend("arg0 arg1 arg2 arg3 arg4"+"\n")) {
                        delay(100);
                }

                println("Connected to " + client.ip());
        }
}

/* ** boolean send(String str){}
   --> permet d'envoyer les données
   String str : permet de passer les variables*/
boolean send(String str){
        if(packetsLost>packetsLostLimit) {
                println("Instable connection, lost connection.");
                reset = true;
                setup();
                draw();
        }
        if(isServer) {
                if(serverSend(str)) {
                        if(packetsLost>0) packetsLost--;
                        return true;
                }
        }else{
                if(clientSend(str)) {
                        if(packetsLost>0) packetsLost--;
                        return true;
                }
        }
        println("Packet Lost");
        packetsLost++;
        return false;
}

/* ** boolean serverSend(String str){}
   --> envoye les données au client
   String str : permet de passer les variables*/
boolean serverSend(String str){
        server.write(str);

        // Receive data from client
        client = server.available();
        if (client != null) {
                input = client.readString();
                updatePlayer2(input);
                return true;
        }else{
                return false;
        }
}

/* ** boolean clientSend(String str){}
    --> envoye les données au serveur
    String str : permet de passer les variables*/
boolean clientSend(String str){
        client.write(str);

        // Receive data from server
        if (client.available() > 0) {
                input = client.readString();
                updatePlayer2(input);
                return true;
        }else{
                return false;
        }
}
//=======================================================================================================================



/* Collisions :
//=======================================================================================================================
 ** boolean connect(polyPoly(PVector[] p1, PVector[] p2){}
 ** boolean polyLine(PVector[] p2, float x1, float y1, float x2, float y2){}
 ** boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4){}
 */
boolean polyPoly(PVector[] p1, PVector[] p2) { //aled

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
    PVector vc = p1[current];    // c for "current"
    PVector vn = p1[next];       // n for "next"

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
