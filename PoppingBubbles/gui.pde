PFont bFont;

ArrayList buttons = new ArrayList();

int infoX, infoY, infoWidth, infoHeight;
int xmargin,ymargin;
int fontSize;
int border;

void mousePressed() {
    Button b;
  if (showButtons)
  for (int i=0;i<buttons.size();i++) {
    b = (Button) buttons.get(i);
    
    if (b.inButtonBound(mouseX, mouseY))
        b.pressed();
  }  

}

void guiSetup() {
  infoX = max(150,width/16);
  infoY = max(50,height/16);
  infoWidth = min(100,width/16*14);
  infoHeight = min(100,height/16*14);
  xmargin = 12;
  ymargin = 6;
  fontSize = 12;
  border = 3;
  
  bFont = loadFont("Chalkboard-24.vlw");
  createButtons();  
}



void createButtons() {
  Button b;
  Action a;
  
  b = new Button() {
    public void update() {
      if ((tintHighlite & COLOR)>0) 
        active = true;
       else active = false; 
    }
  };  
  a = new Action() {
     public void doActiveAction() {
       tintHighlite = tintHighlite | COLOR;
     }
     public void doInactiveAction() {
       tintHighlite = tintHighlite & (~COLOR);       
     }
  };
  b.setup(infoX+xmargin,infoY+(ymargin+b.bHeight)*1, "COLOR",a);
  buttons.add(b);
  
  b = new Button() {
    public void update() {
      if ((tintHighlite & RED)>0) 
        active = true;
       else active = false; 
    }
  };  
  a = new Action() {
     public void doActiveAction() {
       tintHighlite = tintHighlite | RED;
     }
     public void doInactiveAction() {
       tintHighlite = tintHighlite & (~RED);       
     }
  };
  b.setup(infoX+xmargin,infoY+(ymargin+b.bHeight)*2, "RED",a);
  buttons.add(b);
  
  b = new Button() {
    public void update() {
      if ((tintHighlite & GREEN)>0) 
        active = true;
       else active = false; 
    }
  };  
  a = new Action() {
     public void doActiveAction() {
       tintHighlite = tintHighlite | GREEN;
     }
     public void doInactiveAction() {
       tintHighlite = tintHighlite & (~GREEN);       
     }
  };
  b.setup(infoX+xmargin,infoY+(ymargin+b.bHeight)*3, "GREEN",a);
  buttons.add(b);
  
  b = new Button() {
    public void update() {
      if ((tintHighlite & BLUE)>0) 
        active = true;
       else active = false; 
    }
  };  
  a = new Action() {
     public void doActiveAction() {
       tintHighlite = tintHighlite | BLUE;
     }
     public void doInactiveAction() {
       tintHighlite = tintHighlite & (~BLUE);       
     }
  };
  b.setup(infoX+xmargin,infoY+(ymargin+b.bHeight)*4, "BLUE",a);
  buttons.add(b);

}

void drawButtons() {
  fill(100,100);
  noStroke();
  rect(infoX,infoY,infoWidth,infoHeight);
  Button b;
  for (int i=0;i<buttons.size();i++) {
    b = (Button) buttons.get(i);
    b.display();    
  }  
}

//------------------------------- Class Definitions -----------------------------

class Action {
  void doActiveAction() {
    println("Do action..."); 
  } 
  void doInactiveAction() {
    println("Don't do action...");
  }
}


class Button {
  boolean active = true;
  Action action = null;
  int xpos;
  int ypos;
  int bWidth = 10;
  int bHeight = 10;
  int totalWidth;
  int totalHeight;
  String buttonLabel;

  void setup(int newX, int newY, String newLabel, Action newAction) {
    xpos = newX;
    ypos = newY;
    buttonLabel = newLabel;
    action = newAction;
    textFont(bFont, fontSize);
    totalWidth = bWidth + 4 + round(textWidth(buttonLabel));
    totalHeight = bHeight;


  }

  boolean inButtonBound(float x, float y) {
    if ((x >= xpos - border) && (y >= ypos - border) && (x <= xpos + totalWidth + border) && (y <= ypos + totalHeight + border))
      return true;
    else
      return false;
  }

  void pressed() {
    active = !active;
    if (active && (action != null)) 
      action.doActiveAction();
    if (!active && (action != null))
      action.doInactiveAction();  
  }
  
  void update() {
    //do nothing by default
  }

