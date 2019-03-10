# Chaos Game
This program starts with a polygon and a point in a random location inside it. Then, the program chooses a random vertex from the polygon and makes a copy of the point some fraction of the way between the old point and the vertex. The process is repeated, but using the new point, not the old one. Eventually, the points will make a pattern.  
The fraction depends on what the Serpinski Carpet Fraction is for the polygon.
Controls: Press 3 - 9 to control the number of sides the polygon has, 1 to toggle whether the same vertex can be picked twice in a row (default is no), and 2 to toggle whether or not there are points on the midpoints of the polygon (default is no).
