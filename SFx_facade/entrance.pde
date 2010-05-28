
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

public void entrance() {
  Entrance e = entrances.get(int(random(entrances.size())));
  for (Letter l : letters) {
    e.position(l);
  }  
}

// -------------------------------------------------

class Entrance {
  void position(Letter l) {
    l.x = width/2;
    l.y = height/2;  
  }  
}

class EntranceBottom extends Entrance{
  void position(Letter l) {
    l.x = random(width);
    l.y = bottom;
    l.dx = 0;
    l.dy = -1;  
  }   
}

class EntranceTop extends Entrance{
  void position(Letter l) {
    l.x = random(width);
    l.y = top;  
  }   
}

class EntranceSides extends Entrance{
  void position(Letter l) {
    l.x = (random(1)<0.5) ? 0 : width;
    l.y = top;  
  }   
}


