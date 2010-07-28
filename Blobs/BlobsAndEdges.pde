// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA,eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(1);
        stroke(255,255,0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255,0,0);
        fill(255,60);
        rect(
        b.xMin*width,b.yMin*height,
        b.w*width,b.h*height
          );

        int x1 = (int) b.xMin*width;
        int y1 = (int) b.yMin*height;
        int w1 = (int) b.w*width;
        int h1 = (int) b.h*height;

        int x2 = (int) b.xMin*cam.width;
        int y2 = (int) b.yMin*cam.height;
        int w2 = (int) b.w*cam.width;
        int h2 = (int) b.h*cam.height;

        copy(curFrame,x2,y2,w2,h2,x1,y1,w1,h1);
      }
    }
  }
}

