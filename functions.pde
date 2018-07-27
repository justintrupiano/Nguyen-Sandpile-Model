/////////////////////
//// COLOR GRAPH ////
/////////////////////
void colorGraph(int x1, int y1, int x2, int y2, boolean largeGraph){

    
        
    if (largeGraph){
      
      fill(25);
      rect(x1, y1, x2, y2);      
      stroke(100);
      fill(200);
      for (int i = 20; i < 600; i+=10){
        stroke(0, 200, 0);point(i, y1+5);
        stroke(200); point(i, y1+y2/2);
        stroke(200, 0, 0); point(i, y1+y2-5);
      }
      fill(0, 200, 0); text("GREEN", 5, y1+20);
      fill(200); text("50/50", 5, (y1+y2/2) + 15);
      fill(200, 0, 0); text("RED", 5, y1+y2+10);
      
      stroke(200);

      for (int i = 0; i < numGreen.length-1; i++){
        if (numGreen.length > 2){
          float xPoint1;
          float xPoint2;

          xPoint1 = map(i, 0, numGreen.length, x1, x1+x2);
          xPoint2 = map(i+1, 0, numGreen.length, x1, x1+x2);
          
          stroke(127, 127, 0);
          line(xPoint1, map(numGreen[i], 0, totalCells, y1+y2, y1), xPoint2, map(numGreen[i+1], 0, totalCells, y1+y2, y1));
        }
      }
      
      noStroke();
      
    }
    else{
      fill(200, 0, 0);
      rect(x1, y1, x2, y2);
      fill(0, 200, 0);
      rect(x1, y1, x2, map(green, 0, green+red, 0, y2));
      text((green/ totalCells) * 100, x1+x2, y1 + (y2/3));
      fill(200, 0, 0);
      text((red / totalCells) * 100, x1+x2, y1 + (y2/3)*2);
    }
}


////////////////////
//// COPY ARRAY ////
////////////////////
void copyBeliefArray(){
      for (int x = 0; x < worldWidth; x++) {
          for (int y = 0; y < worldHeight; y++) {
            cells[x][y].cellBelief = (cells[x][y].conviction > 0) ? true : false;
            cells[x][y].previousBelief = cells[x][y].cellBelief;
          }
      }
}


//////////////////////////////////////////////////////
//// COUNT NUMBER OF FLIPPED AND RESPECTIVE COLOR ////
//////////////////////////////////////////////////////
void countFlipsColor(boolean firstRun){
  green = 0;
  red = 0; 
  numFlipped = 0;
  for (int x = 0; x < worldWidth; x++) {
    for (int y = 0; y < worldHeight; y++) {
      if (!firstRun && cells[x][y].flipped){ numFlipped++; }
      if (cells[x][y].cellBelief){ green++; } else{ red++; }
    }
  }
  flips = append(flips, numFlipped);
  numGreen = append(numGreen, green);
}


/////////////////////////////////////
//// DISPLAY UPDATED CELL COLORS ////
/////////////////////////////////////
void displayCells(){
  noStroke();
   for (int x = 0; x < worldWidth; x++) {
     for (int y = 0; y < worldHeight; y++) {
       cells[x][y].display();
   }
  }
}


/////////////////////
//// DRAW GRAPHS ////
/////////////////////

void drawLargeGraphs(){
    noStroke();
    fill(40); rect(0, 0, height, height); // CLEAR LARGE GRAPHS
    flipGraph(55, 10, 540, 350, true);
    colorGraph(55, 385, 540, 200, true);
    displaySettings();

    //fill(60); rect(600, 245, 200, 295); // CLEAR GRAPHS
    //colorGraph(width-195, 395, 25, 95);
    //flipGraph(605, 250, 190, 95);
    //noStroke();
}

void drawSmallGraphs(){
    noStroke();
    fill(40); rect(600, 245, 200, 295); // CLEAR GRAPHS
    displaySettings();
    flipGraph(605, 250, 190, 95, false);
    colorGraph(605, 395, 25, 95, false);
}



//////////////////////
//// DISPLAY INFO ////
//////////////////////

void displaySettings(){
  noStroke();
  textAlign(LEFT);
  noStroke();
  fill(55); rect(695, 395, 95, 95); //CLEAR OLD SETTINGS DISPLAY
  fill(200);
  text("Threshold: ", 700, 415);
  text("Speed: " , 700, 435);
  textAlign(RIGHT);
  text(thresh, 695+90, 415);
  text(delayChange, 695+90, 435);
  textAlign(CENTER);
  if(playing){    
    fill(0, 200, 0);
    text("Playing...", 695+(95/2), 475);
  }
  else{
    fill(200, 0, 0);
    text("Paused", 695+(95/2), 475);
  }
  textAlign(LEFT);
}


