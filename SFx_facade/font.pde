
Fonts fonts;

public class Fonts {
ArrayList<LetterFont> fonts;
HashMap<String, LetterFont> fontMap;

LetterFont letterFont;
int currentFont = 0;
int textHeight = 36;

  int LETTERBOX = 0;
  int NOLETTERBOX = 1;
  int CIRCLES = 2;
  int CIRCLES_AND_DROP = 3;
  int DROPSHADOW = 4;
  int FIRST_LETTER_TYPE = LETTERBOX;
  int LAST_LETTER_TYPE = DROPSHADOW;



String[] fontNames = {
  "AmericanTypewriter-CondensedLight",
"HelveticaNeue-UltraLightItalic",
"EuphemiaUCAS",
"Cracked",
"Georgia-BoldItalic",
"OCRAStd",
"LithosPro-Black",
"AmericanTypewriter-Bold",
"Apple-Chancery",
"AppleCasual",
"Chalkboard-Bold",
"CooperBlackStd",
"HoboStd",
"StencilStd"
};

public Fonts() {
  fonts = new ArrayList<LetterFont>();
  fontMap = new HashMap<String, LetterFont>();
  
  LetterFont lf;
  for (String name:fontNames) {
      lf = new LetterFont(name, LETTERBOX);
      fonts.add(lf);
      fontMap.put(name, lf);
  }  
 
  letterFont = randomFont();
}

void setFont() {
  textFont(letterFont.font, textHeight);
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

Map represent() {
  HashMap<String, Map<String, Object>> map = new HashMap<String, Map<String, Object>>();
  for (String name : fontMap.keySet()) {
    map.put(name, fontMap.get(name).represent());  
  }  
  return map;
}
}

public class LetterFont {
  String name;
  PFont font;
  int type;
  

  

  public LetterFont(String _name, int _type) {
    name = _name;
    font = createFont(name, 32);
    type = _type;
  }  
  
  public boolean isDrawBox() {
    return type == fonts.LETTERBOX;  
  }
  
  public boolean isDropShadow() {
    return type == fonts.DROPSHADOW || type == fonts.CIRCLES_AND_DROP;  
  }
  
  public boolean isCircles() {
   return (type == fonts.CIRCLES) || (type == fonts.CIRCLES_AND_DROP); 
  }
  
  public String getName() {
    return font.getName();  
  }
  
  public void incrType() {
      type += 1;
      if (type>fonts.LAST_LETTER_TYPE) type = fonts.FIRST_LETTER_TYPE;
  }
  
  public Map<String, Object> represent() {
    HashMap<String, Object> map = new HashMap<String, Object>();
  
    map.put("name", name);
    map.put("type", type);
  
    return map;  
  }
}
