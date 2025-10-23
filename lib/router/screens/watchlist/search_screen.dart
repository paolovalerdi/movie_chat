import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:movie_chat/features/watchlist/models/movie.dart';
import 'package:movie_chat/router/screens/watchlist/watchlist_screen.dart';
import 'package:movie_chat/router/screens/watchlist/watchlist_state_holder.dart';
import 'package:movie_chat/state/async_value.dart';
import 'package:movie_chat/widgets/toolbar.dart';

class SearchScreen extends HookWidget {
  const SearchScreen({
    super.key,
    required this.onSearch,
    required this.state,
    required this.onSave,
    required this.onDelete,
    required this.onClose,
  });

  final ValueChanged<String> onSearch;
  final ValueChanged<Movie> onSave;
  final ValueChanged<Movie> onDelete;
  final VoidCallback onClose;
  final SearchState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toolbar.navigation(
          trailing: CupertinoButton(
            onPressed: onClose,
            padding: EdgeInsets.zero,
            child: Icon(LucideIcons.circleX),
          ),
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: CupertinoTextField(
              placeholder: "¿Qué buscamos?",
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white, fontSize: 14),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: Colors.transparent),
              placeholderStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
              ),
              onSubmitted: onSearch,
              // onEditingComplete: onSearch,
            ),
          ),
        ),
        Expanded(
          child: switch (state.searchResults) {
            AsyncValueData<List<Movie>>(data: final movies) => ListView.builder(
              itemCount: movies.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return MovieCard(
                  movie: movies[index],
                  actions: [
                    if (!state.savedMovies.contains(movies[index].imdbId))
                      (Icon(LucideIcons.heart), onSave)
                    else
                      (Icon(LucideIcons.trash2), onDelete),
                  ],
                );
              },
            ),
            AsyncValueLoading<List<Movie>>() => Center(
              child: CupertinoActivityIndicator(),
            ),
            AsyncValueError<List<Movie>>() => Center(child: Text('Error')),
          },
        ),

        // Expanded(child: SearchResults(state, holder)),
      ],
    );
  }
}
