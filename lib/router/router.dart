import 'package:flutter/cupertino.dart';
import 'package:movie_chat/router/screens/account/feedback_screen.dart';
import 'package:movie_chat/router/screens/watchlist/watchlist_screen.dart';

void gotoWatchlist(BuildContext context) {
  Navigator.push(
    context,
    CupertinoPageRoute(builder: (context) => WatchlistScreen.route()),
  );
}

void gotoFeedback(BuildContext context) {
  Navigator.push(
    context,
    CupertinoPageRoute(builder: (context) => FeedbackScreen.route()),
  );
}
