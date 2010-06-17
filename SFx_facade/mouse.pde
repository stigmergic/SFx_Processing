
void mousePressed() {
  if (FOCUSMODES[focus].equals("Mask Mode")) {
    masksMousePressed();  
  } else if (FOCUSMODES[focus].equals("Highlight Mode")) {
    highlights.highLightMousePressed();  
  }
  
  if (is("drawflock")) flock.mousePressed();
    
}
