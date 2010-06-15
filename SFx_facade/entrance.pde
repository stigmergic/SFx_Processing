
float top;
float bottom;

ArrayList<Entrance> entrances;

public void setupEntrances() { 
  top = 70;
  bottom = 460;
 
  entrances = new ArrayList<Entrance>();
  
  entrances.add(new Entrance());
  entrances.add(new EntranceBottom());
  entrances.add(new EntranceTop());
  entrances.add(new EntranceSides());
}

public void randomEntrance() {
  Entrance e = entrances.get(int(random(entrances.size())));
  //Entrance e = entrances.get(3);
  
  for (Letter l : letters) {
    e.position(l);
  }  
}

// -------------------------------------------------

class Entrance {
  
  void position(Letter l) {
    l.x = getX(0.5);
    l.y = getY(0.25);
    l.a = 0;
    l.da = 0;
    
    float f = random(2*PI);
    l.dx = cos(f);
    l.dy = sin(f); 
    l.curVel = 5; 
  }  
}

class EntranceBottom extends Entrance{
  void position(Letter l) {
    super.position(l);
    l.x = random(width);
    l.y = bottom;
    
    float f = random(PI);
    l.dx = cos(f);
    l.dy = sin(f);  
  }   
}

class EntranceTop extends Entrance{
  void position(Letter l) {
    super.position(l);

    l.x = random(width);
    l.y = top;  
    
    float f = random(PI) + PI;
    l.dx = cos(f);
    l.dy = sin(f);
  }   
}

class EntranceSides extends Entrance{
  void position(Letter l) {
    super.position(l);

    float f = random(PI/2);
    if  (random(1)<0.5) {
      l.x = getX(0.0208);
      f = -f;
      l.dx = cos(f);
      l.dy = sin(f);  
    } else {
      l.x = getX(0.9835);
      l.dx = cos(f + PI);
      l.dy = cos(f + PI);
    }
    l.y = getY(0.2660);  
    l.curVel = 5;
    l.ndx = 0;
    l.ndy = 0;
    l.nn = 0;
  }   
}


