import java.util.ConcurrentModificationException;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Iterator;

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myBroadcastLocation; 

import controlP5.*;
ControlP5 cp5;

int stage, starting;
boolean textfieldRemoved = false;

void setup() {
//  size(1280,720);
//  size(854,480,P2D);
//  size(1920, 1080, P2D);
//  size(2560, 1440, P2D);
  fullScreen(P2D,2);
  frameRate(30);
  oscP5 = new OscP5(this, 12000);
//  myBroadcastLocation = new NetAddress("192.168.0.196", 8000);
//  myBroadcastLocation = new NetAddress("192.168.0.199", 8000);
  myBroadcastLocation = new NetAddress("localhost", 8000);

  
  colorMode(HSB,360,100,100,100);
  
  starting = 0;
  
  
  uiSetup();
  
  monolithSetup(); // Ensure this is called first to initialize canvas3D and bkg
  camSetup();
  notySetup();
  myEclipse = new Eclipse();
  faixaSetup();
  boidsSetup();
  bkgTexSetup(); 
  
  stage = 0;
}

void draw() {
  if (stage == 0) {
    background(50,100,0,100);
    uiUpdate();
    uiDraw();
  } else if (stage == 1) {
    background(50,100,0,100);
    if (!textfieldRemoved) {
      Textfield inputField = cp5.get(Textfield.class, "input");
      if (inputField != null) {
        inputField.remove();  // Remove the text field
        textfieldRemoved = true;  // Prevent further removals
      }
    }
    title();
  } else if (stage == 2) {
    setColors();
    bkgC();
    bkgDraw();
    bkgTexDraw();
    monolithDraw();
    camDraw();
    starDraw();
    boidsDraw();
    walkerDraw();
    notyDraw();
    eclipseDraw();
    updateRipples();
    faixaDraw();
  } else if (stage == 3) {
    background(50,100,0,100);
    outro();
  }
}

