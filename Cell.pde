class Cell{

  float xPos, yPos;
  float conviction;   // Float between -1 and 1
  
  boolean cellBelief;     // positive == True, negative == False
  boolean previousBelief;
  boolean flipped;

  color fillColor; // RED <<>> GREEN

  
  Cell(int thisX, int thisY) {
    xPos = thisX*cellSize;
    yPos = thisY*cellSize;
    conviction = random(-1, 1);
    if (conviction > 0){
      fillColor = color(0, int(map(conviction, 0, 0.999, 55, 255)), 0);
      cellBelief = true;
    }
    else{
      fillColor = color(int(map(conviction, -0.999, 0, 255, 55)), 0, 0);
      cellBelief = false;
    }

    
  }


  void update(int thisX, int thisY){
    int neibTrue = 0;
    int neibFalse = 0;

    for (int x = -1; x <= 1; x++){
        for (int y = -1; y <= 1; y++){
            int neighborX;
            int neighborY;
            neighborX = thisX + x;
            neighborY = thisY + y;
            
            if (neighborX == worldWidth){ neighborX = 0;}
            if (neighborX == -1){ neighborX = worldWidth-1;}
            if (neighborY == worldHeight){ neighborY = 0;}
            if (neighborY == -1){ neighborY = worldHeight-1;}
            
            if (!(x == 0 && y == 0)){ // DON'T COUNT SELF
              if (cells[neighborX][neighborY].previousBelief) {
                neibTrue++;
              }
              else {
                neibFalse++;
              }

            }
        }
      }

    // IF THE EXISTING BELIEF IS ABOVE THE THRESHOLD DO NOTHING //
    if((cellBelief && neibTrue >= thresh) || (!cellBelief && neibFalse >= thresh)){
      flipped = false;
    }
    else{
        if (!cellBelief && neibTrue >= thresh) { 
        //if (cellBelief == false) { // UNCOMMENT THIS LINE AND COMMENT THE ABOVE LINE FOR FLICKERING PATTERNS IN 5+ THRESHOLDS
        cells[thisX][thisY].conviction += 1;
        flipped = true;
        if (influenceBool && beliefChange != 0){
            influenceNeighbors(thisX, thisY);
          }
      } 
      
      else if (cellBelief && neibFalse >= thresh) {
      //else if (cellBelief == true) { // UNCOMMENT AND COMMENT ABOVE FOR FLICKERING PATTERNS IN 5+
        cells[thisX][thisY].conviction -= 1;
        flipped = true;
        if (influenceBool && beliefChange != 0){
          influenceNeighbors(thisX, thisY);
        }
      }
      else{
        flipped = false;
      }
    
    }
  }
  
  void display() {
    if(flipped && showFlipped){
      fillColor = (conviction > 0) ? color(127, 255, 127) : color(255, 127, 127);
    }
    else{
      fillColor = (conviction > 0) ? color(0, int(map(conviction, 0, 1, 55, 255)), 0) : color(int(map(conviction, -1, 0, 255, 55)), 0, 0);
    }
    if (conviction == 0.0){ fillColor = color(0);}
    
    fill(fillColor);
    rect(xPos, yPos, cellSize, cellSize);
   }
   
   
   void flipSquare(int thisX, int thisY){
        for (int x = -1; x <= 1; x++){
        for (int y = -1; y <= 1; y++){
            int neighborX;
            int neighborY;
            neighborX = thisX + x;
            neighborY = thisY + y;
            if (neighborX == worldWidth){ neighborX = 0;}
            if (neighborX == -1){ neighborX = worldWidth-1;}
            if (neighborY == worldHeight){ neighborY = 0;}
            if (neighborY == -1){ neighborY = worldHeight-1;}
            cells[neighborX][neighborY].conviction *= -1;
        }
      }
      
      
   }
   
      void influenceSquare(int thisX, int thisY){
        for (int x = -1; x <= 1; x++){
        for (int y = -1; y <= 1; y++){
            int neighborX;
            int neighborY;
            neighborX = thisX + x;
            neighborY = thisY + y;
            if (neighborX == worldWidth){ neighborX = 0;}
            if (neighborX == -1){ neighborX = worldWidth-1;}
            if (neighborY == worldHeight){ neighborY = 0;}
            if (neighborY == -1){ neighborY = worldHeight-1;}
            if (cells[neighborX][neighborY].cellBelief == true){
              cells[neighborX][neighborY].conviction = constrain(cells[neighborX][neighborY].conviction - beliefChange, -0.999, 0.999);
            }
            else{
              cells[neighborX][neighborY].conviction = constrain(cells[neighborX][neighborY].conviction + beliefChange, -0.999, 0.999);
            }
        }
      }
   }
   
     void influenceNeighbors(int thisX, int thisY){
        for (int x = -1; x <= 1; x++){
        for (int y = -1; y <= 1; y++){
            int neighborX;
            int neighborY;
            neighborX = thisX + x;
            neighborY = thisY + y;
            if (neighborX == worldWidth){ neighborX = 0;}
            if (neighborX == -1){ neighborX = worldWidth-1;}
            if (neighborY == worldHeight){ neighborY = 0;}
            if (neighborY == -1){ neighborY = worldHeight-1;}
            if (!(x == 0 && y == 0)){
              if (cells[thisX][thisY].cellBelief == false){
                cells[neighborX][neighborY].conviction = constrain(cells[neighborX][neighborY].conviction - beliefChange, -0.999, 0.999);
              }
              else{
                cells[neighborX][neighborY].conviction = constrain(cells[neighborX][neighborY].conviction + beliefChange, -0.999, 0.999);
              }
            }
            //else{

            //}
        }
      }
   }
   
   
   
}
