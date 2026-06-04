/// An abstract interface for a simple key-value storage system.
abstract class BaseKeyValueStore {
  String? get(String key);

  /// Returns a [Future<bool>] that completes with true if the write was
  /// successful, and false otherwise.
  Future<bool> write(String key, String value);

  Future<bool> remove(String key);

  Future<bool> clear();
}
