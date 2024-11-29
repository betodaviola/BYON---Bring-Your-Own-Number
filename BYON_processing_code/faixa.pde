float [] faixaData = new float[7];
float [] faixaOnOff = new float[4];
// rotation in degrees
float faixaR;
// speed of each type/position (1-10)
float spdTSm;
float spdTLa;
float spdBSm;
float spdBLa;
// lean each stripe on top or bottom (-100-100)
int leanT;
int leanB;
// how many strips on top/bottom, and which kind (1-4, 0 accepted)
int faixaTSm;
int faixaTLa;
int faixaBSm;
int faixaBLa;

float faixa1FillHue, faixa1FillSat, faixa1FillBri;
float faixa2FillHue, faixa2FillSat, faixa2FillBri;

Faixa[] faixaTSmArr; // Top small
Faixa[] faixaTLaArr; // Top large
Faixa[] faixaBSmArr; // Bottom small
Faixa[] faixaBLaArr; // Bottom large

void faixaSetup() {
  faixaTSm = (int)faixaOnOff[0];
  faixaTLa = (int)faixaOnOff[1];
  faixaBSm = (int)faixaOnOff[2];
  faixaBLa = (int)faixaOnOff[3];
  
  faixaTSmArr = new Faixa[faixaTSm];
  faixaTLaArr = new Faixa[faixaTLa];
  faixaBSmArr = new Faixa[faixaBSm];
  faixaBLaArr = new Faixa[faixaBLa];

  // Initialize top small Faixa
  for (int i = 0; i < faixaTSm; i++) {
    int xPos = i * width / faixaTSm;
    faixaTSmArr[i] = new Faixa(1, "sm", "t", "r", xPos, 0);
  }

  // Initialize top large Faixa
  for (int i = 0; i < faixaTLa; i++) {
    int xPos = i * width / faixaTLa;
    faixaTLaArr[i] = new Faixa(1, "la", "t", "r", xPos, 0);
  }

  // Initialize bottom small Faixa
  for (int i = 0; i < faixaBSm; i++) {
    int xPos = i * width / faixaBSm;
    faixaBSmArr[i] = new Faixa(1, "sm", "b", "l", xPos, height / 2);
  }

  // Initialize bottom large Faixa
  for (int i = 0; i < faixaBLa; i++) {
    int xPos = i * width / faixaBLa;
    faixaBLaArr[i] = new Faixa(1, "la", "b", "l", xPos, height / 2);
  }
}

void faixaDraw() {
  faixaR = faixaData[0];
  spdTSm = faixaData[1];
  spdTLa = faixaData[2];
  spdBSm = faixaData[3];
  spdBLa = faixaData[4];
  leanT = (int)faixaData[5];
  leanB = (int)faixaData[6];
  faixaTSm = (int)faixaOnOff[0];
  faixaTLa = (int)faixaOnOff[1];
  faixaBSm = (int)faixaOnOff[2];
  faixaBLa = (int)faixaOnOff[3];
  
  // Reinitialize the Faixa arrays if the count changes
  if (faixaTSmArr.length != faixaTSm || faixaTLaArr.length != faixaTLa || faixaBSmArr.length != faixaBSm || faixaBLaArr.length != faixaBLa) {
    faixaSetup();
  }
  
  // Update and display all Faixa arrays
  updateAndDisplayFaixas(faixaBLaArr, spdBLa, leanB);
  updateAndDisplayFaixas(faixaTLaArr, spdTLa, leanT);
  updateAndDisplayFaixas(faixaTSmArr, spdTSm, leanT);
  updateAndDisplayFaixas(faixaBSmArr, spdBSm, leanB);
}

void updateAndDisplayFaixas(Faixa[] faixas, float speed, int lean) {
  for (Faixa faixa : faixas) {
    faixa.spd = speed;
    faixa.lean = lean;
    faixa.faixaAng = radians(faixaR);
    faixa.updateFaixa();
    faixa.display();
  }
}

