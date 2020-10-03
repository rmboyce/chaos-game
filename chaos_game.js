var points;                 //Array of points
var numSides = 6;                 //Number of sides of the polygon
var fraction = 0.5;             //The length fraction used to find the next point based on the current one
var chaos = true;             //To prevent the points from being redrawn every frame
var twoSteps = false;         //If true, points from the polygon can be picked multiple times in a row
var arePointsHalfway = false; //If true, add points to the midpoints of edges of the polygon

var current;
var previous;

var hs1;
var hs2;
var b1;
var c1;
var c2;
var c3;

var arraySize = 250;

//For the estimated dimension of the fractal shape
var countGrid = new Array(arraySize);
for (let i = 0; i < countGrid.length; i++) { 
  countGrid[i] = new Array(arraySize);
} 
var countDoubledGrid = new Array(arraySize*2);
for (let i = 0; i < countDoubledGrid.length; i++) { 
  countDoubledGrid[i] = new Array(arraySize*2);
} 
var sumGrid = 0;
var sumDoubledGrid = 0;
var dimensionEstimate = 2;

function setup() {
  createCanvas(750, 450);
  
  //Start the first point at a random location in the window
  current = createVector(random(width), random(height));
  
  hs1 = new HScrollbar(500, 165, 200, 10, 3); //Scrollbar to choose the length fraction
  hs2 = new HScrollbar(500, 95, 200, 10, 3); //Scrollbar to choose the number of sides of the polygon
  hs2.setNormalPos(0.4);
  b1 = new Button(550, 365, 100, 37.5);  //Button to update the points
  c1 = new Checkbox(500, 215, 20, 20); //Checkbox to use carpet fraction
  c1.pressed = true;
  c2 = new Checkbox(500, 255, 20, 20); //Checkbox to allow a point to be picked multiple times in a row
  c3 = new Checkbox(500, 295, 20, 20); //Checkbox to add points to the midpoints of the edges of the polygon
  
  for (let i = 0; i < arraySize; i++) {
    for (let j = 0; j < arraySize; j++) {
      countGrid[i][j] = 0;
    }
  }
  for (let i = 0; i < arraySize/2; i++) {
    for (let j = 0; j < arraySize/2; j++) {
      countDoubledGrid[i][j] = 0;
    }
  }
}

//Function to draw a polygon
function polygon(x, y, radius, npoints, halfway) {
  if (halfway) {
    points = new Array(numSides * 2);
  }
  else {
    points = new Array(numSides);
  }
  
  fill(255, 255, 255);
  beginShape();
  for (let i = 0; i < npoints; i++) {
    let angle = i * TWO_PI / npoints;
    let v = p5.Vector.fromAngle(angle);
    v.mult(radius);
    v.add(x, y);
    
    if (halfway) {
      points[i * 2] = v;
      points[i * 2 + 1] = createVector((v.x + (x + cos(angle + TWO_PI / npoints) * radius))/2, 
                                       (v.y + (y + sin(angle + TWO_PI / npoints) * radius))/2);
    }
    else {
      points[i] = v;
    }
    
    vertex(v.x, v.y);
  }
  endShape(CLOSE);
}

function calculateCarpetFraction(sides) {
  let sum = 0;
  for (let i = 1; i <= floor(float(sides) / 4); i++) {
    sum += cos((2*PI*i)/float(sides));
  }
  fraction = 1 / (2 * (1 + sum));
}

function draw() {
  //Dealing with the user input
  noStroke();
  fill(200, 200, 200);
  rect(475, 0, 750, 450);
  
  hs1.update();
  hs1.display();
  fill(0, 0, 0);
  textSize(20);
  text("Length Fraction", 500, 135);
  textSize(15);
  text("0", 500, 87.5+65);
  text("1", 692.5, 87.5+65);
  text(round(hs1.normalPos, 3), 500, 120+65);
  
  hs2.update();
  hs2.display();
  fill(0, 0, 0);
  textSize(20);
  text("Number of Sides", 500, 65);
  textSize(15);
  text("3", 500, 82.5);
  text("10", 692.5, 82.5);
  text((int) (3.5 + hs2.normalPos * 7), 500, 115);
  
  b1.update();
  b1.display();
  fill(255, 255, 255);
  textSize(20);
  text("Update", 565, 388.5);
  
  fill(0, 0, 0);
  text("Other Options", 500, 205);
  c1.update();
  c1.display();
  fill(0, 0, 0);
  textSize(15);
  text("Use Sierpinski Carpet Fraction", 530, 230);
  
  c2.update();
  c2.display();
  fill(0, 0, 0);
  text("Allow the same point to be", 530, 262.5);
  text("picked multiple times in a row", 530, 277.5);
  
  c3.update();
  c3.display();
  fill(0, 0, 0);
  text("Add points to the midpoints", 530, 302.5);
	text("of the edges", 530, 317.5);
  text("of the polygon", 1060, 635);
  
  fill(0, 0, 0);
  textSize(20);
  text("Est. Dimension:", 500, 345);
  text(str(round(dimensionEstimate, 3)), 645, 345);
  
  strokeWeight(2);
  stroke(10);
  
  //Drawing the polygon and points
  if (chaos) {
    chaos = false;
    
    background(200, 200, 200);
    
    numSides = (int) (3.5 + hs2.normalPos * 7);
    polygon(250, height/2, 200, numSides, arePointsHalfway);
    
    for (let i = 0; i < points.length; i++) {
      stroke(255, 0, 0);
      fill(255, 0, 0);
      point(points[i].x, points[i].y, 8);
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
    let lerpPercent = hs1.normalPos;
    if (c1.pressed) {
      lerpPercent = 1 - fraction;
      hs1.setNormalPos(lerpPercent);
    }
    for (let i = 0; i < 30000; i++) {
      let next = points[floor(random(points.length))];
      if (twoSteps || next != previous) {
        current.x = lerp(current.x, next.x, lerpPercent);
        current.y = lerp(current.y, next.y, lerpPercent);
        point(current.x, current.y);
        
        let arrayX = (int)(current.x * arraySize / 1000);
        let arrayY = (int)(current.y * arraySize / 1000);
        if (arrayX < arraySize && arrayY < arraySize) {
          countGrid[arrayX][arrayY] = 1;
        }
        
        let arrayX2 = (int)(current.x * 2 * arraySize / 1000);
        let arrayY2 = (int)(current.y * 2 * arraySize / 1000);
        if (arrayX2 < arraySize * 2 && arrayY2 < arraySize * 2) {
          countDoubledGrid[arrayX2][arrayY2] = 1;
        }
      }
      previous = next;
    }
    
    sumGrid = 0;
    sumDoubledGrid = 0;
    for (let i = 0; i < arraySize; i++) {
      for (let j = 0; j < arraySize; j++) {
        sumGrid += countGrid[i][j];
        countGrid[i][j] = 0;
      }
    }
    for (let i = 0; i < arraySize * 2; i++) {
      for (let j = 0; j < arraySize * 2; j++) {
        sumDoubledGrid += countDoubledGrid[i][j];
        countDoubledGrid[i][j] = 0;
      }
    }
    dimensionEstimate = log(sumDoubledGrid / sumGrid) / log(2);
  }
}

function mouseReleased() {
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
