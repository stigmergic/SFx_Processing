class MyBlob {
  ArrayList edges = new ArrayList();
  float xMin,xMax,yMin,yMax;

  public MyBlob(Blob b) {
    xMin = b.xMin;
    yMin = b.yMin;
    xMax = b.xMax;
    yMax = b.yMax;
    EdgeVertex eA,eB;
    for (int m=0;m<b.getEdgeNb();m++)
    {
      eA = b.getEdgeVertexA(m);
      eB = b.getEdgeVertexB(m);
      addEdge(new MyEdge(eA,eB));  
    }      

  }
  float centerX() { return (xMin+xMax)/2; }
  float centerY() { return (yMin+yMax)/2; }   
  Location center() { return new Location(centerX(), centerY()); }
  float width() { return (xMax-xMin); }
  float height() { return (yMax -yMin); }
  MyEdge getEdge(int i) {
    if (i>=0 && i<edges.size()) return (MyEdge) edges.get(i);
    return null;  
  }   
  void addEdge(MyEdge edge) { edges.add(edge); }
  int numEdges() { return edges.size(); }
}

class MyEdge {
  float x1,y1,x2,y2;
  public MyEdge(EdgeVertex eA, EdgeVertex eB) {
        x1 = eA.x;
        y1 = eA.y;
        x2 = eB.x;
        y2 = eB.y;
  }
}
