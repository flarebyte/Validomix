import 'vx_model.dart';

/// A class that wraps a static message.
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
