float[] eclipse = new float[4];
color moonC, sunC;

float angle;
Eclipse myEclipse;

void eclipseDraw() {
  myEclipse.update();
  myEclipse.display();
}

class Eclipse {
  float ecX, ecY, ecR, sunSizeX, sunSizeY, moonSizeX, moonSizeY, angle, eclipseC, baseSize;
  
  Eclipse() {
    baseSize = width/9;
  }

  void update() {
    ecX = eclipse[0];
    ecY = eclipse[1];
    eclipseC = eclipse[2];
    ecR = eclipse[3];
    
    angle = radians(ecR);
    
    if (primeId == 1) { // prime, colored background (sun can be black or white)
      if (bOrW == 0) {
        sunC = color(20,100,0,100); // black sun
        sunSizeX = baseSize - 7;
        sunSizeY = baseSize + 7;
        moonSizeX = baseSize;
        moonSizeY = baseSize;
      } else {
        sunC = color(20,0,100,100); // white sun
        sunSizeX = baseSize;
        sunSizeY = baseSize;
        moonSizeX = baseSize - 7;
        moonSizeY = baseSize + 7;
      }
    } else { // not prime, bkg can be black OR white
      if (bOrW == 0) { // if bkg is white (black or colored sun)
        if (eclipseC == 0) {
          sunC = color(bkgHue,bkgSat,bkgBri,100); // colored sun
          sunSizeX = baseSize -7;
          sunSizeY = baseSize +7;
          moonSizeX = baseSize;
          moonSizeY = baseSize;
        } else {
          sunC = color(20,100,0,100); // black sun
          sunSizeX = baseSize - 7;
          sunSizeY = baseSize + 7;
          moonSizeX = baseSize;
          moonSizeY = baseSize;
        }
      } else { // if background is black (white or colored sun)
        if (eclipseC == 0) {
          sunC = color(bkgHue,bkgSat,bkgBri,100); // colored sun
          sunSizeX = baseSize -7;
          sunSizeY = baseSize +7;
          moonSizeX = baseSize;
          moonSizeY = baseSize;
        } else {
          sunC = color(20,0,100,100); // white sun
          sunSizeX = baseSize;
          sunSizeY = baseSize;
          moonSizeX = baseSize - 7;
          moonSizeY = baseSize + 7;
        }
      }
    }
  }

  void display() {
    push();
    stroke(sunC);
    fill(sunC);
    ellipse(width/2, height/2, sunSizeX, sunSizeY); // Static white ellipse
    pushMatrix();
    translate(width/2, height/2);
    rotate(angle);
    stroke(moonC);
    fill(moonC);
    ellipse(ecX, ecY, moonSizeX, moonSizeY); // Rotating black ellipse
    popMatrix();
    pop();
  }
}
