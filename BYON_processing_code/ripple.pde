float rippleStkHue, rippleStkSat, rippleStkBri;

class Ripple {
  float x, y;
  float size;
  float transparency;
  float growthRate;
  float fadeSpeed;
  float strokeWeight;

  Ripple(float x, float y, float fadeSpeed, float growthRate, float strokeWeight) {
    this.x = x;
    this.y = y;
    this.size = 0;
    this.transparency = 100;  // Start with full transparency (100)
    this.growthRate = growthRate;
    this.fadeSpeed = fadeSpeed;
    this.strokeWeight = strokeWeight;
  }

  void update() {
    size += growthRate;
    transparency -= fadeSpeed;
    transparency = max(0, transparency);  // Prevent negative transparency
  }

  void display() {
    if (transparency > 0) {
      stroke(rippleStkHue, rippleStkSat, rippleStkBri, transparency);
      noFill();
      strokeWeight(strokeWeight);
      ellipse(x, y, size, size);
    }
  }

  boolean isDead() {
    return transparency <= 0;
  }
}

class RippleSet {
  ArrayList<Ripple> ripples;
  float delay;
  float lastGeneratedTime;
  boolean generating;
  Ripple firstRipple;  // Track the first ripple separately
  int maxRipples;      // Control max number of ripples
  int currentRipples;  // Track number of generated ripples

  RippleSet(float x, float y, float fadeSpeed, float delay, float growthRate, int maxRipples) {
    this.ripples = new ArrayList<Ripple>();
    this.delay = delay;
    this.lastGeneratedTime = millis();
    this.generating = true;
    this.maxRipples = maxRipples;
    this.currentRipples = 1;  // Start with the first ripple

    // Create and track the first ripple with strokeWeight based on delay threshold
    float strokeW = (delay < 300) ? 20 : 5;
    firstRipple = new Ripple(x, y, fadeSpeed, growthRate, strokeW);
    ripples.add(firstRipple);

    // If the delay is less than 300ms, stop further ripple generation immediately
    if (delay < 300) {
      generating = false;  // Only generate one ripple
    }
  }

  void update() {
    // Stop generating new ripples if the first ripple is dead or maxRipples is reached
    if (generating && (firstRipple.isDead() || currentRipples >= maxRipples)) {
      generating = false;
    }

    // Continue generating new ripples if allowed
    if (generating && millis() - lastGeneratedTime >= delay) {
      ripples.add(new Ripple(firstRipple.x, firstRipple.y, firstRipple.fadeSpeed, firstRipple.growthRate, firstRipple.strokeWeight));
      currentRipples++;
      lastGeneratedTime = millis();
    }

    // Update and remove dead ripples
    Iterator<Ripple> rippleIterator = ripples.iterator();
    while (rippleIterator.hasNext()) {
      Ripple ripple = rippleIterator.next();
      ripple.update();

      if (ripple.isDead()) {
        rippleIterator.remove();
      }
    }
  }

  void display() {
    for (Ripple ripple : ripples) {
      ripple.display();
    }
  }

  boolean isEmpty() {
    return ripples.isEmpty();
  }
}

ArrayList<RippleSet> rippleSets = new ArrayList<RippleSet>();

void updateRipples() {
  synchronized (rippleSets) {
    Iterator<RippleSet> setIterator = rippleSets.iterator();
    while (setIterator.hasNext()) {
      RippleSet rs = setIterator.next();
      rs.update();
      rs.display();

      if (rs.isEmpty()) {
        setIterator.remove();
      }
    }
  }
}

void createRippleSet(float x, float y, float fadeSpeed, float delay, float growthRate) {
  int maxRipples = 5;  // Adjust the maxRipple value as needed
  synchronized (rippleSets) {
    RippleSet newSet = new RippleSet(x, y, fadeSpeed, delay, growthRate, maxRipples);
    rippleSets.add(newSet);
  }
}
