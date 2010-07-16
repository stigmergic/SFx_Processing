String runname = "test1";
boolean timelapse = false;
long timelapsetime = 10 * 1000;

void timeLapse() {
  if (timelapse) {
    if (!(new File(runname)).exists()) {
       (new File(runname)).mkdirs();
    }
    
    saveFrame(runname + "/" + runname+"-#######.jpg"); 
    try {
      Thread.sleep(timelapsetime);
    } 
    catch (Exception e) {
      println(e);
    }
  }
}