  void display() {
    update();   
    if (inButtonBound(mouseX, mouseY)) {
      stroke(255,100);
      fill(255,100);
    } else {
      stroke(150,100);
      fill(150,100);
    }
    
    rect(xpos-border, ypos-border, totalWidth+border*2, totalHeight+border*2);
    fill(200,200);
    textFont(bFont, fontSize);
    text(buttonLabel, xpos + bWidth + 4, ypos + 10);
     if (active)
      fill(255);
    else
      fill(0);
    rect(xpos, ypos, bWidth, bHeight);

  } 
  
}

class OnceButton extends Button {
  void pressed() {
    action.doActiveAction();
  }  

  void display() {
      
    if (inButtonBound(mouseX, mouseY)) {
      stroke(255,100);
      fill(255,100);
    } else {
      stroke(150,100);
      fill(150,100);
    }
    
    rect(xpos-3, ypos-3, totalWidth+6, totalHeight+6);
    fill(200,200);
    textFont(bFont, fontSize);
    text(buttonLabel, xpos + 4, ypos + 10);
  } 


}

//---------------------------------- SCROLLBAR -------------------------------------------------
class Scrollbar
{
  /*
  Based on:
  // Scrollbar
 // by REAS <http://reas.com>

  */
    int sLength, sSize;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // x position of slider
  int sposMin, sposMax;   // max and min values of slider
  float loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  boolean vert;
  float minVal,maxVal;
  Scrollbars parent;

  Scrollbar (int xp, int yp, int sl, int ss, float miv, float mav, boolean _vert) {
    vert = _vert;
    sLength = sl;
    sSize = ss;
    maxVal = mav;
    minVal = miv;

    if (vert) {
      xpos = xp - sSize/2;
      ypos = yp;
      spos = ypos + sLength/2 - sSize/2;
      newspos = spos;
      sposMin = ypos;
      sposMax = ypos + sLength - sSize;

    } 
    else {
      xpos = xp;
      ypos = yp-sSize/2;
      spos = xpos + sLength/2 - sSize/2;
      newspos = spos;
      sposMin = xpos;
      sposMax = xpos + sLength - sSize;
    }
  }

  void update() {
    if(over()) {
      over = true;
    } 
    else {
      over = false;
    }
    if(mousePressed && over && !parent.barlocked) {
      locked = true;
      parent.barlocked = true;
    }
    if(!mousePressed) {
      if (locked) {
        parent.barlocked = false;
        locked = false;
      }
    }
    if(locked) {
      if (vert) {
        setPos(mouseY-sSize/2);
      } 
      else {
        setPos(mouseX-sSize/2);
      }
    }
    }

  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean over() {
    if (vert) {
      if(mouseX > xpos && mouseX < xpos+sSize &&
        mouseY > ypos && mouseY < ypos+sLength) {
        return true;
      }

    } 
    else {
      if(mouseX > xpos && mouseX < xpos+sLength &&
        mouseY > ypos && mouseY < ypos+sSize) {
        return true;
      }
    }
    return false;
  }

  void draw() {
    fill(255);
    stroke(0);
    if (vert) {
      rect(xpos, ypos, sSize, sLength);

    } 
    else {
      rect(xpos, ypos, sLength, sSize);
    }
    if(over || locked) {
      fill(153, 102, 0);
    } 
    else {
      fill(102, 102, 102);
    }
    if (vert) {
      rect(xpos, spos, sSize, sSize);

    } 
    else {
      rect(spos, ypos, sSize, sSize);
    }
  }

  void setPos(float pos) {
    spos = constrain((int)pos, sposMin, sposMax);
  }

  float getPos() {
    // convert spos to be values between
    // 0 and the total width of the scrollbar
    if (vert) return (spos - ypos) * ((float)sLength/(float)(sLength-sSize));
    return (spos - xpos) * ((float)sLength/(float)(sLength-sSize)) ;
  }
  
  float getVal() {
    return (getPos())/(float)sLength*(maxVal-minVal) + minVal;  
  }
  
  void setVal(float f) {
    f = min(max(f,maxVal),minVal);
    float pos = (f - minVal)/(maxVal-minVal)*((float)sLength);
    setPos(pos);  
  }
}

//----------------------------------- Scrollbars ------------------------
class Scrollbars {
  ArrayList bars = new ArrayList();
  boolean barlocked = false;
  
  void createBar(int xp, int yp, int sl, int ss, float miv, float mav, boolean _vert){
    Scrollbar t = new Scrollbar(xp, yp, sl, ss, miv, mav, _vert);  
    t.parent = this;
    bars.add(t);
  }
  
