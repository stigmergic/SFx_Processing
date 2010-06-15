
long lastBeginning = millis();
long bounceTime = 13000;
long resolveTime = 5300;
long stillTime = 7200;


long elapsed() {
  return millis() - lastBeginning;  
}

void reset() {
  lastBeginning = millis();  
}

boolean isBouncing() {
  return elapsed() < bounceTime; 
}

boolean isResolving() {
  return elapsed() > bounceTime && elapsed() < bounceTime + resolveTime;   
}

boolean isStill() {
  return elapsed() > bounceTime + resolveTime && elapsed() < bounceTime + resolveTime + stillTime;   
}

boolean isFinished() {
  return elapsed() > bounceTime + resolveTime + stillTime;     
}