class Faixa {
  float spd, faixaAng;
  int x1, x2, x3, x4, y1, y2, y3, y4, lean, on, c, faixaTrans;
  boolean active;
  String type, pos, dir; // type small and large (sm or la), position top or bottom (t or b), direction left or right (l or r)
  
  Faixa(int tempOn, String tempType, String tempPos, String tempDir, int startX, int startY) {
    dir = tempDir;
    pos = tempPos;
    on = tempOn;
    type = tempType;
    lean = 0;
    y1 = startY;
    y2 = startY;
    y3 = startY + height / 2;
    y4 = startY + height / 2;
    faixaTrans = 39;
    
    faixaMovement();

    if (type.equals("la")) {
      c = color(faixa1FillHue, faixa1FillSat, faixa1FillBri, faixaTrans);
    } else {
      c = color(faixa2FillHue, faixa2FillSat, faixa2FillBri, faixaTrans);
    }

    active = on > 0;
    x1 = startX;

    updateFaixa();
  }
  
  void faixaMovement() {
    if (pos.equals("t") && type.equals("sm")) {
      spd = spdTSm;
    } else if (pos.equals("t") && type.equals("la")) {
      spd = spdTLa;
    } else if (pos.equals("b") && type.equals("sm")) {
      spd = spdBSm;
    } else if (pos.equals("b") && type.equals("la")) {
      spd = spdBLa;
    }
    
    faixaAng = radians(faixaR);
  }

  void updateFaixa() {
    if (!active) {
      return;
    }
    
    faixaMovement();

    x2 = x1 + (type.equals("sm") ? 12 : 60);

    if (dir.equals("r")) {
      x1 += spd;
    } else {
      x1 -= spd;
    }

    if (pos.equals("t")) {
      lean = leanT;
      x3 = x2 + lean;
      x4 = x1 + lean;
    } else {
      lean = leanB;
      x3 = x2 + lean;
      x4 = x1 + lean;
    }

    // Adjust x1 when x1 or x2 goes off-screen
    if (x1 > width) {
      x1 = x1 - width;
    } else if (x2 < 0) {
      x1 = x1 + width;
    }

    // Update x2, x3, and x4 based on new x1
    x2 = x1 + (type.equals("sm") ? 12 : 60);
    x3 = x2 + lean;
    x4 = x1 + lean;
  }

  void display() {
    push();
    translate(width / 2, height / 2);
    rotate(faixaAng);
    translate(-width / 2, -height / 2);
    noStroke();
    fill(c,faixaTrans);
    quad(x1, y1, x2, y2, x3, y3, x4, y4);
    pop();

    // Draw a copy of Faixa offscreen on the opposite side for smooth wrapping
    if (x1 > width - 100) {
      push();
      translate(width / 2, height / 2);
      rotate(faixaAng);
      translate(-width / 2, -height / 2);
      noStroke();
      fill(c,faixaTrans);
      quad(x1 - width, y1, x2 - width, y2, x3 - width, y3, x4 - width, y4);
      pop();
    } else if (x2 < 100) {
      push();
      translate(width / 2, height / 2);
      rotate(faixaAng);
      translate(-width / 2, -height / 2);
      noStroke();
      fill(c,faixaTrans);
      quad(x1 + width, y1, x2 + width, y2, x3 + width, y3, x4 + width, y4);
      pop();
    }
    if (faixaAng > 0 || faixaAng < 0) {
      if (pos.equals("t")) {
        push();
        translate(width / 2, height / 2);
        rotate(faixaAng);
        translate(-width / 2, -height / 2);
        noStroke();
        fill(c,faixaTrans);
        quad(x1, y1 + height, x2, y2 + height, x3, y3 + height, x4, y4 + height);
        pop();
      } else {
        push();
        translate(width / 2, height / 2);
        rotate(faixaAng);
        translate(-width / 2, -height / 2);
        noStroke();
        fill(c,faixaTrans);
        quad(x1, y1 - height, x2, y2 - height, x3, y3 - height, x4, y4 - height);
        pop();
      }
    }
  }
}
