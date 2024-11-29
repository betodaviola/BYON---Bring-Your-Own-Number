float [] starData1 = new float[5]; //distortion, radius, npoints,midCircle
float [] starData2 = new float[5]; //distortion, radius, npoints,midCircle

float star1StkHue, star1StkSat, star1StkBri;
float star2StkHue, star2StkSat, star2StkBri;

void starDraw() {
  push();
  noFill();
  strokeWeight(starData1[4]);
  stroke(star1StkHue, star1StkSat, star1StkBri, 100);
  star1(); 
  pop();
  push();
  noFill();
  strokeWeight(starData2[4]);
  stroke(star2StkHue, star2StkSat, star2StkBri, 100);
  star2(); 
  pop();
}

void star1() {
  float x = width/2;
  float y = height/2;
  float distortion = starData1[0];
  float radius1 = width/18 + starData1[1];
  int npoints = (int)starData1[2];
  float radius2 = radius1*2;
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a+distortion) * radius2;
    float sy = y + sin(a+distortion) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
  if (starData1[3] == 1) {
    stroke(star1StkHue, star1StkSat, star1StkBri, 100);
    ellipse(x,y,2*radius1,2*radius1);
  }
}
void star2() {
  float x = width/2;
  float y = height/2;
  float distortion = starData2[0];
  float radius1 = width/18 + starData2[1];
  int npoints = (int)starData2[2];
  float radius2 = radius1*2;
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a+distortion) * radius2;
    float sy = y + sin(a+distortion) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
  if (starData2[3] == 1) {
    stroke(star2StkHue, star2StkSat, star2StkBri, 100);
    ellipse(x,y,2*radius1,2*radius1);
  }
}
