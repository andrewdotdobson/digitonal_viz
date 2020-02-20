void setup() {
  size(1600, 1600);
}

void draw() {
  background(255);
  //noFill();
  strokeWeight(1);
  stroke(0, 32);

  for (int j = 0; j < height; j+= 4) {
    beginShape();
    for (int i = 0; i < width; i++) {
      float h = noise((i + (j*100)) * 0.01);
      h = map(h, 0, 1, -50, 50);
      vertex(i, j + h);
      if (random(100) < 1) {
        fill(0, 32);
        float rw = random(1, 8);
        float rh = random(1, 2);
        ellipse(i, j+h, rw, rh);
        fill(255);
      }
    }
    endShape();
  }

  float offset = 20;
  for (int i = 0; i < 130; i++) {
    float x1 = random(width);
    float y1 = random(height);
    float x2 = x1 + random(-offset, offset);
    float y2 = y1 + random(-offset, offset);
    float x3 = x2 + random(-offset, offset);
    float y3 = y2 + random(-offset, offset);
    float x4 = x3 + random(-offset, offset);
    float y4 = y3 + random(-offset, offset);
  //  bezier(x1, y1, x2, y2, x3, y3, x4, y4);
  }

  noLoop();
}
