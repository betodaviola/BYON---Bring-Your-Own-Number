void title() {
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
  textFont(titleF);
  fill(50,0,100,100);
  text("#"+textValue, width/3, height/2);
}

void outro() {
  fill(50,0,100,100);
  textFont(normalF);
  textAlign(CENTER,BOTTOM);
  text("#"+textValue+"\nRoberto Mochetti (2024)", width/2, height-(height/25));
}
