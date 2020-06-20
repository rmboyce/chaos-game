# Chaos Game

Demo: https://www.openprocessing.org/sketch/920180

This program starts with a polygon and a point in a random location inside it. Then, the program chooses a random vertex from the polygon and makes a copy of the point some fraction - the Serpinski Carpet Fraction - of the way between the old point and the vertex. The process is repeated, but using the new point, not the old one. Eventually, the points will make a pattern.  

The Serpinski Carpet Fraction is the size a smaller polygon that can be put inside the original polygon touching each of its vertices without overlapping the other smaller polygons, when compared to the original polygon. The Serpinski Fraction causes the points to make nice patterns, and is calculated in the method CalculateCarpetFraction() if you want to look more into it.  

Articles: https://en.wikipedia.org/wiki/Sierpinski_carpet, http://shiftingmind.com/chaosgame/  

