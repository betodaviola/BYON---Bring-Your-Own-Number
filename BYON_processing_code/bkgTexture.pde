int maxEllipses = 9;
EllipseObject[] ellipses = new EllipseObject[maxEllipses];

float[] oscX = new float[maxEllipses];
float[] oscY = new float[maxEllipses];
float[] oscSize = new float[maxEllipses];
boolean[] oscActive = new boolean[maxEllipses];
color newC;

// Variables for color profile logic
float hue, sat, bri, alp, newSat, newBri, elliColorChange;
int colorProfile = 2; // Can be changed to 0, 1, or 2 based on profile

void bkgTexSetup() {
  elliColorChange = 50;
  bkgTexUpdate();
  for (int i = 0; i < maxEllipses; i++) {
    ellipses[i] = new EllipseObject();
  }
}
void bkgTexDraw() {
  for (EllipseObject ellipse : ellipses) {
    if (ellipse.active) {
      ellipse.display();
    }
  }
}

void bkgTexUpdate() {
  if (primeId == 1) { // colorful background
    if (bkgSat >= 50) {
      newSat = bkgSat - elliColorChange;
    } else {
      newSat = bkgSat + elliColorChange;
    }
    if (bkgBri >= 50) {
      newBri = bkgBri - elliColorChange;
    } else {
      newBri = bkgBri + elliColorChange;
    }
    newC = color(hue, newSat, newBri, 100);
  } else if (bOrW == 0) { // white background
    newC = color(hue, 100, 0, elliColorChange);
  } else { // black background
    newC = color(hue, 0, 100, elliColorChange);
  }
}

// Class to manage ellipses
class EllipseObject {
  float x, y, size;
  boolean active;
  
  EllipseObject() {
    this.active = false; // Start inactive
  }
  
  void activate(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.active = true; // Activate when needed
  }
  
  void display() {
    drawGradientEllipse(this.x, this.y, this.size, bkgC, newC);
  }
}

// Draw the gradient ellipse
void drawGradientEllipse(float x, float y, float maxRadius, color baseC, color newC) {
  int steps = 50; // Number of gradient steps
  noStroke(); // No outline
  for (int i = steps; i >= 0; i--) {
    float t = i / (float) steps;
    color c = lerpColor(newC, baseC, t); // Interpolating the color
    float radius = lerp(0, maxRadius, t); // Interpolating the radius
    fill(c);
    ellipse(x, y, radius, radius); // Drawing the ellipse
  }
}
