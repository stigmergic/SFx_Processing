
Twitter myTwitter;

void twitterSetup() {
  myTwitter = new TwitterFactory().getInstance("mapsfx", "p4ssw0rd");
}

void readTwitter() {
  try {

    Query query = new Query("mapsfx");
    query.setRpp(100);
    QueryResult result = myTwitter.search(query);

    ArrayList tweets = (ArrayList) result.getTweets();

    for (int i = 0; i < tweets.size(); i++) {
      Tweet t = (Tweet) tweets.get(i);
      String user = t.getFromUser();
      String msg = t.getText();
      Date d = t.getCreatedAt();
      println("Tweet by " + user + " at " + d + ": " + msg);
    };

  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  };
};

