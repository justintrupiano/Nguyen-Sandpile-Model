//
//
//
//                 CONTROLS 
//
// Play / Pause Toggle:      p
// Threshold:                1 - 8
// Speed:                    9 (slower), 0 (faster)
// Size of Cell:             - (smaller), + (larger)
//
//
//
//



import controlP5.*;
ControlP5 reset, influence, influenceInput, randomInfluence, randomFlip, highlightFlipped, viewLargeGraphs;

int worldWidth;
int worldHeight;
int thresh = 1; // 1 - 8
int cellSize = 4;
int delayChange = 1;
int buttonWidth = 200;
int buttonHeight = 50;
int numFrames = 0;

float flips[] = new float[0];
float numGreen[] = new float[0]; // NUM RED WILL BE GREEN MINUS TOTAL
float[] amountGreen = {};
float largestFlip;
float beliefChange = 0.0;
float cellDelay = 1000/delayChange;
float cellTimer = 0;
float totalCells;
float green = 0;
float red = 0;
float numFlipped;

boolean influenceBool = false;
boolean randomInfluenceBool = false;
boolean randomFlipBool = false;
boolean playing = false;
boolean showFlipped = false;
boolean graphsOpen = false;

PShape s;
PFont font;

Cell[][] cells;

void setup() {

  size(800, 600);
  background(25);
  stroke(127);
  fill(25);
  noStroke();


  // RESET BUTTON ////
  reset = new ControlP5(this); 
  reset.addButton("restart")
   .setPosition(width-buttonWidth,height-buttonHeight)
   .setSize(buttonWidth,buttonHeight)
   ;
   
   
   // TODO //
  // DESPLAY LARGE GRAPHS ////
  viewLargeGraphs = new ControlP5(this); 
  viewLargeGraphs.addButton("largeGraphsToggle")
   .setCaptionLabel(" Show/Hide Larger Graphs")
   .setPosition(width-buttonWidth,height-buttonHeight*2)
   .setSize(buttonWidth,buttonHeight)
   ;   
     
    
  //// SLIDER ////
  influenceInput = new ControlP5(this);
  influenceInput.addSlider("beliefChange")
     .setCaptionLabel("")
     .setRange(0,1)
     .setPosition(width - 200,0)
     .setSize(200,50)
     .setNumberOfTickMarks(100)
     .setSliderMode(Slider.FLEXIBLE)
     .setTriggerEvent(Slider.RELEASED)
     ;

  //// INFLUENCE TOGGLE ////
  influence = new ControlP5(this);
  influence.addToggle("influenceBool")
    .setCaptionLabel(" influence neighbor on flip")
    .setPosition(width-200,54)
    .setSize(200, 20)
    ;
    
  //// RANDOM INFLUENCE TOGGLE ////
  randomInfluence = new ControlP5(this);
  randomInfluence.addToggle("randomInfluenceBool")
    .setCaptionLabel(" influence random 3x3 square")
    .setPosition(width-200, 100)
    .setSize(200, 20)
    ;
    
  //// RANDOM FLIP TOGGLE ////
  randomFlip = new ControlP5(this);
  randomFlip.addToggle("randomFlipBool")
    .setCaptionLabel(" flip random 3x3 square")
    .setPosition(width-200,145)
    .setSize(200, 20)
    ;
    
  //// HIGHLIGHT FLIPPED ////
  highlightFlipped = new ControlP5(this);
  highlightFlipped.addToggle("showFlipped")
    .setCaptionLabel(" highlight cell on flip")
    .setPosition(width-200,195)
    .setSize(200, 20)
    ;

  restart();
  displayCells();
}

void draw(){

  if(playing && millis() > cellDelay){

      updateCells();
     
      if (randomInfluenceBool && beliefChange != 0){
        int currentX = int(random(worldWidth));
        int currentY = int(random(worldHeight));
        cells[currentX][currentY].influenceSquare(currentX, currentY);
      }
      
      if (randomFlipBool){
        int currentX = int(random(worldWidth));
        int currentY = int(random(worldHeight));
        cells[currentX][currentY].flipSquare(currentX, currentY);
      }
      
      
      
     /// DRAW GRAPHS ///

      if (!graphsOpen){
        countFlipsColor(false);
        displayCells();
        drawSmallGraphs();
      }
      else{
        countFlipsColor(false);
        drawSmallGraphs();
        drawLargeGraphs();
      }
      
      cellDelay = millis() + (1000/delayChange);
    
  }
  
  
  

}


void keyPressed(){
  if(key == '1'){thresh = 1; displaySettings();}
  if(key == '2'){thresh = 2; displaySettings();}
  if(key == '3'){thresh = 3; displaySettings();}
  if(key == '4'){thresh = 4; displaySettings();}
  if(key == '5'){thresh = 5; displaySettings();}
  if(key == '6'){thresh = 6; displaySettings();}
  if(key == '7'){thresh = 7; displaySettings();}
  if(key == '8'){thresh = 8; displaySettings();}
  if(key == '-'){cellSize = constrain( cellSize - 1, 1, 50); background(25); restart();}
  if(key == '='){cellSize = constrain( cellSize + 1, 1, 50); background(25); restart();}
  if(key == '9'){delayChange = constrain( delayChange - 1, 1, 100); cellDelay = millis() + (1000/delayChange); displaySettings();}
  if(key == '0'){delayChange = constrain( delayChange + 1, 1, 100); cellDelay = millis() + (1000/delayChange); displaySettings();}
  if(key == 'p'){playing = !playing; displaySettings();}
}




void mouseClicked(){
  
  int currentX = int(map(mouseX, 0, height, 0, worldWidth));
  int currentY = int(map(mouseY, 0, height, 0, worldHeight));
  
  //println(worldWidth);
  
  if (currentX < worldWidth && currentY < worldHeight){
  //  cells[currentX][currentY].influenceNeighbors(currentX, currentY);
    println(cells[currentX][currentY].conviction);

  }
  //println(mouseX, " ", mouseY);
  


    //if (graphsOpen == false){
    //  fill(0);
    //  rect(0, 0, 600, 600);
      
    //}
    //else{
    //  displayCells();
    //}
    //graphsOpen = !graphsOpen;
    
  

}
