abstract class VxBaseValidator<MSG, V> {
  List<MSG> validate(Map<String, String> options, V value);
}

abstract class VxBaseRule<MSG> extends VxBaseValidator<MSG, String> {}

abstract class VxStringParser<V> {
  V? parseString(String value);
}
