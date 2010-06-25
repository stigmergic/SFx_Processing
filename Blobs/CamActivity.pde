
void movement() {    
    int movementSum = 0; // Amount of movement in the frame
    curFrame.loadPixels();
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = cam.pixels[i];
      color prevColor = previousFrame[i];
      curFrame.pixels[i] = cam.pixels[i];
      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      // Add these differences to the running tally
      movementSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      diffImage.pixels[i] = color(diffR, diffG, diffB);
      // The following line is much faster, but more confusing to read
      //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
      // Save the current color into the 'previous' buffer
      previousFrame[i] = currColor;
    }
    // To prevent flicker from frames that are all black (no movement),
    // only update the screen if the image has changed.
    if (movementSum > 0) {
      diffImage.updatePixels();
      curFrame.updatePixels();
      println(movementSum + " frameRate: " + frameRate); // Print the total amount of movement to the console
    }
  }

