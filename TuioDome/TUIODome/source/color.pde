ArrayList colors = new ArrayList();

int getRandomColor() {
  return color(random(255), random(255), random(255), 50);  
}

int getColor(int i) {
  while (colors.size() <= i)  {
    colors.add(new Integer( getRandomColor() ));
  }
  
  return (Integer) colors.get(i);
}

void setColor(int i, int c) {
  while (colors.size() <= i)  {
    colors.add(new Integer( getRandomColor() ));
  }
  
  colors.set(i,c);
}


void randomizeColors() {
  for (int i=0; i<colors.size(); i++) {
    setColor(i, getRandomColor());
  }  
}

