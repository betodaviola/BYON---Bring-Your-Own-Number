float [] boidsData = new float[8]; // boidsOn, x, y, seed, force, spd (1-33), size(1-10), color squeme
int boidsSeed;
float boidsSpdCoef, boidsAccCoef, boidsCohCoef; // speed, acceleration and coherence coefficients
float boidsRad, boidsSiz; // radius and size
float maxSpd, maxForce;
PShape boidShape;
float shapeType;

ArrayList<Boid> boidsList;
ArrayList<Boid> boidsToRemove = new ArrayList<Boid>();

float boids1StkHue, boids1StkSat, boids1StkBri;
float boids1FillHue, boids1FillSat, boids1FillBri;
float boids2StkHue, boids2StkSat, boids2StkBri;
float boids2FillHue, boids2FillSat, boids2FillBri;

boolean boidCreationEnabled = true;
boolean hasReachedLimit = false;

void boidsSetup() {
  boidCreationEnabled = true; // Initialize this to true
  boidsSpdCoef = 1.5;
  boidsAccCoef = 1.0;
  boidsCohCoef = 1.0;
  boidsRad = 100;
  boidsList = new ArrayList<Boid>();
}

void boidsDraw() {
  synchronized (boidsList) {
    // Update and draw boids
    for (Boid b : boidsList) {
      b.update();
      b.display();
    }

    // Remove boids that are in the boidsToRemove list
    boidsList.removeAll(boidsToRemove);
    boidsToRemove.clear();

    // Control boid creation based on the number of boids
    int currentBoidCount = boidsList.size();
    
    if (currentBoidCount >= 200) {
        // Stop creating new boids if the upper limit is reached
      boidCreationEnabled = false;
    } else if (currentBoidCount <= 150) {
        // Reactivate boid creation if below the lower limit
      boidCreationEnabled = true;
    }

    // If boidsData[0] == 0, disable boid creation but allow removal
    if (boidsData[0] == 0) {
      boidCreationEnabled = false;
    }
  }
}




void activateBoids() {
  if (boidCreationEnabled && boidsData[0] > 0) {
    shapeType = boidsData[0];
    maxSpd = boidsData[5];
    maxForce = boidsData[4];
    boidsSeed = (int) boidsData[3];

    float boidSize = boidsData[6];
    color boidStk, boidFill;
    
    if (boidsData[7] == 0) {
      boidStk = color(boids1StkHue, boids1StkSat, boids1StkBri, 100);
      boidFill = color(boids1FillHue, boids1FillSat, boids1FillBri, 100);
    } else {
      boidStk = color(boids2StkHue, boids2StkSat, boids2StkBri, 100);
      boidFill = color(boids2FillHue, boids2FillSat, boids2FillBri, 100);
    }

    randomSeed(boidsSeed + (boidsList.size()*3));
    PVector initialVel = PVector.random2D().mult(2); // Initial velocity to kickstart movement

    synchronized (boidsList) {
      randomSeed(boidsSeed + 6000);
      boidsList.add(new Boid(new PVector(boidsData[1] + random(-50, 50), boidsData[2] + random(-50, 50)), initialVel, boidSize, boidStk, boidFill));
    }
  }
}


class Boid {
  PVector pos;
  PVector vel;
  PVector acc;
  float size;
  color boidStk, boidFill;
  PShape boidShape;  // Cached shape
  
  public Boid(PVector pos, PVector vel, float size, color boidStk, color boidFill) {
    this.pos = pos;
    this.vel = vel;
    this.acc = new PVector();
    this.size = size;
    this.boidStk = boidStk;
    this.boidFill = boidFill;
    this.boidShape = createBoidShape(size);  // Create the shape once
  }
  
