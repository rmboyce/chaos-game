ArrayList<PVector> points = new ArrayList<PVector>();
int rand;
int prev;
int numSides = 3;
boolean chaos = true;
boolean twoSteps = false;

void setup() {
  size(1000, 1000);
  strokeWeight(2);
  stroke(10);
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a + angle/(npoints/2)) * radius + width*0.5;
    float sy = y + sin(a + angle/(npoints/2)) * radius + height*0.5;
    points.add(new PVector(sx, sy));
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
    
    thisPoint.lerp(points.get(rand), dist);
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
    polygon(0, 0, 400, numSides);
    drawPoints(100000, 0.5, twoSteps);
    //points.clear();
    //print(twoSteps);
  }
}

void keyPressed() {
  chaos = true;
  if (51 <= key && key <= 57) {
    numSides = key - 48;
  }
  else if (key == 48) {
    twoSteps = !twoSteps;
  }
}
