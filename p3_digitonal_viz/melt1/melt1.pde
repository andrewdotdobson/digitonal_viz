import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.colorist.HColorPool;
import hype.extended.layout.HGridLayout;

// ******************************************
// Project Settings

int         SW         = 1920;
int         SH         = 1080;
color       clrBG            = #111111;
String      music      = "section.mp3";


// ******************************************
// Minim

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim        minim;
AudioPlayer  myAudio;
FFT          myAudioFFT;
AudioInput   lineIn;

boolean     showVisualiser    = false;

int         myAudioRange      = 256;
int         myAudioMax        = 100;

float       myAudioAmp        = 40.0;
float       myAudioIndex      = 0.2;
float       myAudioIndexAmp   = myAudioIndex;
float       myAudioIndexStep  = 0.35;

float[]     myAudioData       = new float[myAudioRange];



// ******************************************
// Sketch settings


HDrawablePool pool;
HColorPool    colors;
HCanvas       canvas;


int          colorAlpha        = 10; // give them an alpha value between 0-255;
int          canvasFade        = 2; // higher value = less sustain of pixels on screen.
int          poolObjects       = 20;
int          baseObjectSize    = 500;
boolean      audioReactionOn   = true; //switches on/off audio reactivity for debugging and layout

int          spacerX           = 50;
int          spacerY           = 10;
PVector      HORangeX          = new PVector(-spacerX,spacerX);//Range of X axis oscillation (HORIZONTAL)
PVector      HORangeY          = new PVector(-spacerY,spacerY);//Range of Y axis oscillation (VERTICAL)


float        swirlSpeedX       = 0; // higher, the faster 1 max speed ideally. point values are better (0.1 etc); 0 turns off osccilation
float        swirlSpeedY       = 0; // higher, the faster 0-255;
int          audioSizeScale    = 1500; // Size that each frequency band hit scales the particle to (100 is a good start);
int          offCentre         = 10; //how much off center the circles land
int          gridCols          = floor(sqrt(poolObjects));
// ******************************************
// 


void settings() {
   size(SW, SH); 
}

