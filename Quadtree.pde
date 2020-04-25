
/**
This class is required by the spec
It stores the information of a rectangle, which stores two points, bottomLeft and upperRight

*/
class Rectangle{
  Point bottomLeft, upperRight;
  public Rectangle(int x1, int y1, int x2, int y2){
    bottomLeft = new Point(new PVector(x1,y1));
    upperRight = new Point(new PVector(x2,y2));
  }
  public Rectangle(PVector bottomLEFT, PVector upperRIGHT){
    bottomLeft = new Point(bottomLEFT);
    upperRight = new Point(upperRIGHT);
  }
  public PVector getBottomLeft(){
    return this.bottomLeft.pt;
  }
  public PVector getUpperRight(){
    return this.upperRight.pt;
  }
  public PVector getMiddlePoint(){
    return new PVector((getBottomLeft().x+getUpperRight().x)/2, (getBottomLeft().y+getUpperRight().y)/2);
  }
  /**
  This method returns whether the rectangle contains a point*/
  public boolean contains(PVector point){
    if(point.x > bottomLeft.pt.x && point.y > bottomLeft.pt.y){
      if(point.x < upperRight.pt.x && point.y < upperRight.pt.y){
        return true;
      }
    }
    return false;
  }
  /**
  this method returns if the rectangle contians another*/
  public boolean contains(Rectangle other){
    return contains(other.getBottomLeft()) && contains(other.getUpperRight());
  }
  public boolean isDisjoint(Rectangle other){
    if(this.bottomLeft.pt.x > other.upperRight.pt.x
    ||this.upperRight.pt.x < other.bottomLeft.pt.x
    ||this.upperRight.pt.y < other.bottomLeft.pt.y
    ||this.bottomLeft.pt.y > other.upperRight.pt.y){
      return true;
    }
    return false;
  }
  public String toString(){
    return "("+bottomLeft.toString()+","+ upperRight.toString()+")";
  }
}

/**
This class builds the quadtree. 
The quadtree is a huge quad of 2^30 points. If an outer node is inserted,
then we will have to split the quad into four quads
*/
class QuadTree{
  
/**
This class stores info for the Quadtree node.
The quadtree node is a blank node unless it is a leaf.
A leaf only stores one point
*/
class QTNode{
  
  Rectangle myRect;
  Point myPoint;
  int size;
  String QTNodeType; //EMPTY, NONEMPTY, INTERNAL
  QTNode nw;
  QTNode ne;
  QTNode sw;
  QTNode se;
  
