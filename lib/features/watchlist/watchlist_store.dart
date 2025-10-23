import 'package:movie_chat/features/watchlist/models/movie.dart';
import 'package:sembast/sembast_memory.dart';

class WatchlistStore {
  WatchlistStore({required Database db}) : _db = db;

  final Database _db;

  final _store = stringMapStoreFactory.store("watchlist");

  Stream<List<Movie>> stream() {
    final query = _store.query();

    return query.onSnapshots(_db).map((snapshot) {
      return List.unmodifiable(
        snapshot.map((record) {
          return Movie.fromJson(record.value);
        }),
      );
    });
  }

  Set<String> getSavedMoviesIds() {
    final query = _store.query();
    return query
        .getSnapshotsSync(_db)
        .map((it) => Movie.fromJson(it.value).imdbId)
        .toSet();
  }

  Future<void> save(Movie movie) {
    return _db.transaction((tx) async {
      await _store.record(movie.imdbId).put(tx, movie.toJson());
    });
  }

  Future<void> delete(Movie movie) {
    return _db.transaction((tx) async {
      await _store.record(movie.imdbId).delete(tx);
    });
  }
}