void setup() {
	//size(1080,720);
  pixelDensity(displayDensity());
  gridFunctions();
	H.init(this).background(clrBG).use3D(true);

  // *****************************
  minim = new Minim(this);
  myAudio = minim.loadFile(music);
  //myAudio = minim.loadFile("hld.wav");
  myAudio.cue(40000);
  myAudio.play();
  
  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);


	//colors = new HColorPool(#AEDBCD, #B8A0CD, #F37A84, #97D8E9, #E3B4D4, #FBF390, #FDC58C);
  colors = new HColorPool(#E4523B, #0A454D, #3DB296, #ECC417, #E8931E, #E4349C);
 //colors = new HColorPool(clrBG, clrBG, clrBG, clrBG, clrBG, #E4349C);
 
 colors = new HColorPool()
           .add(#af460f,5)
           .add(#fe8761,4)
           .add(#fed39f,3)
           .add(#f6eec9)
          ;
           
	canvas = H.add(new HCanvas()).autoClear(false).fade(canvasFade);

	pool = new HDrawablePool(poolObjects);
	pool.autoParent(canvas)
    .add(new HEllipse()
        .size(baseObjectSize)
        .anchor(0,baseObjectSize)
        .noFill()
        .noStroke()
       )
    
		.layout(new HGridLayout()
        .startLoc(SW/gridCols/2,SH/gridCols/2)
        .spacing(SW/gridCols,SH/gridCols)
        .cols(gridCols)
       )
        
		.onCreate(
			new HCallback() {
				public void run(Object obj) {
					int i = pool.currentIndex();

					HDrawable d = (HDrawable) obj;
					d
            .fill( colors.getColor(), colorAlpha )
            .anchorAt(H.CENTER)
            .rotation(random(0,360))
          //  .loc(SW/2,SH/2)
          ;
            
          
          if(swirlSpeedX>0){
          //X - horizontal oscillation.
          new HOscillator()
            .target(d)
            .property(H.X)
            .relativeVal(d.x())
            .range(HORangeX.x,HORangeX.y)
            .speed(swirlSpeedX)
            .freq(1)
           // .currentStep(i)
            ;
          }
          
          if(swirlSpeedY>0){

          //Y - vertical oscillation.
          new HOscillator()
            .target(d)
            .property(H.Y)
            .relativeVal(d.y())
            .range(HORangeY.x,HORangeY.y)
            .speed(swirlSpeedY)
            .freq(1)
          //  .currentStep(i)
            ;
            
          }
            
          /*
          new HOscillator()
            .target(d)
            .property(H.SCALE)
            .range(0.5, 2)
            .speed(0.3)
            .freq(5)
            .currentStep(i)
          ;
          */
                   
				}
			}
		)
		.requestAll()
	;
}

void draw() {

myAudioFFT.forward(myAudio.mix);
myAudioDataUpdate();
H.drawStage();

int i = 0;
if(audioReactionOn) {
for (HDrawable d : pool) {
 
  int fftScaling = (int)map(myAudioData[i], 0, myAudioMax, 1, audioSizeScale);
  d.size(fftScaling);
 // d.scale(fftScaling); // this isn't working because it's additive and it's going to keep multiplying itself.
  i++;
}
}
  
if(showVisualiser) myAudioDataWidget();

 // saveFrame("output/gol_####.png");

}


// ********************************************************************************
// Scene switching key bindings

void keyPressed() {

  switchColor(ceil(random(5)));
}


// ********************************************************************************
// color sets

void switchColor(int i)
{
  
 switch (i) {
  case 1:
     colors = new HColorPool()
           .add(#E4523B,5)
           .add(#0A454D,4)
           .add(#3DB296,3)
           .add(#ECC417
           );
  break;
  
    case 2:
     colors = new HColorPool()
           .add(#004445,5)
           .add(#2c786c,4)
           .add(#faf5e4,3)
           .add(#f8b400
           );
  break;
  
    case 3:
     colors = new HColorPool()
           .add(#1d4d4f,5)
           .add(#357376,4)
           .add(#6ba8a9,3)
           .add(#e5dfdf)
           ;
  break;
  
     case 4:
     colors = new HColorPool()
           .add(#f54291,5)
           .add(#ff78ae,4)
           .add(#fff8cd,3)
           .add(#ff6f5e)
           ;
  break;
  
       case 5:
     colors = new HColorPool()
           .add(#207561,5)
           .add(#589167,4)
           .add(#c5f0a4,3)
           .add(#da4302)
           ;
  break;
  
 }
 
 for (HDrawable d: pool)
 {
   d.fill(colors.getColor(), colorAlpha);
}
}



// ********************************************************************************
// AV functions


void gridFunctions() {
  int n = poolObjects;
  float sqn = sqrt(n);
  int cols = floor(sqn);
  float division = SW/cols;
  println("sq="+sqn);
  println("cols="+cols);
  
}

void myAudioDataUpdate() {
  for (int i = 0; i < myAudioRange; ++i) {
    float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
    float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
    myAudioData[i]     = tempIndexCon;
    myAudioIndexAmp+=myAudioIndexStep;
  }
  myAudioIndexAmp = myAudioIndex;
}

void myAudioDataWidget() {
  // noLights();
  // hint(DISABLE_DEPTH_TEST);
  noStroke(); fill(0,200); rect(0, height-112, width, 102);

  for (int i = 0; i < myAudioRange; ++i) {
    if     (i==0) fill(#237D26); // base  / subitem 0
    else if(i==3) fill(#80C41C); // snare / subitem 3
    else          fill(#CCCCCC); // others

    rect(10 + (i*5), (height-myAudioData[i])-11, 4, myAudioData[i]);
  }
  // hint(ENABLE_DEPTH_TEST);

}

//CLOSE DOWN SKETCH
void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}
