
PFont ocr = createFont("OCRAStd", 12);
String bannerString = "     \"Mapping The Complex\"    June 17-19     \"Mapping The Complex\"";
float bannerWidth = 100;

void drawBanner() {
  bannerWidth = getX(0.385);
  textFont(ocr, 10);
  String s2 = bannerString + bannerString;
  int i = (int) (ticks/8 % (bannerString.length()));
  int j = s2.length();
  
  String s = s2.substring(i,j);
  float w = textWidth(s);
  
  while (w>bannerWidth) {
    j --;
    s = s2.substring(i,j);
    w = textWidth(s);
  }
  
  text(s, getX(0.3134), getY(0.47));
}
