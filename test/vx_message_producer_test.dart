import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

void main() {
  group('VxStaticMessage', () {
    test('returns the static message', () {
      final staticMessage = 'Static error message';
      final messageProducer = VxStaticMessage<String>(staticMessage);

      final result = messageProducer.produce({}, null);

      expect(result, staticMessage);
    });

    test('ignores options and value', () {
      final staticMessage = 'Static error message';
      final messageProducer = VxStaticMessage<String>(staticMessage);
      final options = {'key': 'value'};
      final value = 'some value';

      final result = messageProducer.produce(options, value);

      expect(result, staticMessage);
    });
  });
}
