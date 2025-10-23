sealed class AsyncValue<T> {}

final class AsyncValueData<T> extends AsyncValue<T> {
  final T data;

  AsyncValueData({required this.data});
}

final class AsyncValueLoading<T> extends AsyncValue<T> {
  AsyncValueLoading();
}

final class AsyncValueError<T> extends AsyncValue<T> {
  final Object error;

  AsyncValueError({required this.error});
}
