import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*; // openGL for smoother 3D stuffs

import fullscreen.*; // lib for entering fullscreen

HE_Mesh mesh;
HE_Mesh importmesh;
WB_Render render;
HEM_Extrude modifier;

FullScreen fs; // creating fulscreen object

PFont font;

double thickness = 0;
String file;
String[] logg;
float a,b;

void setup()
{
  //size(displayWidth, displayHeight, OPENGL);
  size(1400, 700, OPENGL);
  
   // Create the fullscreen object
  fs = new FullScreen(this); 
  // enter fullscreen mode
  fs.enter();
  
  smooth();
 
  font = loadFont("CourierNewPSMT-12.vlw");
  textFont(font, 12);  
  
  //b = random(200);
}

void draw()
{
  background(223, 223, 223);
  lights();
  
  if (key == '1'){
    thickness = 1;
  }else if(key == '2'){
    thickness = 2;
  }else if(key == '3'){
    thickness = 3;
  }else if(key == '4'){
    thickness = 4;
  }else if(key == '5'){
    thickness = 5;
  }else if(key == '6'){
    thickness = 6;
  }else if(key == '7'){
    thickness = 7;
  }else if(key == '0'){
    thickness = 0;
  }  
  
  float[][] values=new float[11][11];
  for (int j = 0; j < 11; j++) {
    for (int i = 0; i < 11; i++) {
      values[i][j] = (b/2)*noise(0.85*i, 0.35*j);
    }
  }

  HEC_Grid creator=new HEC_Grid();
  creator.setU(10);// number of cells in U direction
  creator.setV(10);// number of cells in V direction
  creator.setUSize(400);// size of grid in U direction
  creator.setVSize(400);// size of grid in V direction
  creator.setWValues(values);// displacement of grid points (W value)
  // alternatively this can be left out (flat grid). values can also be double[][]
  // or and implementation of the WB_Function2D<Double> interface.

 //*********** Modification to surface
  
  modifier = new HEM_Extrude();
  modifier.setDistance(thickness);//extrusion of surface
  modifier.setRelative(false);// treat chamfer as relative to face size or as absolute value
  modifier.setChamfer(5);// chamfer for non-hard edges
  modifier.setHardEdgeChamfer(8);// chamfer for hard edges
  
  mesh=new HE_Mesh(creator);// creating the mesh
  mesh.modify(modifier);// modified version ofmesh
  render=new WB_Render(this);// rendering completion
 
  //directionalLight(255, 255, 255, 1, 1, -1);
  //irectionalLight(127, 127, 127, -1, -1, 1);
  
  fill(110, 110, 110);
  text("KEY FUNCTIONS:", 25, 20);
  fill(110, 110, 110);
  text("Upload data: Press 'u'", 25, 50);
  fill(110, 110, 110);
  text("Thickness Control: Press 1 - 7", 25, 65);
  fill(110, 110, 110);
  text("Export model: Press 'p'", 25, 80 );
  fill(110, 110, 110);
  text("Edge Lining: Press 'e'", 25,  95 );
  
  pushMatrix();
  translate(width/2, height/2, 0);
  float curX = mouseX*1.0f/width*TWO_PI;
  float curY = mouseY*1.0f/height*TWO_PI;
  rotateY(curX);
  rotateX(curY);  
  noStroke();
  fill(100, 163, 243, 200);
  render.drawFaces(mesh);
  
  if(key == 'e'){
   stroke(200, 200, 200);
  render.drawEdges(mesh);
   stroke(255,100,100);
  render.drawBoundaryEdges(mesh);
  }
  popMatrix();
  /*stroke(0);
  render.drawEdges(mesh);
   stroke(255,0,0);
  render.drawBoundaryEdges(mesh);*/
}

void keyPressed()
{
  if(key == 'p')
  {
     //Save mesh to file
  //Simple stereolithography file format, accepted by many 3D programs and 3D printers
  HET_Export.saveToSTL(mesh,sketchPath("surface.stl"),1.0);
  
  //Basic Wavefront OBJ file format, accepted by many 3D programs and 3D printers
  HET_Export.saveToOBJ(mesh,sketchPath("surface.obj")); 
  
  
  //Vertices and indexed face list, connectivity information has to be rebuild on import;
  HET_Export.saveToSimpleMesh(mesh,sketchPath("surface.mesh")); 
  
  //Stores all connectivity information, larger than simple mesh
  HET_Export.saveToHemesh(mesh,sketchPath("surface.hemesh")); 
  
  //Binary compressed version of hemesh
  HET_Export.saveToBinaryHemesh(mesh,sketchPath("surface.binhemesh"));
  
 //Each mesh file format has its corresponding creator.
 HEC_FromSimpleMeshFile fsmf=new HEC_FromSimpleMeshFile().setPath(sketchPath("surface.mesh"));
 HEC_FromHemeshFile fhf=new HEC_FromHemeshFile().setPath(sketchPath("surface.hemesh"));
 HEC_FromBinaryHemeshFile fbhf=new HEC_FromBinaryHemeshFile().setPath(sketchPath("surface.binhemesh"));
 
 importmesh=new HE_Mesh(fbhf);
}

 if( key == 'u' )
  {
     file = selectInput();
     logg = loadStrings(file);
   println(logg);
  for(int m = 32; m <= logg.length; m += 35)
   {
      a = float(logg[m]);
     //delay(600);
     println(a); 
   }
   
  b =(float( logg[32] ) + float(logg[62]) + float(logg[92]) + float(logg[122]) + float(logg[152]) + float(logg[182]) + float(logg[212]) + float(logg[242]) + float(logg[274]) + float(logg[300]))/10 ;
  println("b: " + b/3.5);
  }
}



