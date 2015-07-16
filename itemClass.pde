// it's a video circle item

class Item implements Comparable {

  // variables
  PImage itemImage; // the item's bit of video image
  PImage tempMask; // this item's mask
  int myBuf; // buf or buf2?
  float alpha; // this items' alpha
  int destWidth;
  int destHeight;
  int sourceWidth;
  int sourceHeight;
  int myX; // initial locations, widths and heights of the items
  int myY;
  int destX;
  int destY;
  int place;
  int lifespan;
  boolean beingBorn; // to control fade in
  int tintAlpha;

  // birth the object
  Item(int i) {
    this.populate(i);
  }

  // populate with characteristics
  void populate(int j) {


    if (random(10) > 5.0) {
      myBuf = 1;
    } else {
      myBuf = 2;
    }
    destWidth = 100; 
    destHeight = int(destWidth*0.75); // maintain 4:3 ratio
    sourceWidth = int(random(100)+15); // +5 to keep it above zero
    // sourceHeight = int(sourceWidth*0.5625); // maintain 4:3 ratio
    sourceHeight = int(sourceWidth*0.75); // maintain 4:3 ratio

    //    println("Sourcewidth = " + sourceWidth);
    //    int var1 = video.width-sourceWidth;
    //    println("Video - sourcewidth " + var1);
    //    int var2 = sourceWidth;
    //    println("SourceWidth/2 = " + var2);
    //    int myFinalVar = var1 + var2;
    //    println("Max possible width =  = " + myFinalVar);

    myX = int(random(video.width-sourceWidth)); // sourceX //<>//
    //    println("myX = " + myX);
    //    println("myX + sourceWidth = " + (myX+sourceWidth));
    //    println("video.width = " + video.width);
    //    println("-------------------------------");



    myY = int(random(video.height-sourceHeight)); // sourceY


    // this mitigates against clipping 
    // (because sourceHeight is calculated, not measured)
    //    if (myY > (video.height-300)) {    
    //      myY = (video.height-300);
    //    }

    // test to ensure no clipping // NOT WORKING
    //    if (sourceWidth > (video.width-myX)) {
    //      sourceWidth = video.width-myX;
    //    }


    // destX = int(random(640))+320; // where on the canvas its drawn
    /*  int testNum = int(random(places.length));   // position in places
     int testPlace = places[testNum];           // value at position testNum (1 or 0)
     while (testPlace == 1) {
     testNum = int(random(places.length)); 
     testPlace = places[testNum];
     }
     places[testNum] = 1;
     place = testNum;
     destX = 300+ (20* place);
     */
    destX = placesX[j];
    destY = placesY[j];

    /*
    needs to :
     // randomly pick a position in an array that's longer than the items list
     // if it's unoccupied, occupy it (=1)
     // if not, keep trying
     // destX= 30 * that position
     // on death, give up that position (= 0)
     */


    alpha =  250; // lower maybe?
    lifespan = int(random(2000)+200);

    tintAlpha = 0;
    beingBorn = true;

    // put live video into the buffer image

      buf = video.get();
    buf2 = video2.get();
    //put live video into the items 
    if (myBuf ==1) {
      itemImage = buf.get(myX, myY, sourceWidth, sourceHeight);
    } else {
      itemImage = buf2.get(myX, myY, sourceWidth, sourceHeight);
    }
    // copy over the mask image for this item
    tempMask = myMask.get();
    // resize mask to draw size
    tempMask.resize(destWidth, destHeight);
  }

  // grab video into my itemImage
  void readVideo() {
    if (this.myBuf == 1) {
      this.itemImage = buf.get(this.myX, this.myY, this.sourceWidth, this.sourceHeight);
    } else {
      this.itemImage = buf2.get(this.myX, this.myY, this.sourceWidth, this.sourceHeight);
    }
  }

  void checkFades() {
    // if its just been born, fade in
    if (this.beingBorn == true) {
      if (this.tintAlpha < this.alpha) {
        this.tintAlpha = this.tintAlpha+1;
      } else {
        this.beingBorn = false;
      }
    }

    // if it's nearly dead, start to fade it out
    if (this.lifespan < 200) {
      this.beingBorn = false;
      this.tintAlpha = this.tintAlpha-1;
    }
  }

  void doMask() {
    // add a mask 
    if (this.itemImage.width >0 && this.itemImage.height > 0) {
      this.itemImage.resize(this.destWidth, this.destHeight); // resize item image
      this.itemImage.mask(this.tempMask); // add mask
    }
  }

  void drawItem() {

    // this draws to canvas

    image(this.itemImage, this.destX, this.destY, this.destWidth, this.destHeight);
  }

  void manageLifespan(int i) {
    // This reduces the lifespan of the item
    this.lifespan = this.lifespan-1;
    // if it is dead, rebirth it
    if (this.lifespan < 0) {
      // places[place] = 0;
      this.populate(i); //// this needs to just change
    }
  }

  //if we want to sort based on the X value of MyObj-es:
  int compareTo(Object items)
  {
    Item other=(Item)items;
    if (other.alpha>alpha)  
      return -1;
    if (other.alpha==alpha)
      return 0;
    else
      return 1;
  }
}

