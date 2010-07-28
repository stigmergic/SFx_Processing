
PFont ocr = createFont("OCRAStd", 12);
//String bannerString = "     \"Mapping The Complex\"    June 17-19 2010    \"Mapping The Complex\"";
String bannerString = "                                                                   Bon   Voyage   Paige    and     Randy!!!!!!!!!!!                     ";
float bannerWidth = 100;
float movingBannerX = width/2, movingBannerY = height/2;

color bannerColor = color(255,0,0);

void setupBanner() {
  bannerWidth = getX(0.385);
  movingBannerX = getX(0.3134);
  movingBannerY = getY(0.47) ; 
}

void drawBanner() {
  fill(bannerColor);
  textFont(ocr, 16);
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
  
  text(s, movingBannerX, movingBannerY);
}
