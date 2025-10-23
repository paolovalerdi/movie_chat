import 'package:flutter/cupertino.dart';
import 'package:movie_chat/router/screens/watchlist/watchlist_screen.dart';

void gotoWatchlist(BuildContext context) {
  Navigator.push(
    context,
    CupertinoPageRoute(builder: (context) => WatchlistScreen.route()),
  );
}