  void update() {
    Scrollbar t;
    for (int i=0; i<bars.size(); i++) {
      t = (Scrollbar) bars.get(i);
      t.update();
      t.draw();
    }  
  }
  
  float getVal(int i) {
    return getScrollbar(i).getVal();  
  }
  
  Scrollbar getScrollbar(int i) {
   return (Scrollbar) bars.get(i);  
  }
  
  void setVal(int i, float val) {
    getScrollbar(i).setVal(val);  
  }
    
}


//----------------------------------- FileChooser -----------------------

class ListChooser {
  Scrollbars scrolls;
  boolean visible = false;
  int x,y,clength,cheight;
  int barwidth = 10;
  PFont font;
  String[] lines;
  int textHeight = 20;
  int margin = 5;
  int itemchoice = 0;
  Button cancel,ok;
  ChooserCallback callback = new ChooserCallback();
  boolean buttonpress = false;
  
  public ListChooser(int _x, int _y, int _length, int _height) {
    font = loadFont("Monaco-16.vlw");
    x = _x;
    y = _y;
    clength = _length;
    cheight = _height-textHeight;
    scrolls = new Scrollbars();
    scrolls.createBar(x+clength-barwidth/2, y, cheight, barwidth, 0, 1.0, true);
    scrolls.setVal(0,0);
    bFont  = loadFont("Chalkboard-20.vlw");
    cancel = new OnceButton();
    cancel.setup(x+margin,y+cheight+5,"Cancel", new Action() {
      void doActiveAction() { 
        if (callback!=null) callback.cancel(); 
      }
    }
    );
    ok = new OnceButton();
    ok.setup(x+margin+clength-barwidth-30,y+cheight+5,"Ok", new Action() {
      void doActiveAction() { 
        if (callback!=null) callback.ok(getSelection()); 
      }
    }
    );
  }

  void update() {
    if (mousePressed) {
      if (over()) {

        itemchoice = getRowOver() + getOffset();
      }
      if (cancel.inButtonBound(mouseX,mouseY) && !buttonpress) {
        buttonpress = true;
        cancel.pressed();
      }
      if (ok.inButtonBound(mouseX,mouseY) && !buttonpress) {
        buttonpress = true;
        ok.pressed();
      }         
    } else {
      buttonpress = false;  
    }

    draw();  
    scrolls.update();
    ok.display();
    cancel.display();    
  }

  boolean over() {
    if (mouseX > x && mouseX < x+clength-barwidth && mouseY > y && mouseY < y+cheight) {
      return true;
    }
    return false;
  }

  int getNumLines() {
    return min((cheight-textHeight/2) / textHeight, lines.length);
  }

  int getOffset() {
    int unseen = (lines.length - getNumLines());
    int offset;
    if (unseen<1) { 
      offset = 0; 
    } 
    else {
      offset = (int) (unseen * scrolls.getVal(0));
    }
    return offset;    
  }


  int getRowOver() {
    if (over()) {
      int my = mouseY - y - textHeight/2;
      int nl = getNumLines();
      int rnum = ((int)my/textHeight);
      return (rnum > nl-1) ? -1 : (rnum < 0) ?  -1 : rnum;   
    }
    return -1;
  }

  String getLine(int row) {
    return lines[row+getOffset()];
  }

  String getSelection() {
    if (itemchoice>=0) return lines[itemchoice];
    return "";
  }

  void draw() {
    float val = scrolls.getVal(0);
    fill(0,200);
    rect(x,y,clength,cheight+textHeight);
    fill(255,200);
    rect(x,y,clength-barwidth,cheight);

    textFont(font);
    fill(0,200);
    for (int i = 0; i<getNumLines(); i++) {
      text(getLine(i), x + margin,y+(i+1)*textHeight+textHeight/2);
    }
    int row = getRowOver();
    if (row>=0) {
      fill(0,0,100,100);
      rect(x,y+row*textHeight+textHeight/2,clength-barwidth,textHeight);
    }

    int itemchoiceOff = itemchoice - getOffset();
    if (itemchoiceOff >= 0 && itemchoiceOff < getNumLines()) {
      fill(0,100,0,100);
      rect(x,y+itemchoiceOff*textHeight+textHeight/2,clength-barwidth,textHeight);

    }
  }  
}

class ChooserCallback {
  void ok(String result) {
    println("User chose: " + result);  
  }  
  void cancel() {
    println("Cancel...");
  }
}