////////////////////
//// FLIP GRAPH ////
////////////////////
void flipGraph(int x1, int y1, int x2, int y2, boolean largeGraph){ 
    if (flips.length > 2 && flips[flips.length-2] == 0 && numFlipped == 0){
      flips = shorten(flips); // STOP ADDING WHEN REACHING 0 FLIPS
      numGreen = shorten(numGreen);

    }
    
    largestFlip = max(flips);
    
    stroke(127);
    fill(25);
    rect(x1, y1, x2, y2);
    stroke(127, 127, 0);

    if (largestFlip > 0){
      for (int i = 0; i < flips.length; i++){
        float xPoint1;
        float xPoint2;
        if (i == 0){
          xPoint1 = x1+5;
        }
        else{
          xPoint1 = map(i, 0, flips.length, x1+5, x1+x2-5);
        }
        if (i == flips.length-1){
          xPoint2 = x2-5;
        }
        else{
          xPoint2 = map(i+1, 0, flips.length, x1+5, x1+x2-5);
        }
        
        if (flips.length > i+1){
          line(xPoint1, map(flips[i], 0.0, largestFlip, y1+y2-5, y1+5), xPoint2, map(flips[i+1], 0.0, largestFlip, y1+y2-5, y1+5));
        }
      }

    }
    
    /// LARGE GRAPH ///
    if (largeGraph){
      int current = int(flips[flips.length-1]);
      stroke(100);
      fill(200);
      
      // FLIP GRAPH TEXT //
      // DOTS FOR X AXIS //

      for (int i = 20; i < 600; i+=10){
        point(i, 15);
        point(i, y1+y2/2);
        point(i, ((y1+y2)*0.25)+5);
        point(i, ((y1+y2-10)*0.75)+5);
        point(i, y1+y2-5);
        point(i, map(current, 0.0, largestFlip, y1+y2-5, y1+5) );
      }

      textAlign(LEFT);
      text(int(max(flips)), 5, 25);
      text(int(max(flips)/2), 5, (y1+y2/2)+10);
      text(int(max(flips)*0.75), 5, ((y1+y2)*0.25)+15);
      text(int(max(flips)*0.25), 5, ((y1+y2)*0.75)+15);
      text("0", 5, y1+y2+5);
      
      text("Current num of flips: " + current, 55, y1+y2+17);
      text("Num of frames: " + flips.length, 255, y1+y2+17);

      
    }
    
    /// SMALL GRAPH ///
    else{
      fill(200);
      text("Max", 605, 360);
      text(int(max(flips)), x1, 375);
      text("Current", x1+y2, 360);
      text(int(flips[flips.length-1]), x1+y2, 375);
    }

}


//////////////////////////////////////
//// TOGGLE LARGE GRAPHS ON / OFF ////
//////////////////////////////////////
void largeGraphsToggle(){
  if (graphsOpen){
     displayCells();
  }
  else{
    drawLargeGraphs();
  }
  graphsOpen = !graphsOpen;
}


//////////////////////////////////
//// GET NEW VALUES FOR CELLS ////
//////////////////////////////////
void newCellValues(){
  flips = new float[0];
  numGreen = new float[0];
  worldWidth = height/cellSize; 
  worldHeight = height/cellSize;
  totalCells = worldWidth * worldHeight;
  cells = new Cell[worldWidth][worldHeight];
  for (int x = 0; x < worldWidth; x++) {
    for (int y = 0; y < worldHeight; y++) {
      cells[x][y] = new Cell(x, y);
    }
  }
  countFlipsColor(true); // BOOL IS IF FIRST RUN
}


////////////////////////////////////////////////////////////////////////////////////
//// RUNS NEW GELL VALUES FUNCTION (SEPERATE FUNCTION IS NEEDED FOR THE BUTTON) ////
////////////////////////////////////////////////////////////////////////////////////
void restart(){
  newCellValues();
  drawSmallGraphs();
  if (graphsOpen){
    drawLargeGraphs();
  }
  else{
    displayCells();
  }

}

////////////////////////////
//// UPDATE CELL VALUES ////
////////////////////////////
void updateCells(){
  copyBeliefArray();
  for (int x = 0; x < worldWidth; x++) {
    for (int y = 0; y < worldHeight; y++) {
      cells[x][y].update(x, y);
    }
  }
}
      
