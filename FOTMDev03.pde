/*
 FOTM Dev 03
 Based on FOTM12
 1. Try to draw them same size, in a 4x4 grid. (Done)
 2. Smaller, more of them (done)
 3. Fix the maths so it calculates the grid better (done, for now)
 4. Use a second camera 
 8th Jan 2015  ???
 */

import processing.video.*;

Capture video, video2;

// Objects, 9 x 7 grid
Item[] items = new Item[63];

// Variables
boolean fpsFlag = false;
int[] placesX = new int[items.length]; // var for Xposition of each item on screen
int[] placesY = new int[items.length]; // var for Yposition of each item on screen

// Pimages etc
PImage buf = createImage(960, 540, RGB); // must be same as video grab size
PImage buf2 = createImage(960, 540, RGB); // must be same as video grab size

PImage myMask;

void setup() {

  size(1024, 768);
  frameRate(200);
  // camera debug
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras");
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }

   video2 = new Capture(this, cameras[4]); // external webcam
  video = new Capture(this, cameras[13]); // FaceTime camera

  video.start();
  video2.start();

  while (video.available () == false && video2.available() == false) {
    print(".");
  } 

  // load mask image
  myMask = loadImage("360x270.png");

  video.read(); // grab video
  video2.read();

  // birth the objects
  for (int i=0; i<items.length; i++) {
    items[i] = new Item(i);
  }

  // calculate the rows 
  // get width of available screen (width - 100)
  // get width of item + gap (destWidth + 100)
  //  int colCount = (width-100)/(100+100) ;
  // println(colCount);
  for (int i=0; i<placesX.length; i++) {
    // set the positions here
    placesX[i] = 40 + (i*100)%900;
  }
  println(placesX);

  for (int i=0; i<placesY.length; i++) {
    // set the positions here
    // TOP
    if (i <= 8) { 
      placesY[i] = 50 ;
    } else if (i >8 && i <=17) { 
      placesY[i] = 150 ;
    } else if (i > 17 && i <= 26) {
      placesY[i] = 250;
    } else if (i > 26 && i <= 35) {
      placesY[i] = 350 ;
    } else if (i > 35 && i <= 44) {
      placesY[i] = 450 ;
    } else if (i > 44 && i <= 53) {
      placesY[i] = 550 ;
    } else if (i > 53) {
      placesY[i] = 650 ;
    }
  }
 // println(placesY);
  //noCursor();
}

void draw() {
  background(0);

  for (int i=0; i<items.length; i++) {
    items[i].readVideo(); //put live video into item
    items[i].checkFades(); // calcs alpha and tint
    tint(255, items[i].tintAlpha);   //  adds the alpha  
    items[i].doMask(); // adds the mask
    //   items.compareTo(items);
    items[i].drawItem(); // draws it to canvas
    items[i].manageLifespan(i); // increments life, closes down
  }

  tint(255, 255);

  /* DEBUG */
  // if space bar is down
  // draw whole video image from buffer
  if (keyPressed == true) {
    if (key == ' ') {
      image(buf, 2000, 0, 200, 400 );
      image(buf2, 0, 0, 200, 400);
      fill(250, 0, 0);
      textSize(32);
      text("Full video image", 30, 400);
    }
    if (key == 'f') {
      if (fpsFlag == false) {
        fpsFlag = true;
      } else {
        fpsFlag = false;
      }
    }
  }
  if (fpsFlag == true) {
    fill(250, 0, 0);
    textSize(22);
    text(frameRate, 400, 600);
  }
  //println(places);
}

void captureEvent(Capture c) {
  if (c.available() == true) {
    c.read(); // grab video
    // put live video into the buffer image
    buf = video.get();
    buf2 = video2.get();
  } else {
    println("Capture - NO VIDEO TO GRAB!!!");
  }
}

void mouseReleased() {
  for (int i=0; i<items.length; i++) {
    //    for (int j=0; j<places.length; j++) {
    //     // places[j] = 0;
    //    }
    items[i].populate(i);
  }
  println(frameRate);
}

