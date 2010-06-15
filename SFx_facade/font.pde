
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
  
  for (String name:fontNames) {
      get(name);
  }  
 
  letterFont = randomFont();
}


void setFont() {
  textFont(letterFont.font, textHeight);
}

LetterFont get(String name) {
  LetterFont lf;

  if (!fontMap.containsKey(name)) {
      lf = new LetterFont(name, LETTERBOX);
      fonts.add(lf);
      fontMap.put(name, lf);
      println("adding font: " + name);
  }  
  
  return fontMap.get(name);
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

void apply(Map map) {
  Map<String, Map<String, Object>> fMap = (Map<String, Map<String, Object>>) map;
  LetterFont lf;
  
  for (String name : fMap.keySet()) {
    println("reading font: " + name);
    lf = get(name);
    lf.type = (Integer) (fMap.get(name).get("type"));
  }  
}
}

public class LetterFont {
  PFont font;
  int type;

  public LetterFont(String _name, int _type) {
    font = createFont(_name, 32);
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
  
    map.put("type", type);
  
    return map;  
  }
}
