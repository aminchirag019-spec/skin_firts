String getConversationId(String user1, String user2) {
  if (user1.compareTo(user2) > 0) {
    return "${user1}_$user2";
  } else {
    return "${user2}_$user1";
  }
}