
class InfoPanel {
  ArrayList lines;
  color backgroundColor = color(0,0,100);
  color textColor = color(255,255,255);
  int textHeight = 17;
  int ymargin = 15;
  int xmargin = 15;
  float x, y, panelwidth, panelheight;

  PFont font;

  public InfoPanel(String fname) {
    super();
    font = loadFont("Chalkboard-48.vlw");

    String [] input = loadStrings(fname);
    lines = new ArrayList();
    for (int i=0; i<input.length; i++) {
      if (i!=0 && i!=input.length-1) lines.add(input[i]);
    }
  }

  void calcGeometry() {
    x =  xmargin;
    y =  ymargin;
    panelwidth = width - 2*xmargin;
    panelheight = height - 2*ymargin;

    if (lines != null) {
      int nheight = (lines.size()+2)*textHeight;
      panelheight = (nheight>height) ? height : (panelheight>nheight) ? panelheight: nheight;
      float nwidth = 0;
      float twidth;
      for (int i=0; i<lines.size(); i++) {
        twidth = textWidth((String)lines.get(i)) + ymargin*2;
        nwidth = max(nwidth,twidth);    
      }      
      panelwidth = (nwidth>width) ? width : (panelwidth>nwidth) ? panelwidth : nwidth;
    }
  }


  void showInfo() {
    textFont(font,textHeight);
    calcGeometry();
    background(0);
    fill(backgroundColor);
    stroke(textColor);
    rect(x,y,panelwidth,panelheight);
    fill(textColor);
    for (int i =0; i<lines.size(); i++) {
      text((String)lines.get(i),x+xmargin,y+ymargin*2+textHeight*i);      
    }
  }
}
