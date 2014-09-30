// before loading new files lower the knob..

import controlP5.*;
import beads.*;

ControlP5 cp5;
Knob myKnobA,myKnobB,myKnobC;
AudioContext ac;
WavePlayer wp;
Gain g;
Glide gainGlide;
Glide frequencyGlide;

float a,b;
int i,j,k;
String[] logg;
String file;


void setup()
{
  size(720, 700);
  background(100, 100, 100);
  
  cp5 = new ControlP5(this);
  
  cp5.addButton("Load_logged_file")
     .setValue(0)
     .setPosition(30, 20)
     .setSize(85, 30)
     ;
     
     myKnobA = cp5.addKnob("Sawtooth_Affector")
               .setRange(0.0,1.0)
               .setValue(0.5)
               .setPosition(25, 90)
               .setRadius(50)
               .setViewStyle(Knob.ARC)
               .setDragDirection(Knob.VERTICAL)
               ;
     myKnobB = cp5.addKnob("Gap_Control")
               .setRange(200, 600)
               .setValue(400)
               .setPosition(200,90)
               .setRadius(50)
               .setViewStyle(Knob.ARC)
               .setDragDirection(Knob.VERTICAL)
               ;
          
          
     myKnobC = cp5.addKnob("Delay_Control")
               .setRange(25, 225)
               .setValue(80)
               .setPosition(500,90)
               .setRadius(50)
               .setViewStyle(Knob.ARC)
               .setDragDirection(Knob.VERTICAL)
               ;
     smooth();
  ac = new AudioContext();
  gainGlide = new Glide(ac, 0.0, 100);
  frequencyGlide = new Glide(ac, 200, 100);
  wp = new WavePlayer(ac, frequencyGlide, Buffer.SQUARE);
  
  g = new Gain(ac, 1, gainGlide);
  g.addInput(wp);
  ac.out.addInput(g);
 
  ac.start();
}

public void Load_logged_file(int theValue)
    { 
      file = selectInput();
      logg  = loadStrings(file);
      println(logg);
      /* for(i=32; i<=logg.length; i+=35)
        {
          a = float(logg[i]);
          delay(2000);
          gainGlide.setValue(a/(float)width);
          frequencyGlide.setValue(a + (height));
          println(a); 
        }*/
     //Testing code blocks that helped in final coding; 
     // ***********************//
     // a = float(logg[logg.length - '0']);
     // println(a);
     // text(logg[35], 250, 150);
     //***********************//
     
     //***********************//
     /* a = float(logg[0]);
      b = float(logg[35]);
      c = float(logg[70]);
      d = float(logg[105]);
      background(255);
      fill(0);
      text(a, 250, 50);
      text(b, 250, 100);
      text(c, 250, 150);
      text(d, 250, 200);*/
      //*********************//
    }
    
    void Sawtooth_Affector(int valueOne) 
    {
      b = valueOne;
    }
    void Gap_Control(int valueTwo) 
    {
      j = valueTwo;
    }
    void Delay_Control(int valueThree) 
    {
      k = valueThree;
    }
    
void draw()
{
  for(i=32; i<=logg.length; i+=35)
        {
          a = float(logg[i]);
          delay(k);
          gainGlide.setValue((a/10000)+b);
          frequencyGlide.setValue((a*b + j)/5);
          println(a);
        }
      }