  public QTNode(PVector bottomLeft, PVector upperRight){
    nw = null; 
    ne = null; 
    sw = null; 
    se = null; 
    size=0;
    QTNodeType = "EMPTY";
    myRect = new Rectangle(bottomLeft, upperRight);
    this.myPoint=null;
  }
  public QTNode(PVector bottomLeft, PVector upperRight, String type){
    nw = null; 
    ne = null; 
    sw = null; 
    se = null; 
    size=0;
    QTNodeType = type;
    myRect = new Rectangle(bottomLeft, upperRight);
    this.myPoint=null;
  }
  public QTNode(){
    nw = null; 
    ne = null; 
    sw = null; 
    se = null; 
    this.size=0;
    QTNodeType = "EMPTY";
    myRect = null;
    this.myPoint=null;
  }
  /**
  This method sets the NW node
  @param QTNode nw
  */
  public void setNW(QTNode nw){
  this.nw = nw;
  }
  /**
  This method sets the ne node
  @param QTNode nw
  */
  public void setNE(QTNode ne){
  this.ne = ne;
  }
  /**
  This method sets the ne node
  @param QTNode nw
  */
  public void setSW(QTNode sw){
  this.sw = sw;
  }
  /**
  This method sets the ne node
  @param QTNode nw
  */
  public void setSE(QTNode se){
  this.se = se;
  }
  /**
  This method returns the quadrant's point
  @return PVector*/
  public PVector getMyPoint(){return this.myPoint.pt;}
  public Point getPoint(){return this.myPoint;}
  /**
  This method returns the bottomLeft point
  @return PVector*/
  public PVector getBottomLeft(){return this.myRect.getBottomLeft();}
  /**
  This method returns the quadrant's point
  @return PVector*/
  public PVector getUpperRight(){return this.myRect.getUpperRight();}
  /**
  This method returns the quadrant's point
  @return PVector*/
  public PVector getMiddlePoint(){return this.myRect.getMiddlePoint();}
  public Rectangle getRectangle(){return this.myRect;}
  /**
  This method returns a reference to nw
  @retrurn QTNode*/
  public QTNode getNW(){return this.nw;}
  /**
  This method returns a reference to nw
  @retrurn QTNode*/
  public QTNode getNE(){return this.ne;}
  /**
  This method returns a reference to nw
  @retrurn QTNode*/
  public QTNode getSW(){return this.sw;}
  /**
  This method returns a reference to nw
  @retrurn QTNode*/
  public QTNode getSE(){return this.se;}
  /**
  This method returns the type of the node*/
  public String getNodeType(){return this.QTNodeType;}
  /**
  This method sets the QTNodeType
  */
  public void setMyType(String type){this.QTNodeType = type;}
  public void setMyPoint(PVector point){
    if(point == null){
      this.myPoint = null;
    }else{
      this.myPoint = new Point(point);
    }
  }
    
  
  // Used to Console log xor String return representation of this point 
  String toString(){
    if(QTNodeType == "EMPTY"){
      return "Empty Qadrant between: "+myRect.toString();
    } 
    else if(QTNodeType == "NONEMPTY"){
      return "NonEmpty Qadrant contain:"+ myPoint.toString()+"\tbetween: "+ myRect.toString();
    }
    return "Internal Quadrant"+ "\n"+nw.toString()+"\n"+ ne.toString()+ "\n"+ sw.toString()+"\n"+ se.toString();
  }
  
  /**
  This method checks if a point is inside this node's bounds
  @param PVector point*/
  boolean contains(PVector point){
   
    return myRect.contains(point);
  }
  /**
  This method returns whether this is a leaf node or an internal
  @return boolean
  */
  boolean isLeaf(){
    return this.nw == null && this.ne == null 
    && this.sw == null && this.se == null;
  }
  
 
}

QTNode head;
PrintWriter writer;
/**
  this method instantiate this object with one node
  @param int l- as in the spec*/
  public QuadTree(int l){
    System.out.println("\n-----------------------------QuadTree ("+l+", "+l+")----------------------------\n");
    writer = createWriter("output.txt");
    head = new QTNode(new PVector(0,0), new PVector(l,l));

    
  }
  /**
  This method adds a point to the quadtree.
  As we add a point we have to devide the head into four regions
  first, check if the point is inside the bounds
  This method still doesn't update the .size appropraiately
  */
  public void insert(int x1, int y1){
    System.out.println("\n----------------------------INSERTING("+x1+", "+ y1+")------------------------------------\n");
    PVector point = new PVector(x1, y1);
    insertHelper(point, this.head);
  }
  
