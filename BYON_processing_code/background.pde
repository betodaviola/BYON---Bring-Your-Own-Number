float[] bkgData = new float[2];
float bkgHue, bkgSat, bkgBri, bkgTra;
float primeId, bOrW, willBlur, blurLvl; //blurOrNot will be from 0-9
color bkgC, eclipseC;

void bkgC() {
  if (primeId == 1) { // colorful background
    randomSeed(bkgHueSeed);
    bkgHue = random(360);
    bkgC = color(bkgHue,bkgSat,bkgBri,bkgTra);
    moonC = color(bkgHue,bkgSat,bkgBri,100);
    // handles bkgTexture newC
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
  } else if (bOrW == 0) {
    bkgC = color(20,0,100,bkgTra); // white background
    moonC = color(20,0,100,100);
  } else {
    bkgC = color(20,100,0,bkgTra);// black background
    moonC = color(20,100,0,100);
  }
}
void bkgSetup() {
  bkgC = color(20,100,0,100);
  moonC = color(20,100,0,100);
}
void bkgDraw() {
  noStroke();
  fill(bkgC);
  rect(0,0,width,height);
}
