import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_chat/features/watchlist/models/movie.dart';
import 'package:movie_chat/features/watchlist/omdb_api.dart';
import 'package:movie_chat/features/watchlist/watchlist_store.dart';
import 'package:movie_chat/state/async_value.dart';

sealed class WatchlistScreenState {}

final class WatchlistState extends WatchlistScreenState with EquatableMixin {
  WatchlistState({required this.movies});

  final List<Movie> movies;

  WatchlistState copyWith({List<Movie>? movies, String? errorMessage}) {
    return WatchlistState(movies: movies ?? this.movies);
  }

  @override
  List<Object?> get props => [movies];
}

final class SearchState extends WatchlistScreenState {
  SearchState({required this.searchResults, this.savedMovies = const {}});

  final AsyncValue<List<Movie>> searchResults;
  final Set<String> savedMovies;

  SearchState copyWith({
    AsyncValue<List<Movie>>? searchResults,
    Set<String>? savedMovies,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      savedMovies: savedMovies ?? this.savedMovies,
    );
  }
}

final class WatchlistStateHolder {
  WatchlistStateHolder({required this.store, required this.api}) {
    setUpWatchlist();
  }

  final WatchlistStore store;
  final OMDBApi api;

  StreamSubscription? subscription;
  final state = ValueNotifier<WatchlistScreenState>(WatchlistState(movies: []));

  void setUpSearch() {
    state.value = SearchState(
      searchResults: AsyncValueData(data: []),
      savedMovies: {},
    );
    subscription?.cancel();
    subscription = null;
  }

  void setUpWatchlist() {
    subscription = store.stream().listen((movies) {
      state.value = WatchlistState(movies: movies);
    });
  }

  Future<void> search(String query) async {
    final s = state.value;
    if (s is! SearchState) return;
    if (s.searchResults is AsyncValueLoading) return;

    state.value = SearchState(searchResults: AsyncValueLoading());
    try {
      final results = await api.searchMovies(query);
      state.value = SearchState(
        searchResults: AsyncValueData(data: results),
        savedMovies: store.getSavedMoviesIds(),
      );
    } catch (e) {
      state.value = SearchState(searchResults: AsyncValueError(error: e));
    }
  }

  Future<void> saveMovie(Movie movie) async {
    final s = state.value;
    if (s is! SearchState) return;

    await store.save(movie);
    state.value = s.copyWith(savedMovies: store.getSavedMoviesIds());
  }

  Future<void> deleteMovie(Movie movie) async {
    await store.delete(movie);

    if (state.value is SearchState) {
      state.value = (state.value as SearchState).copyWith(
        savedMovies: store.getSavedMoviesIds(),
      );
    }
  }

  void dispose() {
    subscription?.cancel();
  }
}