  PShape createBoidShape(float size) {
    PShape shape = createShape();
    shape.beginShape();
    shape.strokeWeight(1.5);
    shape.fill(boidFill);
    shape.stroke(boidStk);  // Initial color
    int npoints = (int) shapeType + 2;
    float angle = TWO_PI / npoints;
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = cos(a) * size;
      float sy = sin(a) * size;
      shape.vertex(sx, sy);
    }
    shape.endShape(CLOSE);
    return shape;
  }
  
  void drawBoid(float x, float y, float heading) {
    push();
    translate(x, y);
    rotate(heading);
    boidShape.setStroke(boidStk);  // Change color dynamically
    boidShape.setFill(boidFill);
    shape(boidShape);
    pop();
  }
  
  void display() {
    // Check if boidsData[0] > 0 and boidCreationEnabled for wrapping, otherwise allow moving out of screen
    float margin = boidsData[6] + 2; // Margin based on the boid size
    if (boidCreationEnabled && boidsData[0] > 0) {
        // Wrapping logic for visual effect
        drawBoid(pos.x, pos.y, vel.heading());
        if (pos.x < 50) {
            drawBoid(pos.x + width, pos.y, vel.heading());
        }
        if (pos.x > width - 50) {
            drawBoid(pos.x - width, pos.y, vel.heading());
        }
        if (pos.y < 50) {
            drawBoid(pos.x, pos.y + height, vel.heading());
        }
        if (pos.y > height - 50) {
            drawBoid(pos.x, pos.y - height, vel.heading());
        }
    } else {
        // No wrapping, just display and let them move off the screen
        // Draw only if within screen bounds plus margin
        if (pos.x >= -margin && pos.x <= width + margin && pos.y >= -margin && pos.y <= height + margin) {
            drawBoid(pos.x, pos.y, vel.heading());
        }
    }
}

  
  void separate() {
    PVector target = new PVector();
    int total = 0;
    for (Boid other : boidsList) {
      float d = dist(pos.x, pos.y, other.pos.x, other.pos.y);
      if (other != this && d < boidsRad) {
        PVector diff = PVector.sub(pos, other.pos);
        diff.div(d * d);
        target.add(diff);
        total++;
      }
    }
    if (total == 0) return;
    
    target.div(total);
    target.setMag(maxSpd);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(boidsSpdCoef);
    acc.add(force);
    
  }
  
  void cohere() {
    PVector center = new PVector();
    int total = 0;
    for (Boid other : boidsList) {
      float d = dist(pos.x, pos.y, other.pos.x, other.pos.y);
      if (other != this && d < boidsRad) {
        center.add(other.pos);
        total++;
      }
    }
    if (total == 0) return;
    center.div(total);
    PVector target = PVector.sub(center, pos);
    target.setMag(maxSpd);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(boidsCohCoef);
    acc.add(force);
    
  }
  
  void align() {
    PVector target = new PVector();
    int total = 0;
    for (Boid other : boidsList) {
      float d = dist(pos.x, pos.y, other.pos.x, other.pos.y);
      if (other != this && d < boidsRad) {
        target.add(other.vel);
        total++;
      }
    }
    if (total == 0) return;
    target.div(total);
    target.setMag(maxSpd);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(boidsAccCoef);
    acc.add(force);
    
  }
  
  void wrap() {
    // Allow boids to exit the screen naturally when creation is disabled
    if (!boidCreationEnabled || boidsData[0] == 0) {
        // No wrapping, just let them exit the screen
        float margin = boidsData[6]; // Ensure removal only when fully out
        if (pos.x < -margin || pos.x > width + margin || pos.y < -margin || pos.y > height + margin) {
            // Remove the boid only when it is completely off-screen
            boidsToRemove.add(this);
        }
    } else {
        // Normal wrapping logic for visual effect
        if (pos.x < 0) {
            pos.x = width;
        } else if (pos.x >= width) {
            pos.x = 0;
        }

        if (pos.y < 0) {
            pos.y = height;
        } else if (pos.y >= height) {
            pos.y = 0;
        }
    }
}
  void update() {
    acc = new PVector();
    align();
    cohere();
    separate();
    vel.add(acc);
    vel.limit(maxSpd);
    pos.add(vel);
    wrap();
  }
}
