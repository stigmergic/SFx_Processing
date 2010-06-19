
long lastBeginning = millis();
long bounceTime = 17000;
long resolveTime = 13300;
long stillTime = 15200;
long flockTime = 60000;


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

boolean isFlockTime() {
  return elapsed() > bounceTime + resolveTime  + stillTime && elapsed() < bounceTime + resolveTime + stillTime + flockTime;       
}

boolean isFinished() {
  return elapsed() > bounceTime + resolveTime + stillTime + flockTime;     
}
