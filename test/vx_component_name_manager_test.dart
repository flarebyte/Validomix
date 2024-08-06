import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

import 'vx_fixtures.dart';

void main() {
  group('VxComponentNameManager', () {
    test('getParent should return correct parent', () {
      expect(
          VxComponentNameManager.getParent('root/parent/child'), 'root/parent');
      expect(VxComponentNameManager.getParent('root/parent'), 'root');
      expect(VxComponentNameManager.getParent('root'), isNull);
    });

    test('getComponentName should return correct component name', () {
      expect(
          VxComponentNameManager.getComponentName('root/parent/child#option'),
          'root/parent/child');
      expect(VxComponentNameManager.getComponentName('root#option'), 'root');
      expect(
          VxComponentNameManager.getComponentName('root/parent/child~option'),
          'root/parent/child');
    });

    test('getOptionName should return correct option name', () {
      expect(VxComponentNameManager.getOptionName('root/parent/child#option'),
          'option');
      expect(VxComponentNameManager.getOptionName('root#option'), 'option');
      expect(VxComponentNameManager.getOptionName('root/parent/child~option'),
          'option');
      expect(VxComponentNameManager.getOptionName('root/parent/child'), isNull);
    });

    test('isRoot should correctly identify root component', () {
      expect(VxComponentNameManager.isRoot('root'), isTrue);
      expect(VxComponentNameManager.isRoot('root/parent'), isFalse);
    });

    test('getFullOptionKey should construct correct full option key', () {
      expect(
          VxComponentNameManager.getFullOptionKey(
              'root/parent/child', 'option'),
          'root/parent/child#option');
      expect(VxComponentNameManager.getFullOptionKey('root', 'option'),
          'root#option');
    });

    test('createChild should add child to parent correctly', () {
      expect(VxComponentNameManager.createChild('root/parent', 'child'),
          'root/parent/child');
      expect(
          VxComponentNameManager.createChild('root', 'parent'), 'root/parent');
    });

    test('joinPaths should combine paths correctly', () {
      expect(
          VxComponentNameManager.joinPaths('root/parent', 'child/grandchild'),
          'root/parent/child/grandchild');
      expect(VxComponentNameManager.joinPaths('root', 'parent/child'),
          'root/parent/child');
    });

    // Invalid cases
    group('Invalid cases.', () {
      test('Invalid component names for getParent should throw ArgumentError',
          () {
        for (var invalidName
            in ComponentNameManagerFixtures.invalidComponentNames) {
          expect(() => VxComponentNameManager.getParent(invalidName),
              throwsArgumentError);
        }
      });

      test('Invalid component names for createChild should throw ArgumentError',
          () {
        for (var invalidName
            in ComponentNameManagerFixtures.invalidComponentNames) {
          expect(() => VxComponentNameManager.createChild(invalidName, 'child'),
              throwsArgumentError);
        }
      });

      test(
          'Invalid option keys for getComponentName should throw ArgumentError',
          () {
        for (var invalidKey in ComponentNameManagerFixtures.invalidOptionKeys) {
          expect(() => VxComponentNameManager.getComponentName(invalidKey),
              throwsArgumentError);
        }
      });
      test('Invalid option keys for getOptionName should throw ArgumentError',
          () {
        for (var invalidKey in ComponentNameManagerFixtures.invalidOptionKeys) {
          expect(() => VxComponentNameManager.getOptionName(invalidKey),
              throwsArgumentError);
        }
      });
      test(
          'Invalid option keys for getFullOptionKey should throw ArgumentError',
          () {
        for (var invalidKey in ComponentNameManagerFixtures.invalidOptionKeys) {
          expect(
              () => VxComponentNameManager.getFullOptionKey(
                  'root/parent', invalidKey),
              throwsArgumentError);
        }
      });
    });
  });
}
