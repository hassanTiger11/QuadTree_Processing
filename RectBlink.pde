/*----------------------------------------------------------------------
|>>> Class statusBar
+-----------------------------------------------------------------------
| I am making this class to keep track of the message and update constntly
+---------------------------------------------------------------------*/
class StatusBar{
  String statusMessage;
  public StatusBar(){
    this("Animation Mode: On | #nodes: 0");
  }
  public StatusBar(String message){
    statusMessage = message;
  }
  void updateMessage(String message){
     statusMessage = message;
  }
  void render(){
    stroke(0);
    fill(0F);
    rect(0, 520, 512, 38);
    textAlign(CENTER);
    if(statusMessage.charAt(0) =='A'){
      
      textSize(20);
      fill(255);
      text(statusMessage, 520/2, (520+ 520+38)/2);
    }else{
      textSize(15);
      fill(255);
      text(statusMessage, 520/2, (520+ 520+38)/2);
    }
    
  }
}

/*----------------------------------------------------------------------
|>>> Class RectBlinkerManager
+-----------------------------------------------------------------------
| Note: You've seen this recently. See the comments there for more info.
+---------------------------------------------------------------------*/
class RectBlinkerManager{
  int defFramePer = 60;
  BlinkInstance[] pool;
  public RectBlinkerManager(){this(10);}
  /**
  I am going to set  blinker for insertion
  */
   public RectBlinkerManager(int poolPop, int r, int g, int b){
    pool = new BlinkInstance[poolPop];
    for (int i=0; i<pool.length; i++){
      pool[i] = new BlinkInstance(new PVector(),new PVector(),-1,-1,1, r, g, b);
    }
  }
  public RectBlinkerManager(int poolPop){
    pool = new BlinkInstance[poolPop];
    for (int i=0; i<pool.length; i++){
      pool[i] = new BlinkInstance(new PVector(),new PVector(),-1,-1,1);
    }
  }
  void updatePool(){for(int i=0; i<pool.length; i++){pool[i].update();}}
  void renderPool(){for (int i=0; i<pool.length; i++){pool[i].render();}}
  void request(int x1, int y1, int x2, int y2, float span){boolean gotAndUsedStaleEntry=false;int numFrames=int(span*60); for(int i=0; i<pool.length; i++){if(pool[i].isExpired()){gotAndUsedStaleEntry=true;pool[i].reset(new PVector(x1,y1), new PVector(x2,y2), frameCount, frameCount+numFrames, defFramePer);break;}}if(!gotAndUsedStaleEntry){println("Warning! Could not find stale entry, did you add too many requests too quickly?");}}
  class BlinkInstance{
    int sFrame;int eFrame;
    int myPer;
    PVector p1, p2;
    boolean expired=true;
    PVector myColor;
    int myStrokeWeight = 2;
    public BlinkInstance(PVector pi1, PVector pi2, int sFr, int eFr, int per){
      p1 = pi1;
      p2 = pi2;
      myPer = per;
      sFrame = sFr;
      eFrame = eFr+(eFr%per);
      myColor = new PVector(0,255,60);
    } 
    /**
    I am going to set  blinker for insertion
    */
    public BlinkInstance(PVector pi1, PVector pi2, int sFr, int eFr, int per, int r, int g, int b){
      p1 = pi1;
      p2 = pi2;
      myPer = per;
      sFrame = sFr;
      eFrame = eFr+(eFr%per);
      myColor = new PVector(r,g,b);
    }
    boolean isExpired(){return expired;} void reset(PVector pi1, PVector pi2, int sFr, int eFr, int per){p1 = pi1;p2 = pi2;myPer = per;sFrame = sFr;eFrame = eFr+(eFr%per);expired=false;this.update();}void update(){if(frameCount>=eFrame){expired=true;}}void render(){if(!expired){float perOff = (frameCount-sFrame)%myPer;perOff = sin((perOff/myPer)*PI)*255;noFill();strokeWeight(myStrokeWeight);stroke(myColor.x,myColor.y,myColor.z,perOff);rect(p1.x,p1.y,p2.x-p1.x,p2.y-p1.y);}}
  }
}