  public void insertHelper(PVector point, QTNode node){
    
   
    if(!node.contains(point)){
      //System.out.println("InsertHelper: point not included: "+ point.toString());
      toOutput("Visting Node (("+node.getBottomLeft().x+", "+node.getBottomLeft().y+"), ("+ node.getUpperRight().x+", "+ node.getUpperRight().y+"))");
      return;
    }
    //when the first node has just been instantiated
    if(node.getNodeType().equals("EMPTY")){
      insertionRBM.request(int(node.myRect.bottomLeft.pt.x), int(node.myRect.bottomLeft.pt.y), int(node.myRect.upperRight.pt.x), int(node.myRect.upperRight.pt.y), 1);
      //System.out.println("InsertHelper: Empty node: "+head.toString()+" , point: "+ point.toString());
      toOutput("Visting Node (("+node.getBottomLeft().x+", "+node.getBottomLeft().y+"), ("+ node.getUpperRight().x+", "+ node.getUpperRight().y+"))");
      node.setMyPoint(point);
      node.size=1;
      node.QTNodeType = "NONEMPTY";
      return;
    }
    //The node only has one point. and I need to make it 'INTERNAL'
    //I need to caluculate the mid point and set each of the old point and the new point in its wuadrant
    else if(node.getNodeType().equals("NONEMPTY")){
      //System.out.println("InsertHelper: visiting node: "+head.toString()+" , point: "+ point.toString());
      toOutput("\nVisting Node (("+node.getBottomLeft().x+", "+node.getBottomLeft().y+"), ("+ node.getUpperRight().x+", "+ node.getUpperRight().y+"))");
      PVector midPoint = node.getMiddlePoint();
      PVector oldPoint = node.getMyPoint();
      node.size+=1;
      node.setMyType("INTERNAL");
      node.setMyPoint(null);
      //initialize the four sub quadrants
      node.setNW(new QTNode( new PVector(node.getBottomLeft().x, midPoint.y), new PVector(midPoint.x, node.getUpperRight().y)));
      node.setNE(new QTNode( new PVector(midPoint.x, midPoint.y), new PVector(node.getUpperRight().x, node.getUpperRight().y) ));
      node.setSW(new QTNode( new PVector(node.getBottomLeft().x, node.getBottomLeft().y), new PVector(midPoint.x, midPoint.y) ));
      node.setSE(new QTNode( new PVector(midPoint.x, node.getBottomLeft().y), new PVector(node.getUpperRight().x, midPoint.y) ));
      
      //decide which qudrant we should recurse through
      
      insertHelper(oldPoint,node.getNW());
      insertHelper(oldPoint,node.getNE());
      insertHelper(oldPoint,node.getSW());
      insertHelper(oldPoint,node.getSE());
      
      insertHelper(point,node.getNW());
      insertHelper(point,node.getNE());
      insertHelper(point,node.getSW());
      insertHelper(point,node.getSE());
    }
    //internal
    else{
        node.size+=1;
        insertHelper(point,node.getNW());
        insertHelper(point,node.getNE());
        insertHelper(point,node.getSW());
        insertHelper(point,node.getSE());
    }
  }
  
  /**
  This method reports the points that are bound by a certain rectangle.
  The rectangle could cover one node or multiple
  we should only use toOutput to report the nodes that we visit and the nodes that we report
  @param Rectangle rect
  */
  public void report(int x1, int y1, int x2, int y2){
    System.out.println("\n----------------------------REPORTING AT(("+x1+", "+ y1+") ("+x2+", "+y2+")------------------------------------\n");
    Rectangle rect = new Rectangle(x1, y1, x2, y2);
    reportHelper (rect, this.head);
  }
  
