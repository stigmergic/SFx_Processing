import krister.Ess.*;

AudioChannel bounce;
boolean draggingSlider;
int clickX,sliderX,xOffset;
ArrayList pops = new ArrayList();
ArrayList splashes = new ArrayList();
int nextPop = 0;
int nextSplash = 0;
int numPops = 10, numSplashes = 5;

void setupsound() {
  // start up Ess
  
  Ess.start(this);
  AudioChannel channel;
  String dataDir = sketchPath+"/data/";
  
  for (int i=0; i<numPops; i++) {
  channel=new AudioChannel(dataDir + "15348_Hell_s_Sound_Guy_BUBBLE_POP_.wav");
  pops.add(channel);
  channel=new AudioChannel(dataDir + "19990_acclivity_Glug1.wav");
  pops.add(channel);
  }
  
  for (int i=0; i<numSplashes; i++) {
  channel=new AudioChannel(dataDir + "7054_mystiscool_eel_fishing_2.wav");
  splashes.add(channel);
  }
  
  bounce = new AudioChannel(dataDir + "22012_djgriffin_highbass_bleep.wav");
}

public void pop_sound(float x, float v) {
  AudioChannel myChannel1 = (AudioChannel) pops.get(nextPop);
  nextPop = nextPop+1<pops.size() ? nextPop+1 : 0;
  myChannel1.cue(0);
  myChannel1.pan(2*x-1);
  myChannel1.volume(min(max(v,0.05),0.95));
  myChannel1.play();
}

public void burst_sound(float x) {
  AudioChannel myChannel2 = (AudioChannel) splashes.get(nextSplash);
  nextSplash = nextSplash+1<splashes.size() ? nextSplash + 1 : 0;
  myChannel2.cue(0);  
  myChannel2.pan(2*x-1);
  myChannel2.play();
}

public void bounce_sound(float x) {
  pop_sound(x,0.85);
  bounce.pan(2*x-1);
  bounce.cue(0);
  bounce.volume(0.85);
  bounce.play();
}


public void stop() {
 Ess.stop();
 super.stop();   
}