void oscEvent(OscMessage theOscMessage) {
  // make PD connect when toggled on Processing
  if (theOscMessage.addrPattern().equals("/oscConnected")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      oscTglActive = true;
    } 
    println("Received oscConnected");
  }
  if (theOscMessage.addrPattern().equals("/next")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      stage += 1;
      println("Current Stage: "+stage);
    } 
  }
  //generate noty instrument arrays
  if (theOscMessage.addrPattern().equals("/samph1R")) {
    for (int i = 0; i < 4; i++) {
      samph1R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/samph2R")) {
    for (int i = 0; i < 4; i++) {
      samph2R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/samph3R")) {
    for (int i = 0; i < 4; i++) {
      samph3R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/samph4R")) {
    for (int i = 0; i < 4; i++) {
      samph4R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/diceTone1R")) {
    for (int i = 0; i < 4; i++) {
      diceTone1R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/diceTone2R")) {
    for (int i = 0; i < 4; i++) {
      diceTone2R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/simph1R")) {
    for (int i = 0; i < 4; i++) {
      simph1R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/simph2R")) {
    for (int i = 0; i < 4; i++) {
      simph2R[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/samph1L")) {
    for (int i = 0; i < 4; i++) {
      samph1L[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/samph2L")) {
    for (int i = 0; i < 4; i++) {
      samph2L[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/samph3L")) {
    for (int i = 0; i < 4; i++) {
      samph3L[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/samph4L")) {
    for (int i = 0; i < 4; i++) {
      samph4L[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/diceTone1L")) {
    for (int i = 0; i < 4; i++) {
      diceTone1L[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/diceTone2L")) {
    for (int i = 0; i < 4; i++) {
      diceTone2L[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/simph1L")) {
    for (int i = 0; i < 4; i++) {
      simph1L[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/simph2L")) {
    for (int i = 0; i < 4; i++) {
      simph2L[i] = theOscMessage.get(i).floatValue();
    }
  }
  // noty line thickness
  if (theOscMessage.addrPattern().equals("/lineW")) {
    lineW = theOscMessage.get(0).floatValue();
  }
  //eclipse OSC data
  if (theOscMessage.addrPattern().equals("/eclipse")) {
    for (int i = 0; i < 3; i++) {
      eclipse[i] = theOscMessage.get(i).floatValue();
    }
  }
  if (theOscMessage.addrPattern().equals("/moonR")) {
    eclipse[3] = theOscMessage.get(0).floatValue();
  }
  //Faixa bkg data
  if (theOscMessage.addrPattern().equals("/nmData")) {
    for (int i = 0; i < 7; i++) {
      faixaData[i] = theOscMessage.get(i).floatValue();
    }
  } else if (theOscMessage.addrPattern().equals("/nmOnOff")) {
    for (int i = 0; i < 4; i++) {
      faixaOnOff[i] = theOscMessage.get(i).floatValue();
    }
  }
  //walker data
  if (theOscMessage.addrPattern().equals("/walkerData") || theOscMessage.addrPattern().equals("/walkerData2")) {
    for (int i = 0; i < 6; i++) {
      walkerData[i] = theOscMessage.get(i).floatValue();
    }
    if (walkers.size() + 16 <= 1600) {
      walkerSetup();
    } else {
    }    
  }
  // ripple data
  if (theOscMessage.addrPattern().equals("/rippleData")) {
    float x = theOscMessage.get(0).floatValue();
    float y = theOscMessage.get(1).floatValue();
    float fadeSpeed = theOscMessage.get(2).floatValue();
    float delay = theOscMessage.get(3).floatValue();
    float growthRate = theOscMessage.get(4).floatValue();
    
    synchronized (rippleSets) {
      createRippleSet(x, y, fadeSpeed, delay, growthRate);
    }
  }
  // star data
  if (theOscMessage.addrPattern().equals("/starData1")) {
    for (int i = 0; i < 5; i++) {
      starData1[i] = theOscMessage.get(i).floatValue();
    }
  }
    if (theOscMessage.addrPattern().equals("/starData2")) {
    for (int i = 0; i < 5; i++) {
      starData2[i] = theOscMessage.get(i).floatValue();
    }
  }
  // monolith data
    if (theOscMessage.addrPattern().equals("/monoData")) {
      int newMonoN = (int) theOscMessage.get(0).floatValue();
      if (newMonoN != monoN) {
        monoN = newMonoN;
        monolithSetup(); // Reinitialize monoliths if monoN changes
        camSetup();
      }
    }
    if (theOscMessage.addrPattern().equals("/camData")) {
      for (int i = 0; i < 4; i++) {
        camData[i] = theOscMessage.get(i).floatValue();
      }
      myCam.init();
    } 
    //flocking boids data
  if (theOscMessage.addrPattern().equals("/boidsData")) {
    for (int i = 0; i < 8; i++) {
      boidsData[i] = theOscMessage.get(i).floatValue();
    }
    activateBoids();
  }
  // handle colors
  if (theOscMessage.addrPattern().equals("/hues")) {
    for (int i = 0; i < 15; i++) {
      hues[i] = theOscMessage.get(i).floatValue();
    }
  }
  if (theOscMessage.addrPattern().equals("/sats")) {
    for (int i = 0; i < 15; i++) {
      sats[i] = theOscMessage.get(i).floatValue();
    }
  }
  if (theOscMessage.addrPattern().equals("/bris")) {
    for (int i = 0; i < 15; i++) {
      bris[i] = theOscMessage.get(i).floatValue();
    }
  }
  if (theOscMessage.addrPattern().equals("/bkgData")) {
    for (int i = 0; i < 2; i++) {
      bkgData[i] = theOscMessage.get(i).floatValue();
    }
    setColors();
    bkgC();
    println("colors set");
    stage += 1;
  }
  if (theOscMessage.addrPattern().equals("/bkgBlur")) {
    blurLvl = theOscMessage.get(0).floatValue();
    println("Blur level: "+blurLvl);
//    setColors();
//    bkgC();
  }
  // handle ellipses for background texture
  if (theOscMessage.addrPattern().equals("/ellipseData")) {
    for (int i = 0; i < maxEllipses; i++) {
      float isActive = theOscMessage.get(i * 4).floatValue(); // OSC index 0, 4, 8...
      oscX[i] = theOscMessage.get(i * 4 + 1).floatValue(); // X coordinate
      oscY[i] = theOscMessage.get(i * 4 + 2).floatValue(); // Y coordinate
      oscSize[i] = theOscMessage.get(i * 4 + 3).floatValue(); // Size
      
      // Activate or deactivate the ellipse
      if (isActive > 0) {
        ellipses[i].activate(oscX[i], oscY[i], oscSize[i]);
      } else {
        ellipses[i].active = false;
      }
    }
  }
  if (theOscMessage.addrPattern().equals("/elliColorChange")) {
    elliColorChange = theOscMessage.get(0).floatValue();
    bkgTexUpdate();
  }
}
