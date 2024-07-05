import 'vx_model.dart';

class VxStaticMessage<MSG> extends VxMessageProducer<MSG, dynamic> {
  final MSG message;

  /// Constructor that initializes the message field.
  VxStaticMessage(this.message);

  /// Returns the static message without using options or value.
  @override
  MSG produce(Map<String, String> options, dynamic value) {
    return message;
  }
}
