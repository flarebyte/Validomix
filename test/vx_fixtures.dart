import 'dart:collection';

import 'package:validomix/validomix.dart';

/// A class providing example rules for testing purposes.
class VxRuleFixtures {
  /// Creates an example rule that validates non-empty strings.
  ///
  /// This rule returns an error if the string is empty.
  static VxBaseRule<String> nonEmptyRule() {
    return _NonEmptyRule();
  }

  /// Creates an example rule that validates email format.
  ///
  /// This rule returns an error if the string is not in a valid email format.
  static VxBaseRule<String> emailRule() {
    return _EmailRule();
  }

  /// Creates an example rule that validates minimum length.
  ///
  /// This rule returns an error if the string's length is less than [minLength].
  static VxBaseRule<String> minLengthRule(int minLength) {
    return _MinLengthRule(minLength);
  }
}

class _NonEmptyRule extends VxBaseRule<String> {
  @override
  List<String> validate(Map<String, String> options, String value) {
    if (value.isEmpty) {
      return ['Value cannot be empty'];
    }
    return [];
  }
}

class _EmailRule extends VxBaseRule<String> {
  @override
  List<String> validate(Map<String, String> options, String value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return ['Invalid email format'];
    }
    return [];
  }
}

class _MinLengthRule extends VxBaseRule<String> {
  final int minLength;

  _MinLengthRule(this.minLength);

  @override
  List<String> validate(Map<String, String> options, String value) {
    if (value.length < minLength) {
      return ['Value must be at least $minLength characters long'];
    }
    return [];
  }
}

/// A class providing static methods for generating iterables for testing.
class IterableFixtures {
  // Prevents instantiation of the class.
  IterableFixtures._();

  /// Generates a List of strings with `n` items.
  static List<String> createStringList(int n) {
    return List<String>.generate(n, (index) => 'String $index');
  }

  /// Generates a List of integers with `n` items.
  static List<int> createIntList(int n) {
    return List<int>.generate(n, (index) => index);
  }

  /// Generates a LinkedList of strings with `n` items.
  static LinkedList<StringNode> createStringLinkedList(int n) {
    LinkedList<StringNode> linkedList = LinkedList<StringNode>();
    for (int i = 0; i < n; i++) {
      linkedList.add(StringNode('String $i'));
    }
    return linkedList;
  }

  /// Generates a LinkedList of integers with `n` items.
  static LinkedList<IntNode> createIntLinkedList(int n) {
    LinkedList<IntNode> linkedList = LinkedList<IntNode>();
    for (int i = 0; i < n; i++) {
      linkedList.add(IntNode(i));
    }
    return linkedList;
  }

  /// Generates a List of Maps with `n` items.
  static List<Map<String, String>> createMapList(int n) {
    return List<Map<String, String>>.generate(
        n, (index) => {'key': 'value $index'});
  }

  /// Generates a Set of integers with `n` items.
  static Set<int> createIntSet(int n) {
    return Set<int>.from(List<int>.generate(n, (index) => index));
  }

  /// Generates a Queue of strings with `n` items.
  static Queue<String> createStringQueue(int n) {
    return Queue<String>.from(
        List<String>.generate(n, (index) => 'String $index'));
  }

  /// Generates a Queue of integers with `n` items.
  static Queue<int> createIntQueue(int n) {
    return Queue<int>.from(List<int>.generate(n, (index) => index));
  }
}

/// A node for a linked list of strings.
final class StringNode extends LinkedListEntry<StringNode> {
  final String value;
  StringNode(this.value);

  @override
  String toString() => value;
}

/// A node for a linked list of integers.
final class IntNode extends LinkedListEntry<IntNode> {
  final int value;
  IntNode(this.value);

  @override
  String toString() => value.toString();
}

class ComponentNameManagerFixtures {
  // Good examples of component names
  static const List<String> validComponentNames = [
    'root',
    'root/parent',
    'root/parent/child',
    'system/configuration/setting',
    'user/profile/details',
    'product/category/item'
  ];

  // Bad examples of component names
  static const List<String> invalidComponentNames = [
    '', // Empty name
    ' root', // Leading space
    'parent ', // Trailing space
    'root//child', // Double separator
    'root/parent/', // Trailing separator
    'root#parent', // Invalid separator
    '/root/parent', // Leading separator
    'root/parent/child ' // Trailing space
  ];

  // Good examples of option keys
  static const List<String> validOptionKeys = [
    'root#option',
    'root/parent#option',
    'root/parent/child#option',
    'system/configuration#setting',
    'user/profile#details',
    'product/category#item',
    'root~optionalOption',
    'root/parent~optionalSetting',
  ];

  // Bad examples of option keys
  static const List<String> invalidOptionKeys = [
    '', // Empty key
    'root#', // Missing option
    '#option', // Missing component
    'root/parent#', // Missing option
    'root##option', // Double mandatory separator
    'root~~optionalOption', // Double optional separator
    'root/parent/child#option#extra', // Nested option separators
    ' root#option', // Leading space in component
    'root #option', // Space before separator
    'root# option', // Space after separator
    'root#option ', // Trailing space
    'root~option#extra', // Mixed separators
  ];
}
