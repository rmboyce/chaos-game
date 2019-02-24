ArrayList<PVector> points = new ArrayList<PVector>();
int rand;
int prev;
int numSides = 3;
float len = 0.5;
boolean chaos = true;
boolean twoSteps = false;
boolean arePointsHalfway = false;

void setup() {
  size(1000, 1000);
  strokeWeight(2);
  stroke(10);
}

void polygon(float x, float y, float radius, int npoints, boolean halfway) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius + width*0.5;
    float sy = y + sin(a) * radius + height*0.5;
    points.add(new PVector(sx, sy));
    if (halfway) {
      //points.add(new PVector(x + cos(a) * radius / 2f + width*0.5, y + sin(a) * radius / 2f + width*0.5));
      points.add(new PVector((sx + (x + cos(a - angle) * radius + width*0.5))/2f, (sy + (y + sin(a - angle) * radius + height*0.5))/2f));
    }
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void drawPoints(int numberOfTimes, float dist, boolean canTwoInARow) {
  PVector thisPoint = new PVector(width*0.5, height*0.5);
  rand = (int) random(0, points.size());
  while (numberOfTimes > 0) {
    prev = rand;
    rand = (int) random(0, points.size());
    while (!canTwoInARow && rand == prev) {
      rand = (int) random(0, points.size());
    }
    
    thisPoint.lerp(points.get(rand), 1 - dist);
    numberOfTimes--;
    draw();
    point(thisPoint.x, thisPoint.y);
  } 
}

void draw() { 
  if (chaos) {
    chaos = false;
    points.clear();
    background(200, 200, 200);
    polygon(0, 0, 400, numSides, arePointsHalfway);
    drawPoints(300000, len, twoSteps);
    points.clear();
    //print(twoSteps);
  }
}

void keyPressed() {
  chaos = true;
  if (51 <= key && key <= 57) {
    numSides = key - 48;
  }
  else if (key == 49) {
    twoSteps = !twoSteps;
  }
  else if (key == 50) {
    arePointsHalfway = !arePointsHalfway;
  }
  else if (key == 48) {
    numSides = 25;
  }
  
  if (arePointsHalfway) {
    calculateLen(numSides * 2);
    if (numSides == 4) {
      len = 1f / 3f;
    }
  }
  else {
    calculateLen(numSides);
  }
}

void calculateLen(int sides) {
  float sum = 0;
  for (float i = 1; i <= floor(float(sides) / 4f); i++) {
    sum += cos((2*PI*i)/float(sides));
  }
  len = 1 / (2 * (1 + sum));
}
