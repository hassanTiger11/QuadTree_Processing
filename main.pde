/**This file contains the implementation of a Quadtree application
press 'a' to stop the animation
After the animation is done:
press 'i' to insert a point
press 'd' to delete a point
press 'c' to count the number of node in a box
press 'r' to report the points inside a box
*/
PrintWriter writer;
RectBlinkerManager rbm;
RectBlinkerManager insertionRBM;
RectBlinkerManager countingRBM;
RectBlinkerManager deletionRBM;


StatusBar statusBar;
static String filename_IN  = "input.txt";
static String filename_OUT = "output.txt"; 
Command[] commands;
boolean enableUserInsert = false; // can't add points until input commands processed


// Declarations for Demo
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Point> selectedPts = new ArrayList<Point>();
int pointsRange = -1; // should [must] be set by processing 'Q' command!


//  the PrintWriter, RBM
void setup(){
  size(512,550);
  writer = createWriter(filename_OUT);
  rbm = new RectBlinkerManager();
  insertionRBM = new RectBlinkerManager(10, 0, 0, 255);
  countingRBM = new RectBlinkerManager(10, 0, 0, 0);
  deletionRBM = new RectBlinkerManager(10, 255, 0, 0);
  statusBar = new StatusBar();
  commands = parseCommands(getInput(filename_IN));  
  toOutput(">>> Setup Complete");
}

void draw(){ 
  // UI CALLS
    
  // DELTA LOGIC
  rbm.updatePool();
  insertionRBM.updatePool();
  countingRBM.updatePool();
  deletionRBM.updatePool();
  execInputCommandsDFrame();
  // VIZ
  background(255); 
  for(Point pt : points){pt.render();}
  rbm.renderPool();
  insertionRBM.renderPool();
  countingRBM.renderPool();
  deletionRBM.renderPool();
  statusBar.render();
  
}


int x=1;
boolean insertMode = false;
boolean reportMode = false;
boolean countMode = false;
boolean isEmptyMode = false;
boolean deleteMode = false;
void keyPressed(){
  // Note how I'm using this to do the final output of all points + close the file
  if(keyCode == ESC){
    cmd_OutputPts();
    closeWriter();
  }else if (key == 'a'){
    if(x%2==0){
      loop();
      x+=1;
    }else{
      statusBar.updateMessage("Animation Mode: Off | #nodes: "+ tree.head.size);
      x+=1;
      noLoop();
    }
  }
  else if(key == 'r'){
    insertMode= false;
    countMode = false;
    isEmptyMode = false;
    reportMode = true;
    statusBar.updateMessage("Reporting Mode: On| #nodes: "+ tree.head.size);
    
  }
  else if(key =='i'){
    reportMode = false;
    countMode = false;
    isEmptyMode = false;
    insertMode= true;
    statusBar.updateMessage("Insertion Mode: On| #nodes: "+ tree.head.size);
    
  }
  else if(key == 'c'){
    insertMode = false;
    reportMode = false;
    isEmptyMode = false;
    countMode = true;
    statusBar.updateMessage("Counting Mode: On| #nodes: "+ tree.head.size);
  }
  else if(key== 'e'){
    insertMode = false;
    reportMode = false;
    countMode = false;
    isEmptyMode = true;
  }else if(key == 'd'){
    insertMode = false;
    reportMode = false;
    countMode = false;
    isEmptyMode = false;
    deleteMode = true;
    statusBar.updateMessage("Deleteion Mode: On| #nodes: "+ tree.head.size);
  }
}


int reportClickTimes =0;
int[] mousePos = new int[4];
// Note how I'm double-dipping the Insert Command code for manual input too!
void mousePressed(){
  if(insertMode){
    cmd_Insert(new int[]{int(mouseX),int(mouseY)});
    statusBar.updateMessage("Insertion Mode: On| #nodes: "+ tree.head.size);
    
  }else if(reportMode){
    
    if(mousePressed){
      reportClickTimes+=1;
      if(reportClickTimes == 1 ){
        mousePos[0] = mouseX;
        mousePos[1] = mouseY;
        System.out.println("REPORTING: ("+mousePos[0]+", "+mousePos[1]+")");
      }else if(reportClickTimes ==2){
        mousePos[2] = mouseX;
        mousePos[3] = mouseY;
        reportClickTimes= 0;
        System.out.println("REPORTING: ("+mousePos[2]+", "+mousePos[3]+")");
        cmd_Report(mousePos);
      }
    }
  }
  else if(countMode){
    
      reportClickTimes+=1;
      if(reportClickTimes == 1 ){
        mousePos[0] = mouseX;
        mousePos[1] = mouseY;
        System.out.println("REPORTING: ("+mousePos[0]+", "+mousePos[1]+")");
      }else if(reportClickTimes ==2){
        mousePos[2] = mouseX;
        mousePos[3] = mouseY;
        reportClickTimes= 0;
        System.out.println("REPORTING: ("+mousePos[2]+", "+mousePos[3]+")");
        int numNodes = cmd_Count(mousePos);
        statusBar.updateMessage("Counting Mode: On| #nodes: "+ tree.head.size+" | #node in Box: "+ numNodes);

      }
  }else if (isEmptyMode){
      reportClickTimes+=1;
      if(reportClickTimes == 1 ){
        mousePos[0] = mouseX;
        mousePos[1] = mouseY;
        System.out.println("REPORTING: ("+mousePos[0]+", "+mousePos[1]+")");
      }else if(reportClickTimes ==2){
        mousePos[2] = mouseX;
        mousePos[3] = mouseY;
        reportClickTimes= 0;
        System.out.println("REPORTING: ("+mousePos[2]+", "+mousePos[3]+")");
        cmd_Empty(mousePos);
      }
  }
  else if(deleteMode){
    cmd_Delete(new int[]{mouseX, mouseY});
    statusBar.updateMessage("Deleteion Mode: On| #nodes: "+ tree.head.size);
  }
}
