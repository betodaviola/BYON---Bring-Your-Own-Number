PShape noty;

int [] notiesXR = new int[9];
int [] notiesXL = new int[9];

float smallString;

float lineW; // lineWeight from 5 to 10 (0-5 in PD)

float [] samph1L = new float[4];
float [] samph2L = new float[4];
float [] samph3L = new float[4];
float [] samph4L = new float[4];
float [] diceTone1L = new float[4];
float [] diceTone2L = new float[4];
float [] simph1L = new float[4];
float [] simph2L = new float[4];

float [] samph1R = new float[4];
float [] samph2R = new float[4];
float [] samph3R = new float[4];
float [] samph4R = new float[4];
float [] diceTone1R = new float[4];
float [] diceTone2R = new float[4];
float [] simph1R= new float[4];
float [] simph2R = new float[4];

float notyStkHue, notyStkSat, notyStkBri;
// color notyC;

NotyR myNotyR1;
NotyR myNotyR2;
NotyR myNotyR3;
NotyR myNotyR4;
NotyR myNotyR5;
NotyR myNotyR6;
NotyR myNotyR7;
NotyR myNotyR8;

NotyL myNotyL1;
NotyL myNotyL2;
NotyL myNotyL3;
NotyL myNotyL4;
NotyL myNotyL5;
NotyL myNotyL6;
NotyL myNotyL7;
NotyL myNotyL8;

//startNoty myStartNoty;

void notySetup() {

  for (int i = 0; i < 9; i++) {
    notiesXR[i] = (width/2) + (width/18) + ((width/18) * i);
  }
  for (int i = 0; i < 9; i++) {
    notiesXL[i] = (width/2) - (width/18) - ((width/18) * i);
  }

  myNotyL1 = new NotyL(1, samph1L, 'd');
  myNotyL2 = new NotyL(2, samph2L, 'u');
  myNotyL3 = new NotyL(3, samph3L, 'd');
  myNotyL4 = new NotyL(4, samph4L, 'u');
  myNotyL5 = new NotyL(5, diceTone1L, 'd');
  myNotyL6 = new NotyL(6, diceTone2L, 'u');
  myNotyL7 = new NotyL(7, simph1L, 'd');
  myNotyL8 = new NotyL(8, simph2L, 'u');
  
  myNotyR1 = new NotyR(1, samph1R, 'u');
  myNotyR2 = new NotyR(2, samph2R, 'd');
  myNotyR3 = new NotyR(3, samph3R, 'u');
  myNotyR4 = new NotyR(4, samph4R, 'd');
  myNotyR5 = new NotyR(5, diceTone1R, 'u');
  myNotyR6 = new NotyR(6, diceTone2R, 'd');
  myNotyR7 = new NotyR(7, simph1R, 'u');
  myNotyR8 = new NotyR(8, simph2R, 'd');
}

void notyDraw() {
  myNotyR1.display();
  myNotyR2.display();
  myNotyR3.display();
  myNotyR4.display();
  myNotyR5.display();
  myNotyR6.display();
  myNotyR7.display();
  myNotyR8.display();
  
  myNotyL1.display();
  myNotyL2.display();
  myNotyL3.display();
  myNotyL4.display();
  myNotyL5.display();
  myNotyL6.display();
  myNotyL7.display();
  myNotyL8.display();
}
  
class NotyR {
  color c;
  //variables
  float[] amps;
  char dir;
  float startX;
  float strx1, stry1, strx2, stry2, strx3, stry3, strx4, stry4, strx5, stry5, strx6, stry6;

  NotyR(float tempStartX, float[] tempAmps, char tempDir) {
    smallString = width/90;
//    c = notyC;
    c = sunC;
    dir = tempDir;
    amps = tempAmps;
    startX = tempStartX; //start on x for the strings of each instrument
    updateNoty(); //initial position calculation
  }
    
  void updateNoty() {   
    strx1 = notiesXR[(int) startX - 1];
    stry1 = height/2;
    strx2 = strx1 + smallString;
    strx3 = strx2 + smallString;
    strx4 = strx3 + smallString;
    strx5 = strx4 + smallString;
    strx6 = notiesXR[(int) startX];
    stry6 = height/2;
    if (dir == 'u') {
      stry2 = (height/2) - amps[0];
      stry3 = (height/2) - amps[1];
      stry4 = (height/2) - amps[2];
      stry5 = (height/2) - amps[3];
    } else {
      stry2 = (height/2) + amps[0];
      stry3 = (height/2) + amps[1];
      stry4 = (height/2) + amps[2];
      stry5 = (height/2) + amps[3];
    }
  }
 
  void display() {
    updateNoty();
    c = sunC;
    push();
    noty = createShape();
    noty.beginShape();
    noty.noFill();
    noty.strokeWeight(5 + lineW);
    noty.stroke(c);
    noty.vertex(strx1,stry1);
    noty.vertex(strx2,stry2);
    noty.vertex(strx3,stry3);
    noty.vertex(strx4,stry4);
    noty.vertex(strx5,stry5);
    noty.vertex(strx6,stry6);
    noty.endShape();
    shape(noty);
    pop();
  }  
}

class NotyL {
  color c;
  //variables
  float[] amps;
  char dir;
  float startX;
  
  float strx1, stry1, strx2, stry2, strx3, stry3, strx4, stry4, strx5, stry5, strx6, stry6;

  NotyL(float tempStartX, float[] tempAmps, char tempDir) {
    smallString = width/90;
    c = sunC;
    dir = tempDir;
    amps = tempAmps;
    startX = tempStartX; //start on x for the strings of each instrument
  }
  void updateNoty() {
    strx1 = notiesXL[(int) startX - 1];
    stry1 = height/2;
    strx2 = strx1 - smallString;
    strx3 = strx2 - smallString;
    strx4 = strx3 - smallString;
    strx5 = strx4 - smallString;
    strx6 = notiesXL[(int) startX];
    stry6 = height/2;
    
    c = sunC;
    noty = createShape(); 
    if (dir == 'u') {
      stry2 = (height/2) - amps[0];
      stry3 = (height/2) - amps[1];
      stry4 = (height/2) - amps[2];
      stry5 = (height/2) - amps[3];
    } else {
      stry2 = (height/2) + amps[0];
      stry3 = (height/2) + amps[1];
      stry4 = (height/2) + amps[2];
      stry5 = (height/2) + amps[3];
    }

  }  
  void display() {
    updateNoty();
    c = sunC;
    push();
    noty = createShape();
    noty.beginShape();
    noty.noFill();
    noty.strokeWeight(5 + lineW);
    noty.stroke(c);
    noty.vertex(strx1,stry1);
    noty.vertex(strx2,stry2);
    noty.vertex(strx3,stry3);
    noty.vertex(strx4,stry4);
    noty.vertex(strx5,stry5);
    noty.vertex(strx6,stry6);
    noty.endShape();
    shape(noty);
    pop();
  }  
}
