PVector[] points;                 //Array of points
int numSides = 6;                 //Number of sides of the polygon
float fraction = 0.5;             //The length fraction used to find the next point based on the current one
boolean chaos = true;             //To prevent the points from being redrawn every frame
boolean twoSteps = false;         //If true, points from the polygon can be picked multiple times in a row
boolean arePointsHalfway = false; //If true, add points to the midpoints of edges of the polygon

PVector current;
PVector previous;

HScrollbar hs1;
HScrollbar hs2;
Button b1;
Checkbox c1;
Checkbox c2;
Checkbox c3;

int arraySize = 250;

//For the estimated dimension of the fractal shape
int[][] countGrid = new int[arraySize][arraySize];
int[][] countDoubledGrid = new int[arraySize*2][arraySize*2];
int sumGrid = 0;
int sumDoubledGrid = 0;
float dimensionEstimate = 2;

void setup() {
  size(1500, 900);
  
  //Start the first point at a random location in the window
  current = new PVector(random(width), random(height));
  
  hs1 = new HScrollbar(1000, 330, 400, 20, 3); //Scrollbar to choose the length fraction
  hs2 = new HScrollbar(1000, 190, 400, 20, 3); //Scrollbar to choose the number of sides of the polygon
  hs2.setNormalPos(0.4f);
  b1 = new Button(1100, 730, 200, 75);  //Button to update the points
  c1 = new Checkbox(1000, 430, 40, 40); //Checkbox to use carpet fraction
  c1.pressed = true;
  c2 = new Checkbox(1000, 510, 40, 40); //Checkbox to allow a point to be picked multiple times in a row
  c3 = new Checkbox(1000, 590, 40, 40); //Checkbox to add points to the midpoints of the edges of the polygon
  
  for (int i = 0; i < arraySize; i++) {
    for (int j = 0; j < arraySize; j++) {
      countGrid[i][j] = 0;
    }
  }
  for (int i = 0; i < arraySize/2; i++) {
    for (int j = 0; j < arraySize/2; j++) {
      countDoubledGrid[i][j] = 0;
    }
  }
}

//Function to draw a polygon
void polygon(float x, float y, float radius, int npoints, boolean halfway) {
  if (halfway) {
    points = new PVector[numSides * 2];
  }
  else {
    points = new PVector[numSides];
  }
  
  fill(255, 255, 255);
  beginShape();
  for (int i = 0; i < npoints; i++) {
    float angle = i * TWO_PI / npoints;
    PVector v = PVector.fromAngle(angle);
    v.mult(radius);
    v.add(x, y);
    
    if (halfway) {
      points[i * 2] = v;
      points[i * 2 + 1] = new PVector((v.x + (x + cos(angle + TWO_PI / npoints) * radius))/2f, 
                                      (v.y + (y + sin(angle + TWO_PI / npoints) * radius))/2f);
    }
    else {
      points[i] = v;
    }
    
    vertex(v.x, v.y);
  }
  endShape(CLOSE);
}

void calculateCarpetFraction(int sides) {
  float sum = 0;
  for (float i = 1; i <= floor(float(sides) / 4f); i++) {
    sum += cos((2*PI*i)/float(sides));
  }
  fraction = 1 / (2 * (1 + sum));
}

//hs: HScrollbar, s: text above, lowVal: low value of scrollbar, highVal: high value of scrollbar, per: percentage text below, isPerInt: is per an int?
void TextHScrollbar(HScrollbar hs, String s, int lowVal, int highVal, float per, boolean isPerInt) {
  hs.update();
  hs.display();
  fill(0, 0, 0);
  textSize(30);
  text(s, hs.xpos, hs.ypos - 50);
  textSize(20);
  text(lowVal, hs.xpos, hs.ypos - 15);
  text(highVal, hs.xpos + hs.swidth - 15, hs.ypos - 15);
  if (isPerInt) {
    text((int) per, hs.xpos, hs.ypos + 50);
  }
  else {
    text(per, hs.xpos, hs.ypos + 50);
  }
}

void TextButton(Button b, String s) {
  b.update();
  b.display();
  fill(255, 255, 255);
  textSize(30);
  text(s, b.rectX + 45, b.rectY + 47);
}

