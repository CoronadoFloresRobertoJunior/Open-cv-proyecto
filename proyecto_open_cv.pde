import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

color trackColor;
float threshold=25;

 void setup()
 {
   size(640,300);
   String[] cameras=Capture.list();
   printArray(cameras);
   video=new Capture(this, cameras[3]);
   video.start();
   trackColor=color(255,0,0);
 }
 void captureEvent(Capture video)
 {
   video.read();
 }
 void draw()
 {
   video.loadPixels();
   image(video,0,0);
   
   threshold = map(mouseX,0,width,0,100);
  
   float avgX=0;
   float avgY=0;
   
   int count=0;
   
   
   for (int x=0; x<video.width;x++)
   {
     for(int y=0; y<video.height; y++)
     {
       int loc= x+y*video.width;
       color currentColor=video.pixels[loc];
       float r1=red(currentColor);
       float g1=green(currentColor);
       float b1=blue(currentColor);
       float r2=red(trackColor);
       float g2=green(trackColor);
       float b2=blue(trackColor);
       
       float d=dist(r1,g1,b1,r2,g2,b2);
       if(d < threshold)
       {
         stroke(255);
         strokeWeight(1);
         point(x,y);
         avgX+=x;
         avgY+=y;
         count++;
       }
     }
   }
   
   if(count>5)
   {
     avgX=avgX/count;
     avgY=avgY/count;
     
     fill(trackColor);
     strokeWeight(2.0);
     stroke(0);
     ellipse(avgX, avgY, 8,18);
   }
 }
 float distSq(float x1, float y1, float z1, float x2, float y2, float z2) 
 {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
 }
 void mousePressed()
 {
   int loc=mouseX+mouseY*video.width;
   trackColor=video.pixels[loc];
 }