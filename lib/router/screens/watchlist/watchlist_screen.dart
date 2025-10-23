import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:movie_chat/features/watchlist/models/movie.dart';
import 'package:movie_chat/router/screens/watchlist/search_screen.dart';
import 'package:movie_chat/router/screens/watchlist/watchlist_state_holder.dart';
import 'package:movie_chat/service_locator.dart';
import 'package:movie_chat/widgets/toolbar.dart';
import 'package:movie_chat/widgets/widget_utils.dart';
import 'package:provider/provider.dart';

class WatchlistScreen extends HookWidget {
  const WatchlistScreen._();

  static Widget route() {
    return Provider(
      create: (context) => locator<WatchlistStateHolder>(),
      dispose: (context, holder) => holder.dispose(),
      child: WatchlistScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final holder = context.read<WatchlistStateHolder>();
    final state = useValueListenable(holder.state);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF0F221C),
      child: switch (state) {
        WatchlistState() => Column(
          children: [
            Toolbar.navigation(
              trailing: CupertinoButton(
                onPressed: holder.setUpSearch,
                padding: EdgeInsets.zero,
                child: Icon(LucideIcons.search),
              ),
              child: Text('Watchlist'),
            ),
            Expanded(child: MovieList(state, holder)),
          ],
        ),
        SearchState() => SearchScreen(
          state: state,
          onSearch: holder.search,
          onSave: holder.saveMovie,
          onDelete: holder.deleteMovie,
          onClose: holder.setUpWatchlist,
        ),
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget MovieList(WatchlistState state, WatchlistStateHolder holder) {
    if (state.movies.isEmpty) {
      return Center(
        child: Text(
          "No hay películas en la watchlist",
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: state.movies.length,
      separatorBuilder: separator(height: 12),
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return MovieCard(
          movie: movie,
          actions: [(Icon(LucideIcons.trash2), holder.store.delete)],
        );
      },
    );
  }
}

typedef MovieCardAction = (Icon icon, ValueChanged<Movie> action);

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.actions});

  final Movie movie;
  final List<MovieCardAction> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        spacing: 16,
        children: [
          Image.network(
            movie.poster,
            width: 80,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 120,
                color: Colors.white.withValues(alpha: 0.1),
                child: Icon(
                  LucideIcons.image,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              );
            },
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  movie.year,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                Text(
                  movie.imdbId,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          for (final (icon, action) in actions)
            CupertinoButton(
              padding: EdgeInsets.all(12),
              child: icon,
              onPressed: () => action(movie),
            ),
        ],
      ),
    );
  }
}
