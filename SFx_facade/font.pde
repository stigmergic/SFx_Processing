
int textHeight = 36;
ArrayList<LetterFont> fonts;
LetterFont letterFont;
int currentFont = 0;

int LETTERBOX = 0;
int NOLETTERBOX = 1;
int CIRCLES = 2;
int CIRCLES_AND_DROP = 3;
int DROPSHADOW = 4;
int FIRST_LETTER_TYPE = LETTERBOX;
int LAST_LETTER_TYPE = DROPSHADOW;

void setupFonts() {
   fonts = new ArrayList<LetterFont>();

  fonts.add(new LetterFont("AmericanTypewriter-CondensedLight", LETTERBOX));
  fonts.add(new LetterFont("HelveticaNeue-UltraLightItalic", LETTERBOX));
  fonts.add(new LetterFont("EuphemiaUCAS", LETTERBOX));
  fonts.add(new LetterFont("Cracked", LETTERBOX));
  fonts.add(new LetterFont("Georgia-BoldItalic", LETTERBOX));
  fonts.add(new LetterFont("OCRAStd", LETTERBOX));
  fonts.add(new LetterFont("LithosPro-Black", LETTERBOX));
  fonts.add(new LetterFont("AmericanTypewriter-Bold", LETTERBOX));
  fonts.add(new LetterFont("Apple-Chancery", LETTERBOX));
  fonts.add(new LetterFont("AppleCasual", LETTERBOX));
  fonts.add(new LetterFont("Chalkboard-Bold", LETTERBOX));
  fonts.add(new LetterFont("CooperBlackStd", LETTERBOX));
  fonts.add(new LetterFont("HoboStd", LETTERBOX));
  fonts.add(new LetterFont("MesquiteStd", LETTERBOX));
  fonts.add(new LetterFont("StencilStd", LETTERBOX));
  
  //fonts.add(createFont("GiddyupStd", textHeight));
 
  letterFont = randomFont();
}


LetterFont randomFont() {
 currentFont = int(random(fonts.size()));
 return fonts.get(currentFont); 
}

LetterFont nextFont() {
  currentFont += 1;
  if (currentFont>=fonts.size()) currentFont = 0;
  
  return fonts.get(currentFont);
}

public class LetterFont {

  PFont font;
  int type;
  

  public LetterFont(String name, int _type) {
    font = createFont(name, 36);
    type = _type;
  }  
  
  public boolean isDrawBox() {
    return type == LETTERBOX;  
  }
  
  public boolean isDropShadow() {
    return type == DROPSHADOW || type == CIRCLES_AND_DROP;  
  }
  
  public boolean isCircles() {
   return (type == CIRCLES) || (type == CIRCLES_AND_DROP); 
  }
  
  public String getName() {
    return font.getName();  
  }
  
  public void incrType() {
      type += 1;
      if (type>LAST_LETTER_TYPE) type = FIRST_LETTER_TYPE;
  }
}
