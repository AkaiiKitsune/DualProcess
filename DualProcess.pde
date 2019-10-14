import processing.net.*;

boolean isServer;
boolean reset = false;
int packetsLost;
int packetsLostLimit=10;

Server server;
Client client;
Players joueur1 = new Players("Square", 0, 200, 20);
Players joueur2;
String input = " ";
int data[];


/*=================================================================================*/
/* Main :
** void setup(){}
    --> Initialise les variables et les connections
** void draw(){}
    --> Boucle principale du programme*/

void setup(){
  size(800, 500);
  background(204);
  stroke(0);
  frameRate(60); // Slow it down a little


  // connect(reset);
  // if(isServer){
  // }
}

void draw(){
  background(0);

  joueur1.update();
  joueur1.dessiner();
  debug();

  // send(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
}
/*=================================================================================*/

void debug(){ //un bon outil de debug.
  println("                                                            ");
  println("         Statistics                                   "      );
  println("Time elapsed    : " + (float)millis()/1000 + " seconds"      );
  println("Player Position : " + joueur1.position.x+" "+joueur1.position.y);
  println("Left            : " + joueur1.isLeft                         );
  println("Up              : " + joueur1.isUp                           );
  println("Down            : " + joueur1.isDown                         );
  println("Right           : " + joueur1.isRight                        );
  println("                                                            ");
}

/*=================================================================================*/
/* Intéraction :
** void keyPressed(){}
    --> Une touche est elle appuyée ?
** void keyReleased(){}
    --> Une touche viens d'etre relachée ?*/

void keyPressed()  {joueur1.setMove(keyCode, true) ;} //utilisé pour la detection des touches.
void keyReleased() {joueur1.setMove(keyCode, false);} //utilisé pour la detection des touches.
/*=================================================================================*/


/*=================================================================================*/
/* Networking :
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

    while(!serverSend("plz respond")){
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
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    // Draw line using received coords
    stroke(0);
    line(data[0], data[1], data[2], data[3]);
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
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    // Draw line using received coords
    stroke(0);
    line(data[0], data[1], data[2], data[3]);
    return true;
  }else{
    return false;
  }
}
/*=================================================================================*/
