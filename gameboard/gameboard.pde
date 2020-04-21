import processing.serial.*;       

Serial myPort;

PGraphics rect;
PShape s;
PFont f;
PImage card1;
PImage card2;
PImage card3;
PImage card4;
PImage card5;
PImage card6;
PImage card7;
PImage card8;
PImage backside;

int cards[][] = {
  {1, 2, 3, 4}, 
  {5, 6, 7, 8}, 
  {9, 10, 11, 12}, 
  {13, 14, 15, 16}
};

int x = 0;
int y = 0;
int cardSizeX = 200;
int cardSizeY = 200;
int distance = 15;
int cardsAmount = 16;


int cardMidLocationsX[]={0, 0, 0, 0};
int cardMidLocationsY[]={0, 0, 0, 0};

boolean firstContact = false;
int serialCount = 0;
int[] serialInArray = new int[3];
int xCard, yCard, cardType;
int clear = 0;

void setup() {
  size(845, 900);
  background(100);
  myPort = new Serial(this, Serial.list()[1], 9600);
 
  card1 = loadImage("image1.jpg");
  card2 = loadImage("image2.jpg");
  card3 = loadImage("image3.jpg");
  card4 = loadImage("image4.jpg");
  card5 = loadImage("image5.jpg");
  card6 = loadImage("image6.jpg");
  card7 = loadImage("image7.jpg");
  card8 = loadImage("image8.jpg");
  backside = loadImage("backside.jpg");
  card1.resize(cardSizeX, cardSizeY);
  card2.resize(cardSizeX, cardSizeY);
  card3.resize(cardSizeX, cardSizeY);
  card4.resize(cardSizeX, cardSizeY);
  card5.resize(cardSizeX, cardSizeY);
  card6.resize(cardSizeX, cardSizeY);
  card7.resize(cardSizeX, cardSizeY);
  card8.resize(cardSizeX, cardSizeY);
  backside.resize(cardSizeX, cardSizeY);
  
  f = createFont("Arial", 16, true);
 
  startUpDrawCards();
}
void draw(){
  if(clear == 1){
    startUpDrawCards();
  }else{
    drawCards(cardType, xCard, yCard);
  }
}

void startUpDrawCards(){
  int distanceX = cardSizeX + distance;
  int distanceY = cardSizeY + distance;
  int currentX = cardSizeX/2;
  int currentY = cardSizeY/2;
  
  for (int i = 0; i < 4; i++) {
    cardMidLocationsX[i] = currentX;
    currentX = distanceX + currentX;
    print(cardMidLocationsX[i]);
    print(" ");
  }
  for (int i = 0; i < 4; i++){
    cardMidLocationsY[i] = currentY;
    currentY = distanceY + currentY;
    println(cardMidLocationsY[i]);
    println("");
  }
  
  for(int x = 0; x < 4; x++){
    for(int y = 0; y < 4; y++){
      image(backside, cardMidLocationsX[x]-cardSizeX/2, cardMidLocationsY[y]-cardSizeX/2);
    }
  }
}

  void serialEvent(Serial myPort) {
    // read a byte from the serial port:
    int inByte = myPort.read();
    // if this is the first byte received, and it's an A, clear the serial
    // buffer and note that you've had first contact from the microcontroller.
    // Otherwise, add the incoming byte to the array:
    //println(inByte);
    if (firstContact == false) {
      if (inByte == 'A') {
        myPort.clear();          // clear the serial port buffer
        firstContact = true;     // you've had first contact from the microcontroller
        myPort.write('A');       // ask for more
      }
    }
    else {
      // Add the latest byte from the serial port to array:
      serialInArray[serialCount] = inByte;
      serialCount++;

      // If we have 3 bytes:
      if (serialCount > 2 ) {
        cardType = serialInArray[0];
        xCard = serialInArray[1];
        yCard = serialInArray[2];
        //clear = serialInArray[3];
        
        println(cardType + "\t" + xCard + "\t" + yCard + "\t");

        // Send a capital A to request new sensor readings:
        myPort.write('A');
        // Reset serialCount:
        serialCount = 0;
      }
    }
  }
  
  void drawCards(int cardType, int cardX, int cardY){
    rect = createGraphics((cardMidLocationsX[3] + 30), (cardMidLocationsY[3] + 70)); 
    rect.beginDraw();
    rect.stroke(0);
    rect.background(100);
    rect.endDraw();
    //rect.endShape();
    switch(cardType){
      case 1:
        image(card1, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      case 2:
        image(card2, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      case 3:
        image(card3, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      case 4:
        image(card4, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      case 5:
        image(card5, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      case 6:
        image(card6, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      case 7:
        image(card7, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      case 8:
        image(card8, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
      default:
        image(backside, cardMidLocationsX[cardX]-cardSizeX/2, cardMidLocationsY[cardY]-cardSizeX/2);
      break;
    }
    image(rect, cardMidLocationsX[3]-3, cardMidLocationsY[3] + (cardSizeY/2 + 10));
    text(cardX, cardMidLocationsX[3], cardMidLocationsY[3] + (cardSizeY/2 + 20));
    text(cardY, cardMidLocationsX[3] + 12, cardMidLocationsY[3] + (cardSizeY/2 + 20));
    text(cardType, cardMidLocationsX[3] + 22, cardMidLocationsY[3] + (cardSizeY/2 + 20));
  }
    
