float [] walkerData = new float[6]; // x, y, size, seed, spd, color squeme

String[] dirs = {"ur", "ul", "dr", "dl", "u", "u", "d", "d", "ur", "ul", "dr", "dl", "u", "u", "d", "d"};
ArrayList<Walker> walkers = new ArrayList<Walker>();

float walker1StkHue, walker1StkSat, walker1StkBri;
float walker2StkHue, walker2StkSat, walker2StkBri;

void walkerSetup() {  
  for (int i = 0; i < 16; i++) {
    walkers.add(new Walker(i + 1, dirs[i]));
  }
}


void walkerDraw() {
  if (walkers == null || walkers.size() == 0) {
    return;
  }
  for (int i = walkers.size()-1; i >= 0; i--) {
    Walker walker = walkers.get(i);
    walker.updateAndDisplay();
    if (!walker.active) {
      walkers.remove(i);
    }
  } 
}

class Walker {
  String dir;
  int seed, finalSeed;
  boolean active;
  float prevX, prevY, stepX, stepY;
  float x = walkerData[0];
  float y = walkerData[1];
  float size = walkerData[2];
  float walkerSeed = walkerData[3];
  float spd = walkerData[4]; // Controls the speed of the animation (1-100)
  float walkerC = walkerData[5];
  color c;
  
  Walker(int tempSeed, String tempDir) {
    dir = tempDir;
    seed = tempSeed;
    active = true;
    finalSeed = (int)(walkerSeed + seed);
    randomSeed(finalSeed); // Ensure unique movement per frame and seed
  }

  void generateSteps() {
    randomSeed(finalSeed); // Ensure the same seed is used for consistent steps
    if (dir.equals("u")) {
      prevX = x;
      prevY = y; 
      x += random(0, spd);
      y += random(-spd, spd);
    } else if (dir.equals("d")) {
      prevX = x;
      prevY = y; 
      x += random(-spd, 0);
      y += random(-spd, spd);
    } else if (dir.equals("ur")) {
      prevX = x;
      prevY = y; 
      x += random(0, spd);
      y += random(0, spd);
    } else if (dir.equals("dr")) {
      prevX = x;
      prevY = y; 
      x += random(0, spd);
      y += random(-spd, 0);
    } else if (dir.equals("ul")) {
      prevX = x;
      prevY = y; 
      x += random(-spd, 0);
      y += random(0, spd);
    } else if (dir.equals("dl")) {
      prevX = x;
      prevY = y; 
      x += random(-spd, 0);
      y += random(-spd, 0);
    }
  }

  void updateAndDisplay() {
    if (!active) {
      return;
    }
    generateSteps();
    push();
    if (walkerC == 0) {
      c = color(walker1StkHue, walker1StkSat, walker1StkBri, 100);
      //c = color(100, 100, 100, 100);
    } else {
      c = color(walker2StkHue, walker2StkSat, walker2StkBri, 100);
      //c = color(200, 100, 100, 100);
    }
      fill(c);
      noStroke();
      ellipse(prevX, prevY, size, size);
      
      stroke(c);
      strokeWeight(size);
      line(x,y,prevX,prevY);
      
      fill(c);
      noStroke();
      ellipse(x, y, size, size);
      pop();
    // Stop updating if the walker hits the edge
    if (x < 0 || x > width || y < 0 || y > height) {
      active = false;
    }
  }
}
