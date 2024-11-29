float[] hues = new float[15];
float[] sats = new float[15];
float[] bris = new float[15];
int bkgHueSeed;

void setColors() {
  //HUE array
  bkgHueSeed = int(hues[0]*20000);
  
  boids1StkHue = hues[1];
  boids1FillHue = hues[2];
  boids2StkHue = hues[3];
  boids2FillHue = hues[4];
  faixa1FillHue = hues[5];
  faixa2FillHue = hues[6];
  monoStkHue = hues[7];
  monoFillHue = hues[8];
  notyStkHue = hues[9];
  rippleStkHue = hues[10];
  star1StkHue = hues[11];
  star2StkHue = hues[12];
  walker1StkHue = hues[13];
  walker2StkHue = hues[14];
  //SATURATION array
  bkgSat = sats[0];
  boids1StkSat = sats[1];
  boids1FillSat = sats[2];
  boids2StkSat = sats[3];
  boids2FillSat = sats[4];
  faixa1FillSat = sats[5];
  faixa2FillSat = sats[6];
  monoStkSat = sats[7];
  monoFillSat = sats[8];
  notyStkSat = sats[9];
  rippleStkSat = sats[10];
  star1StkSat = sats[11];
  star2StkSat = sats[12];
  walker1StkSat = sats[13];
  walker2StkSat = sats[14];
  //BRIGHTNESS array
  bkgBri = bris[0];
  boids1StkBri = bris[1];
  boids1FillBri = bris[2];
  boids2StkBri = bris[3];
  boids2FillBri = bris[4];
  faixa1FillBri = bris[5];
  faixa2FillBri = bris[6];
  monoStkBri = bris[7];
  monoFillBri = bris[8];
  notyStkBri = bris[9];
  rippleStkBri = bris[10];
  star1StkBri = bris[11];
  star2StkBri = bris[12];
  walker1StkBri = bris[13];
  walker2StkBri = bris[14];
  //BACKGROUND color profiles
  primeId = bkgData[0];
  bOrW = bkgData[1];

  if (willBlur == 3 || willBlur == 4) { // 20% chance of transparency
    bkgTra = blurLvl;  
  } else {
    bkgTra = 100;
  }
}
void blurOrNot() {
  randomSeed((int)inputN);
  willBlur = int(random(10));
}