  private void reportHelper(Rectangle reportingRect, QTNode node){
    if(node == null){
    //System.out.println("reportHelper: null node");
    return;
    }
    //Disjoint 
    else if(reportingRect.isDisjoint(node.getRectangle())){
      //System.out.println("reportHelper: disjoint with rect: "+ node.getRectangle().toString());
      return;
    }
    //fully contained
    else if(reportingRect.contains(node.getRectangle())){
      //System.out.println("reportHelper: Fully contained");
      //System.out.println("reportHelper: visting: "+ node.getRectangle().toString());
      toOutput("Visiting quadrant"+ node.getRectangle().toString());
      
      if(node.isLeaf()){
        if(node.getNodeType().equals("EMPTY")){
         // System.out.println("reportHelper: Empty");
          return;
        }
        //System.out.println("reportHelper: found: "+ node.getPoint().toString());
        toOutput("++Reporting data-point"+ node.getPoint().toString());
        println("Reporting Data Point: "+node.getPoint().toString());
      }else{
        reportHelper(reportingRect, node.nw);
        reportHelper(reportingRect, node.ne);
        reportHelper(reportingRect, node.sw);
        reportHelper(reportingRect, node.se);  
      }
      return;
    }
    //System.out.println("reportHelper: not completely contained: "+ node.getRectangle().toString());
    toOutput("Visiting quadrant"+ node.getRectangle().toString());
    if(node.isLeaf()){
      if(node.getNodeType().equals("EMPTY")){
        //System.out.println("reportHelper: node has no points ");
      }
      else if(reportingRect.contains(node.getMyPoint())){
        //System.out.println("reportHelper: found: "+ node.getPoint().toString());
        toOutput("Reporting data-point"+ node.getPoint().toString());
        println("Reporting Data Point: "+node.getPoint().toString());
      }
       return;
    }
    reportHelper(reportingRect, node.nw);
    reportHelper(reportingRect, node.ne);
    reportHelper(reportingRect, node.sw);
    reportHelper(reportingRect, node.se);   
  }
  /**
  This method counts the number of points included inside the query rectangle
  if visited a node it reports it as: 'Visiting quadrant'
  if a point is bound by the rect: 'Checking data-point'*/
  public int count(int x1, int y1, int x2, int y2){
    System.out.println("\n----------------------------COUNTING AT(("+x1+", "+ y1+") ("+x2+", "+y2+")------------------------------------\n");
    int count =0;
    Rectangle queryRect = new Rectangle(x1, y1, x2, y2);
    count = countHelper(queryRect, head);
    System.out.println("There are "+count+" points in the region [("+x1+", "+y1+"),("+x2+", "+y2+")]");
    return count;
  }
  private int countHelper(Rectangle reportingRect, QTNode node){
    if(node == null){
    //System.out.println("countHelper: null node");
    return 0;
    }
    //Disjoint 
    else if(reportingRect.isDisjoint(node.getRectangle())){
      //System.out.println("countHelper: disjoint with rect: "+ node.getRectangle().toString());
      return 0 ;
    }
    //fully contained
    else if(reportingRect.contains(node.getRectangle())){
      toOutput("Visiting quadrant"+ node.getRectangle().toString()); 
      return node.size;
    }
    toOutput("Visiting quadrant"+ node.getRectangle().toString());
    if(node.isLeaf()){
      if(node.getNodeType().equals("EMPTY")){
       // System.out.println("reportHelper: node has no points ");
        return 0;
      }
      else if(reportingRect.contains(node.getMyPoint())){
        toOutput("Checking data-point"+ node.getPoint().toString());
        return 1;
      }
       
    }
    return 0+
    countHelper(reportingRect, node.nw)+
    countHelper(reportingRect, node.ne)+
    countHelper(reportingRect, node.sw)+
    countHelper(reportingRect, node.se);   
  }
  /**
  This method retuns a boolean whether the query rectangle contains any points
  */
  public boolean e(int x1, int y1, int x2, int y2){
    System.out.println("\n-----------------------CHECKING EMPTY ? (("+x1+", "+y1+")("+x2+", "+y2+"))--------------------------\n");
    boolean containsAny = false;
    Rectangle queryRec = new Rectangle(x1,y1,x2,y2);
    containsAny = eHelper(queryRec, head);
    if (containsAny){
      System.out.println("Status: Not Empty");
    }else{
      System.out.println("Status: Empty");
    }
    return containsAny;
  }
  private boolean eHelper(Rectangle reportingRect, QTNode node){
    if(node == null){
    //System.out.println("eHelper: null node");
      return false;
    }
    //Disjoint 
    else if(reportingRect.isDisjoint(node.getRectangle())){
      //System.out.println("countHelper: disjoint with rect: "+ node.getRectangle().toString());
      return false;
    }
    //fully contained
    else if(reportingRect.contains(node.getRectangle())){
      toOutput("Visiting quadrant"+ node.getRectangle().toString()); 
      return true;
    }
    toOutput("Visiting quadrant"+ node.getRectangle().toString());
    if(node.isLeaf()){
      if(node.getNodeType().equals("EMPTY")){
       // System.out.println("reportHelper: node has no points ");
        return false;
      }
      else if(reportingRect.contains(node.getMyPoint())){
        toOutput("Checking data-point"+ node.getPoint().toString());
        return true;
      }
       
    }
    return 
    eHelper(reportingRect, node.nw)||
    eHelper(reportingRect, node.ne)||
    eHelper(reportingRect, node.sw)||
    eHelper(reportingRect, node.se);   
  }
  /**
  this methid deletes a point in the quadtree
  */
  public Point delete(int x, int y){
    System.out.println("\n----------------------------DELETING("+x+", "+ y+")------------------------------------\n");
    PVector point = new PVector(x, y);
    return deleteHelper(point, head);
  }
  public Point deleteHelper(PVector point, QTNode node){
      if(node.getNodeType().equals("EMPTY")){
        return null;
      }
      if(!node.contains(point)){
        toOutput("Visting Node (("+node.getBottomLeft().x+", "+node.getBottomLeft().y+"), ("+ node.getUpperRight().x+", "+ node.getUpperRight().y+"))");
      return null;
    }
    //The node only has one point. and I need to make it 'INTERNAL'
    //I need to caluculate the mid point and set each of the old point and the new point in its wuadrant
    else if(node.getNodeType().equals("NONEMPTY")){
      System.out.println("DeleteHelper: visiting node NONEEMPTY: "+node.getBottomLeft()+", "+ node.getUpperRight()+" , point: "+ point.toString());
      
      if(node.myPoint.isInRange(new Point(point))){
        deletionRBM.request(int(node.myRect.bottomLeft.pt.x), int(node.myRect.bottomLeft.pt.y), int(node.myRect.upperRight.pt.x), int(node.myRect.upperRight.pt.y), 1);
        System.out.println("DeleteHelper: visiting node: I am delting: "+ node.myPoint.toString());
        toOutput("\nVisting Node (("+node.getBottomLeft().x+", "+node.getBottomLeft().y+"), ("+ node.getUpperRight().x+", "+ node.getUpperRight().y+"))");
        Point returnPoint = node.myPoint;
        node.myPoint = null;
        node.QTNodeType = "EMPTY";
        node.size-=1;
        return returnPoint;
      }
      return null;
      
    }
    //internal
    else{
        
        Point removedPoint = null;
        Point nw = deleteHelper(point,node.getNW());
        Point ne = deleteHelper(point,node.getNE());
        Point sw = deleteHelper(point,node.getSW());
        Point se = deleteHelper(point,node.getSE());
        if(nw!= null){
          node.size-=1;
          return nw;
        }else if(ne!= null){
          node.size-=1;
          return ne;
        } else if(sw!= null){
          node.size-=1;
          return sw;
        }else  if(se!= null){
          node.size-=1;
          return se;
        }
        node.size-=1;
        return removedPoint;
    }
  }
  
  public String toString(){
    return head.toString();
  }
  void toOutput(String s){
  writer.println(s);
  writer.flush(); // here in case program is closed without hitting 'q' or 'ESC' keys
}
}
/**
void setup(){
  QuadTree tree = new QuadTree(512);
   System.out.println(tree);
   
   tree.insert(new PVector(100,100));
   tree.insert(new PVector(203,193));
   tree.insert(new PVector(13,132));
   tree.insert(new PVector(194, 451));
   Rectangle rec = new Rectangle(0,0,250,500);
   tree.report(0,0,250,500);
   System.out.println("tree count: "+tree.count(0,0,250,500));
   System.out.println("rec contain a point: "+ tree.e(600,600,700,700));
   System.out.println("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+tree+"\nsize: "+ tree.head.size);
  
}*/
