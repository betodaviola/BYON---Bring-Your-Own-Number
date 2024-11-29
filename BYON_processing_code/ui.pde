PFont titleF, normalF;
String instructions, status, textValue;
color oscTglC, oscTglInactiveC, oscTglActiveC, oscTglHooverC, okBtnC, okBtnHoverC;
float oscTglX, oscTglY, oscTglSize, okBtnX, okBtnY, okBtnW, okBtnH, inputN;
boolean oscTglOver = false;
boolean oscTglActive = false;
boolean okBtnOver = false;

void uiSetup() {
  oscTglX = height/6;
  oscTglY = height/2;
  oscTglSize = height/25;
  
  okBtnX = (height/2)+(height/50);
  okBtnY = (height/2)+(height/5);
  okBtnW = height/18;
  okBtnH = height/18;
  
  titleF = createFont("Kanit-Bold.ttf", height/5);
  normalF = createFont("Kanit-Bold.ttf", height/25);
  
  instructions = "INSTRUCTIONS\n   1. OPEN BYON - Music\n   2. ADJUST YOUR VOLUME\n   3. CLICK ON CONNECT OSC ON THE LEFT\n   4. ONCE CONNECTION IS CONFIRMED,\nINPUT CHOSEN NUMBER AND CLICK OK\nMAKE SURE THE CHOSEN NUMBER IS GOES\nFROM 0 TO 1,000,000";
  status = "DISCONNECTED";
  textValue = "";
  
  oscTglInactiveC = color(0,100,0,100);
  oscTglC = oscTglInactiveC;
  oscTglActiveC = color(0,0,100,100);
  oscTglHooverC = color(0,0,75,100);
  
  okBtnC = color(0,100,0,100);
  okBtnHoverC = color(0,0,75,100);
  
  //input-n box
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("input")
    .setCaptionLabel("INPUT: ")
    .setPosition(height/4,(height/2)+(height/5))
    .setSize(height/4, height/18)
    .setFont(normalF)
    .setFocus(true)
    .setColor(color(0,0,100,100))
    .setColorBackground(color(0,100,0,100))
    .setColorActive(color(0,0,100,100))
    .setColorForeground(color(0,0,100,100))
    .setColorCaptionLabel(color(0,0,100,100))
    .setColorValueLabel(color(0,0,100,100))
    .getCaptionLabel()
    .setFont(normalF)
    .align(ControlP5.LEFT_OUTSIDE, ControlP5.LEFT_OUTSIDE);
}

void uiDraw() {
  //title
  noStroke(); // sun
  fill(50,0,100,100);
  ellipse(height/5,height/5,height/3,height/3);
  noStroke(); // moon
  fill(50,100,0,100);
  ellipse(height/4.5,height/5,height/3,height/3.3);
  textFont(titleF);
  fill(50,0,100,100);
  text("BYON", height/6, height/4);
  textFont(normalF);
  text("Bring Your Own Number", height/6, height/3.5);
  
  //instructions
  textFont(normalF);
  text(instructions, width/2, height/4);
  
  //osc section
  strokeWeight(3);
  stroke(40,0,100,100);
  
  if (oscTglOver) {
    oscTglC = oscTglHooverC;
  } else if (oscTglActive) {
    oscTglC = oscTglActiveC;
    status = "CONNECTED";
  } else if (!oscTglActive){
    oscTglC = oscTglInactiveC;
    status = "DISCONNECTED";
  }
  
  fill(oscTglC);
  ellipse(oscTglX,oscTglY,oscTglSize,oscTglSize);
  
  textFont(normalF);
  fill(50,0,100,100);
  text("CONNECT OSC\n      STATUS: " + status, (height/6)+(height/25),(height/2)+(height/50));
  
  // OK button
  if (okBtnOver) {
    fill(okBtnHoverC);
  } else {
    fill(okBtnC);
  }
  stroke(oscTglActiveC);
  rect(okBtnX, okBtnY, okBtnW, okBtnH);
  
  textFont(normalF);
  fill(50,0,100,100);
  text("OK",okBtnX, okBtnY+height/25);
  
  //me
  textFont(normalF);
  fill(50,0,100,100);
  text("CREATED BY ROBERTO MOCHETTI IN 2024", height/6, height-(height/12));
  textFont(normalF);
}

void textBox() {
  
}

void uiUpdate() {
  oscTglOver = overOscTgl(oscTglX, oscTglY, oscTglSize);
  okBtnOver = overRect(okBtnX, okBtnY, okBtnW, okBtnH);
}

boolean overOscTgl(float x, float y, float diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  return sqrt(sq(disX) + sq(disY)) < diameter / 2;
}

boolean overRect(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

void mousePressed() {
  if (overOscTgl(oscTglX, oscTglY, oscTglSize)) {
    if (!oscTglActive) {
      sendOscScreenSize();
//      oscTglActive = true;
    } else if (oscTglActive) {
      sendOscScreenSize();
      OscMessage oscOff = new OscMessage("/oscOff");
      oscOff.add(0);
      oscP5.send(oscOff, myBroadcastLocation);
      oscTglActive = false;
    }
  }
  if (overRect(okBtnX, okBtnY, okBtnW, okBtnH)) {
    // Get the value from the text field and print it to the terminal
    textValue = cp5.get(Textfield.class, "input").getText();
    inputN = float(textValue);
    OscMessage inputNumber = new OscMessage("/inputN");
    inputNumber.add(inputN);
    oscP5.send(inputNumber, myBroadcastLocation);
    stage += 1;
    blurOrNot();
  }
}

void sendOscScreenSize() {
  OscMessage screenW = new OscMessage("/width");
  screenW.add(width);
  oscP5.send(screenW, myBroadcastLocation);
  
  OscMessage screenH = new OscMessage("/height");
  screenH.add(height);
  oscP5.send(screenH, myBroadcastLocation);
}
