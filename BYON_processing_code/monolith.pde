PGraphics canvas3D;

float[] camData = new float[4];
int monoN = 0; // Initialize this to 0 for a static camera at the start
float monoAngle;

float monoStkHue, monoStkSat, monoStkBri;
float monoFillHue, monoFillSat, monoFillBri;

Monolith[] monoliths;
Cam myCam;

void monolithSetup() {
  if (canvas3D == null) {
        canvas3D = createGraphics(width, height, P3D);
        canvas3D.colorMode(HSB, 360, 100, 100, 100);
  }
  
  if (monoN > 0) {
    monoAngle = PI / max(monoN, 1); // Half circle divided by number of monoliths
    monoliths = new Monolith[monoN];
    for (int i = 0; i < monoliths.length; i++) {
      monoliths[i] = new Monolith(i);
    }
  } else {
    monoliths = new Monolith[1]; // Create one monolith for static camera initialization
    monoliths[0] = new Monolith(0);
  }
  
}

void monolithDraw() {
  canvas3D.beginDraw();
  canvas3D.clear();
  canvas3D.lights();
  if (monoN > 0) {
    for (int i = 0; i < monoliths.length; i++) {
      monoliths[i].display();
    }
  }
  canvas3D.endDraw();
  image(canvas3D,0,0); // Render canvas3D to the main canvas
}

void camSetup() {
  myCam = new Cam();
  myCam.init();
}
void camDraw() {
  canvas3D.beginDraw();
  myCam.display();
  canvas3D.endDraw();
  image(canvas3D,0,0); // Render canvas3D to the main canvas
}

class Cam {
  float eyeX, eyeY, eyeZ, sceneX, sceneY, sceneZ, upX, upY, upZ;
  int seedPD;
  
  Cam() {
    sceneX = width / 2;
    sceneY = height / 2;
    sceneZ = 0;
    upX = 0;
    upY = 1;
    upZ = 0;
    if (camData != null && camData.length > 3) {
      seedPD = (int) camData[3];
    } else {
      // Set default value or log an error
      seedPD = 0;
    }

  }
  void init() {
    eyeX = width / 2 + camData[0];
    eyeY = height / 2 + camData[1];
    eyeZ = (height / 2.0) / tan(PI * 30.0 / 180.0) + camData[2];
  }
  void update() {
    randomSeed(seedPD + 100);
    eyeX += random(-1, 1);
    randomSeed(seedPD + 5000);
    eyeY += random(-1, 1);
    randomSeed(seedPD + 1000);
    eyeZ += random(-1, 1);
  }
  void display() {
    if (monoN == 0) {
      init();
//      canvas3D.beginDraw();
      canvas3D.camera(eyeX, eyeY, eyeZ, sceneX, sceneY, sceneZ, upX, upY, upZ);
//      canvas3D.endDraw();
    } else {
//      canvas3D.beginDraw();
      canvas3D.camera(eyeX, eyeY, eyeZ, sceneX, sceneY, sceneZ, upX, upY, upZ);
//      canvas3D.endDraw();
      update();
    }
  }  
}

class Monolith {
  float centerX, centerY, centerZ, monoX, monoY, monoZ, monoW, monoH, monoD, monoR;

  Monolith(int monoP) {
    // Monolith dimensions
    if (monoN <= 6) {
      monoW = width / 5;
    } else {
      monoW = width / (monoN + 1);
    }
    monoH = 2 * (height / 3);
    monoD = 180;
    // Center point for rotation
    centerX = width / 2;
    centerY = height / 2;
    centerZ = 0;
    
    monoZ = -1000;
    monoR = monoAngle * monoP - PI / 2 + monoAngle / 2;
  }
  void display() {
    canvas3D.push();
    canvas3D.translate(centerX, centerY, centerZ);
    canvas3D.rotateY(monoR);
    canvas3D.translate(0, 0, monoZ);
    //unfortunatelly, using stroke was triggering transparency and I could not fix it.
    canvas3D.noStroke();
    //canvas3D.stroke(monoStkHue, monoStkSat, monoStkBri, 100); //see comment regarding stroke on the top of this tab
    canvas3D.fill(monoFillHue, monoFillSat, monoFillBri,255);
    canvas3D.box(monoW, monoH, monoD);
    canvas3D.pop();
  }
}
