
void fastthresh(PImage img,int thresh){

  int w=img.width;
  int h=img.height;
  int x,y,yp;

  int[] pix=img.pixels;


  for (y=0;y<h;y++){
    yp = y * img.width;
    for (x=0;x<w;x++){

      pix[yp+x] = color(0);
    }
  }

}

void fastthresh(PImage img){

  int w=img.width;
  int h=img.height;
  int x,y,yp;

  int[] pix=img.pixels;

  float cval;
  
  for (y=0;y<h;y++){
    yp = y * img.width;
    for (x=0;x<w;x++){
      cval = red(pix[yp+x]) + blue(pix[yp+x]) + green(pix[yp+x]);
      cval = cval < 0 ? 0 : cval > 255 ? 255 : cval;
      

      pix[yp+x] = color(cval, cval, cval);
    }
  }

}
void fastred(PImage img){

  int w=img.width;
  int h=img.height;
  int x,y,yp;

  int[] pix=img.pixels;

  float cval;
  
  for (y=0;y<h;y++){
    yp = y * img.width;
    for (x=0;x<w;x++){
      cval = red(pix[yp+x])*1.5 - blue(pix[yp+x]) - green(pix[yp+x]);
      cval = cval < 0 ? 0 : cval > 255 ? 255 : cval;
      
      pix[yp+x] = color(cval*4, cval/2, cval/2);
    }
  }

}
void fastgreen(PImage img){

  int w=img.width;
  int h=img.height;
  int x,y,yp;

  int[] pix=img.pixels;

  float cval;
  
  for (y=0;y<h;y++){
    yp = y * img.width;
    for (x=0;x<w;x++){
      cval = -red(pix[yp+x]) - blue(pix[yp+x]) + green(pix[yp+x])*2;
      cval = cval < 0 ? 0 : cval > 255 ? 255 : cval;

      pix[yp+x] = color(cval/2, cval*4, cval/2);
    }
  }

}
void fastblue(PImage img){

  int w=img.width;
  int h=img.height;
  int x,y,yp;

  int[] pix=img.pixels;

  float cval;
  
  for (y=0;y<h;y++){
    yp = y * img.width;
    for (x=0;x<w;x++){
      cval = -red(pix[yp+x]) + blue(pix[yp+x]) - green(pix[yp+x]);
      cval = cval < 0 ? 0 : cval > 255 ? 255 : cval;
      

      pix[yp+x] = color(cval/2, cval/2, cval*4);
    }
  }

}
