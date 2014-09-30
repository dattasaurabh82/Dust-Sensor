import controlP5.*;
import beads.*;

ControlP5 cp5;
AudioContext ac;
WavePlayer wp;
Gain g;
Glide gainGlide;
Glide frequencyGlide;

float a;
int i;
String[] logg;
String file;


void setup()
{
  size(500, 300);
  background(255);
  
  cp5 = new ControlP5(this);
  
  cp5.addButton("Load_logged_file")
     .setValue(0)
     .setPosition(30, 20)
     .setSize(85, 30)
     ;
     
  ac = new AudioContext();
  gainGlide = new Glide(ac, 0.0, 50);
  frequencyGlide = new Glide(ac, 100, 50);
  wp = new WavePlayer(ac, frequencyGlide, Buffer.SAW);
  g = new Gain(ac, 1, gainGlide);
  g.addInput(wp);
  ac.out.addInput(g);
  ac.start();
}

void draw()
{
  for(i=32; i<=logg.length; i+=35)
        {
          a = float(logg[i]);
          delay(2000);
          gainGlide.setValue(a/(float)width);
          frequencyGlide.setValue(a + (height));
          println(a);
        }
      }

void Load_logged_file(int theValue)
    { 
      file = selectInput();
      logg  = loadStrings(file);
      //println(logg);
      /*for(i=32; i<=logg.length; i+=30)
        {
          a = float(logg[i]);
          println(a);
        }
        */
        
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
