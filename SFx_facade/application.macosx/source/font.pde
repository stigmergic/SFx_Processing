
int textHeight = 36;
ArrayList<PFont> fonts;
PFont letterFont;

void setupFonts() {
   fonts = new ArrayList<PFont>();
  
  fonts.add(createFont("STXihei", textHeight));
  fonts.add(createFont("AmericanTypewriter-CondensedLight", textHeight));
  fonts.add(createFont("HelveticaNeue-UltraLightItalic", textHeight));
  fonts.add(createFont("EuphemiaUCAS", textHeight));
  fonts.add(createFont("DecoTypeNaskh", textHeight));
  fonts.add(createFont("Cracked", textHeight));
  fonts.add(createFont("Georgia-BoldItalic", textHeight));
  fonts.add(createFont("GiddyupStd", textHeight));
  fonts.add(createFont("OCRAStd", textHeight));
 
  letterFont = randomFont();
}

PFont randomFont() {
 return fonts.get(int(random(fonts.size()))); 
}
