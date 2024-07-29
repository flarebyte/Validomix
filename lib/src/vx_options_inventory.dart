import 'vx_integer_cipher.dart';

/// A class representing a key in the options inventory.
class VxOptionsInventoryKey {
  /// The name of the key.
  final String name;

  /// The list of descriptors associated with the key.
  final List<String> descriptors;

  /// Constructor to create a VxOptionsInventoryKey.
  VxOptionsInventoryKey(this.name, this.descriptors);
}

/// A class representing the options inventory which holds a list of keys.
class VxOptionsInventory {
  final List<VxOptionsInventoryKey> _keys = [];
  final VxIntegerCipher cipher;

  /// Constructor to create a VxOptionsInventory with a given cipher.
  VxOptionsInventory() : cipher = VxIntegerCipher();

  /// Adds a new key to the inventory.
  ///
  /// Throws an exception if a key with the same name already exists.
  /// Returns an encrypted integer index of the added key.
  int addKey(String name, List<String> descriptors) {
    if (_keys.any((key) => key.name == name)) {
      throw Exception('A key with the name "$name" already exists.');
    }
    final key = VxOptionsInventoryKey(name, descriptors);
    _keys.add(key);
    return cipher.encrypt(_keys.indexOf(key));
  }

  /// Retrieves a key from the inventory by its encrypted id.
  ///
  /// Throws a FormatException if the id is invalid.
  VxOptionsInventoryKey getKey(int id) {
    final index = cipher.decrypt(id);
    if (index < 0 || index >= _keys.length) {
      throw FormatException('Invalid id: $id');
    }
    return _keys[index];
  }

  /// Returns all keys in the inventory, sorted by name in ascending order.
  List<VxOptionsInventoryKey> toList() {
    final sortedKeys = List<VxOptionsInventoryKey>.from(_keys)
      ..sort((a, b) => a.name.compareTo(b.name));
    return sortedKeys;
  }
}

/// A key in the options inventory.
class VxOptionsInventoryDescriptors {
  static const string = 'string';
  static const notBlank = 'not-blank';
  static const integer = 'integer';
  static const numeric = 'numeric';
  static const boolean = 'boolean';
  static const positive = 'positive';
  static const stringList = 'string list';
  static const positiveInt = [integer, positive];
}
