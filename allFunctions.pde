/*----------------------------------------------------------------------
|>>> Class Point
+-----------------------------------------------------------------------
| Purpose: Basic Point representation of which effectively encapsulates
|          a PVector as to provide additional support for console log,
|          selection flag, value equality, and 'within rect?' queries.
+---------------------------------------------------------------------*/
class Point{
  PVector pt;
  boolean isSelected = false; // is this point selected?
  float   ptSize = 10;        // size of the ellipse drawn for this point
  color   sCol;               // color is selected
  color   uCol;               // color if unselected
  
  public Point(PVector p){
    pt = p;    
    sCol = color(255,120,0);
    uCol = color(0,120,255);
  }
  
  // Used to Console log xor String return representation of this point 
  void toConsole(){println("("+int(pt.x)+","+int(pt.y)+")");}
  String toString(){return "("+int(pt.x)+","+int(pt.y)+")";}
  
  // Sets the point to selected, which means it's colored differently. One way to ID certain points!
  void setSelected(boolean val){isSelected = val;}
  
  // Is this point equal in value to another Point/PVector? Note int casts JIC of float comparison issues
  boolean equalTo(Point oth){
    if(oth == null){return false;}
  return ((int(oth.pt.x)==int(pt.x))&&(int(oth.pt.y)==int(pt.y)));}  
  boolean equalTo(PVector oth){return ((int(oth.x)==int(pt.x))&&(int(oth.y)==int(pt.y)));  }
  boolean isInRange(Point oth){return int(oth.pt.x) <= int(pt.x)+2 || int(oth.pt.x) >= int(pt.x) - 2
                                 && int(oth.pt.y) <= int(pt.y)+2 || int(oth.pt.y) >= int(pt.y) - 2
                                 ;
  }
  // Is this point within bounds defined as: b[0=x1 , 1=y1 , 2=x2 , 3=y2]
  boolean isWithin(int[] b){
  System.out.println("isWithin: ("+b[0]+", "+b[1]+") ("+b[0]+", "+b[1]+")");
  return (pt.x>=b[0] && pt.x<b[2] && pt.y>=b[1] && pt.y<b[3]) ? true : false; }
  
  void render(){
    stroke(60);strokeWeight(1);
    if(isSelected){fill(sCol);}else{fill(uCol);}
    ellipse(pt.x,pt.y,ptSize,ptSize);
  }
}


/*----------------------------------------------------------------------
|>>> Function execInputCommandsDFrame
+-----------------------------------------------------------------------
| Purpose: Executes command parsed from the input every specified number
|          of frames, until all input commands were processed. Control
|          is then provided to the user for manual mouse-pressed based
|          insertion of points.
+---------------------------------------------------------------------*/
boolean cmdsDone = false;
int curCmd = 0;        // current input command that has been processed
float frameSpeed = 15; // run new input command on each frame specified here
float frameDelay = 0;  // frames to wait before starting the animation

QuadTree tree;
void execInputCommandsDFrame(){
  if(!cmdsDone && curCmd == commands.length){
    cmdsDone=true;
    enableUserInsert=true;
    statusBar.updateMessage("Animation Mode: Off | #nodes: "+ tree.head.size);
    println("> All Input Commands have been processed!");
  }
  else if(!cmdsDone && (curCmd != commands.length) && (frameCount>=frameDelay) && (frameCount%frameSpeed==0)){
    executeCommand(commands[curCmd]);
    curCmd++;
    statusBar.updateMessage("Animation Mode: On | #nodes: "+ tree.head.size);
  }
}


/*----------------------------------------------------------------------
|>>> Function executeCommand
+-----------------------------------------------------------------------
| Purpose: Runs command specified by input Command object via calling
|          the corresponding 'Command Handler' via switch statement on
|          the command's char ID. Pretty slick, eh?
+---------------------------------------------------------------------*/
void executeCommand(Command cmd){
  switch(cmd.id){
    case 'Q': cmd_SetRange(cmd.args); break;
    case 'i': cmd_Insert(cmd.args); break;
    case 'd': cmd_Delete(cmd.args); break;
    case 'r': cmd_Report(cmd.args); break;
    case 'c': cmd_Count(cmd.args); break;
    case 'e': cmd_Empty(cmd.args); break;    
  }
}


/*----------------------------------------------------------------------
|>>> Command Handler Functions
+-----------------------------------------------------------------------
| Purpose: These functions are mostly defined WRT the demo application
|          of points on the canvas; but some of them might be useful for
|          the Quadtree-based versions you will implement (e.g. Report,
|          Count, Empty, and OutputPts). As these definitions are mostly
|          trivial or effectively stubs, there's no need to thoroughly
|          comment on them, though you're welcome to ask questions.
+---------------------------------------------------------------------*/
void cmd_SetRange(int[] args){
  pointsRange = args[0];
  tree = new QuadTree(args[0]);
}

void cmd_Insert(int[] args){
  points.add(new Point(new PVector(args[0],args[1])));
  tree.insert(args[0], args[1]);
}

void cmd_Delete(int[] args){
 Point removedPoint = tree.delete(args[0],args[1]);
 for(int i=0; i< points.size(); i++){
   if(points.get(i).equalTo(removedPoint)){
      points.remove(i);
      i+=1;
   }
 }
  PVector query = new PVector(args[0],args[1]);
  Point qPt = null;
  for(Point p : points){if (p.equalTo(query)){qPt=p;break;}}
  if(qPt != null){points.remove(qPt);selectedPts.remove(qPt);}
  println("> This simulates deleting a point within your QT (OPTIONAL)");  
}

void cmd_Report(int[] args){ 
  
  tree.report(args[0],args[1],args[2],args[3]);
  
  rbm.request(args[0],args[1],args[2],args[3],3);
}

int cmd_Count(int[] args){
  
  int numNodes = tree.count(args[0],args[1],args[2],args[3]);
  countingRBM.request(args[0],args[1],args[2],args[3],3);
  return numNodes;
}

void cmd_Empty(int[] args){  
  tree.e(args[0],args[1],args[2],args[3]);
  rbm.request(args[0],args[1],args[2],args[3],3);
}

void cmd_OutputPts(){
  println("> This simulates end-of-program reporting of all points within QT to output (see output.txt!)");
  toOutput(">>> Hi There! Here are all the points!");
  for(Point p : points){toOutput("  o Reporting Data Point: "+p.toString());}
}