void TextCheckbox(Checkbox c, String one, String two, boolean isNumTextOne) {
  c.update();
  c.display();
  fill(0, 0, 0);
  textSize(20);
  if (isNumTextOne) {
    text(one, c.rectX + c.rectXSize + 20, c.rectY + 30);
  }
  else {
    text(one, c.rectX + c.rectXSize + 20, c.rectY + 15);
    text(two, c.rectX + c.rectXSize + 20, c.rectY + 45);
  }
}

void draw() {
  //Dealing with the user input
  noStroke();
  fill(200, 200, 200);
  rect(950, 0, 1500, 900);
  
  TextHScrollbar(hs1, "Length Fraction", 0, 1, hs1.normalPos, false);
  TextHScrollbar(hs2, "Number of Sides", 3, 10, (int) (3.5 + hs2.normalPos * 7), true);
  
  TextButton(b1, "Update");
  
  fill(0, 0, 0);
  text("Other Options", 1000, 410);
  
  TextCheckbox(c1, "Use Sierpinski Carpet Fraction", "", true);
  TextCheckbox(c2, "Allow the same point of the polygon to", 
                   "be picked multiple times in a row", false);
  TextCheckbox(c3, "Add points to the midpoints of the edges", 
                   "of the polygon", false);
  
  fill(0, 0, 0);
  textSize(30);
  text("Estimated Dimension:", 1000, 690);
  text(str(dimensionEstimate), 1320, 690);
  
  strokeWeight(2);
  stroke(10);
  
  //Drawing the polygon and points
  if (chaos) {
    chaos = false;
    
    background(200, 200, 200);
    
    numSides = (int) (3.5 + hs2.normalPos * 7);
    polygon(500, height/2, 400, numSides, arePointsHalfway);
    
    for (int i = 0; i < points.length; i++) {
      stroke(255, 0, 0);
      fill(255, 0, 0);
      circle(points[i].x, points[i].y, 8);
    }
    
    //Calculate carpet fraction
    if (arePointsHalfway) {
      calculateCarpetFraction(numSides * 2);
      if (numSides == 4) {
        //Makes Menger sponge
        //fraction = 1f / 3f;
      }
    }
    else {
      calculateCarpetFraction(numSides);
    }
    
    stroke(0, 0, 0);
    float lerpPercent = hs1.normalPos;
    if (c1.pressed) {
      lerpPercent = 1 - fraction;
      hs1.setNormalPos(lerpPercent);
    }
    for (int i = 0; i < 100000; i++) {
      PVector next = points[floor(random(points.length))];
      if (twoSteps || next != previous) {
        current.x = lerp(current.x, next.x, lerpPercent);
        current.y = lerp(current.y, next.y, lerpPercent);
        point(current.x, current.y);
        
        int arrayX = (int)(current.x * (float)arraySize / (float)1000);
        int arrayY = (int)(current.y * (float)arraySize / (float)1000);
        if (arrayX < arraySize && arrayY < arraySize) {
          countGrid[arrayX][arrayY] = 1;
        }
        
        int arrayX2 = (int)(current.x * 2 * (float)arraySize / (float)1000);
        int arrayY2 = (int)(current.y * 2 * (float)arraySize / (float)1000);
        if (arrayX2 < arraySize * 2 && arrayY2 < arraySize * 2) {
          countDoubledGrid[arrayX2][arrayY2] = 1;
        }
      }
      previous = next;
    }
    
    sumGrid = 0;
    sumDoubledGrid = 0;
    for (int i = 0; i < arraySize; i++) {
      for (int j = 0; j < arraySize; j++) {
        sumGrid += countGrid[i][j];
        countGrid[i][j] = 0;
      }
    }
    for (int i = 0; i < arraySize * 2; i++) {
      for (int j = 0; j < arraySize * 2; j++) {
        sumDoubledGrid += countDoubledGrid[i][j];
        countDoubledGrid[i][j] = 0;
      }
    }
    dimensionEstimate = log((float)sumDoubledGrid / (float)sumGrid) / log(2);
  }
}

void mouseReleased() {
  c1.tryClick();
  c2.tryClick();
  c3.tryClick();
  
  twoSteps = c2.pressed;
  arePointsHalfway = c3.pressed;
  
  b1.tryClick();
  if (b1.pressed) {
    chaos = true;
  }
}
