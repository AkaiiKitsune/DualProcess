import processing.net.*;

boolean holdingMouse, isServer, reset = false,
                      isOnline=true;

int packetsLost, holdingTime,
                packetsLostLimit=20;

float bgColor=30;

Server server;
Client client;

Types joueur1, joueur2;
Munitions joueur1M, joueur2M;
String input = " ", data[];

/* Main :
/*=================================================================================
** void setup(){}
    --> Initialise les variables et les connections
** void draw(){}
    --> Boucle principale du programme*/
void setup(){
  size(800, 1000);
  background(204);
  stroke(0);
  frameRate(60); // Slow it down a little
  smooth(6);

  joueur1 = new Types("Zaba", true, color(150,120,120), width/2, 3*height/4, 50, 20);
  joueur1M = new Munitions(joueur1);

  joueur2 = new Types("Zaba", false, color(200), width/2, height/4, 50, 20);
  joueur2M = new Munitions(joueur2);

  if(isOnline){
    connect(reset);
      if(isServer){
    }
  }
}

void draw(){
  drawBackground(50, 5, bgColor);
  if(bgColor>20)bgColor*=0.95;

  joueur1.dessiner();
  joueur1M.dessiner();
  joueur1.update();


  joueur2.dessiner();
  joueur2M.dessiner();

  rect(mouseX, mouseY, 10, 10); //Curseur de la souris

  if(holdingMouse){holdingTime++; joueur1M.hold(holdingTime, false);}

  if(isOnline) send(int(bgColor) + " " +
                    int(joueur1.position.x) + " " +
                    int(joueur1.position.y) + " " +
                    int(180+joueur1.angle) + " " +
                    int(joueur1M.ammoLeft) + "\n");
}
/*=================================================================================*/


/* Fonctions Utiles
/*=================================================================================
  **void updatePlayer2(String input){}
    --> Update la position du joueur2.
    String input : Requete raw envoyée par le serveur / client, elle y sera parsée et convertie en INT
  **void drawBackground(){}
    --> Affiche le background et l'ui du jeu.
    int bgGridScale : Set l'espace entre les points du background
    int bgScale : Set la taille des points du background
    int bgColor : set la couleur des points du background
*/
void updatePlayer2(String input){
  input = input.substring(0, input.indexOf("\n")); // Only up to the newline
  data = split(input, ' '); // Split values into an array
  bgColor = int(data[0]);
  joueur2.setPos(width - int(data[1]), //x
                 height - int(data[2]), //y
                 int(data[3])); //angle
  joueur2M.ammoLeft = int(data[4]); //Balles
  joueur2M.dessiner(); //Draw le joueur 2
}

void drawBackground(int bgGridScale, int bgScale, float bgColor){
  background(0);
  strokeWeight(2);
  stroke(bgColor);
  fill(0);

  float x_, y_;
  for(int x = 0; x < width*1.2; x += bgGridScale){
    for(int y = 0; y < height*1.2; y += bgGridScale){
      y_ = y-((joueur1.position.y)*0.1);
      x_ = x-((joueur1.position.x)*0.1);
      if(y_>height/2)rect(x_, y_, bgScale, bgScale);
      y_ = y-((joueur2.position.y)*0.1);
      x_ = x-((joueur2.position.x)*0.1);
      if(y_<height/2) rect(x_, y_, bgScale, bgScale);
    }
  }

  stroke(255);
  strokeWeight(10);
  line(0, height/2, width, height/2);
}
/*=================================================================================*/


/* Intéraction :
/*=================================================================================
** void keyPressed(){}
    --> Une touche est elle appuyée ?
** void keyReleased(){}
    --> Une touche viens d'etre relachée ?*/
void keyPressed()  {joueur1.setMove(keyCode, true) ;} //utilisé pour la detection des touches.
void keyReleased() {joueur1.setMove(keyCode, false);} //utilisé pour la detection des touches.
void mousePressed() {
  holdingMouse=true;
  if(mouseButton == LEFT){
    joueur1M.shoot(false); println("click");
  }
}
void mouseReleased() {
    holdingMouse=false;
    joueur1M.hold(holdingTime, true);
    holdingTime=0;
}
/*=================================================================================*/


/* Networking :
/*=================================================================================
** void connect(boolean reset){}
    --> determine si l'app doit se lancer en client ou en serveur, puis initialise les connections
    boolean reset : permet de specifier si le client/serveur doit reset une ancienne connection.
** boolean send(String str){}
    --> permet d'envoyer les données
    String str : permet de passer les variables
** boolean serverSend(String str){}
    --> envoye les données au client
    String str : permet de passer les variables
** boolean clientSend(String str){}
    --> envoye les données au serveur
    String str : permet de passer les variables*/
void connect(boolean reset){
  packetsLost=0;
  if(reset) {
    if(isServer) server.stop();
    else client.stop();
  }
  println("About to try to connect...");//client
  client = new Client(this, "127.0.0.1", 12345); // Connection to localhost
  println("Is client connected ?");
  if(client.active()){
    println("Yes, connected to " + client.ip() + ", starting main loop.");
    isServer=false;
  }else{
    println("No, entering server mode.");
    isServer=true;
    client.stop();
    server = new Server(this, 12345); // Start a simple server on a port
    println("Server started on " + server.ip() + ", Waiting for client...");

    while(!serverSend("arg0 arg1 arg2 arg3 arg4"+"\n")){
      delay(100);
    }

    println("Connected to " + client.ip());
  }
}

boolean send(String str){
    if(packetsLost>packetsLostLimit){
      println("Instable connection, lost connection.");
      reset = true;
      setup();
      draw();
    }
  if(isServer){
    if(serverSend(str)){
      if(packetsLost>0) packetsLost--;
      return true;
    }
  }else{
    if(clientSend(str)){
      if(packetsLost>0) packetsLost--;
      return true;
    }
  }
  println("Packet Lost");
  packetsLost++;
  return false;
}

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
/*=================================================================================*/
