import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

import 'vx_fixtures.dart';

void main() {
  group('VxComponentNameManager', () {
    final config = VxComponentManagerConfig();

    test('getParent should return correct parent', () {
      expect(VxComponentNameManager.getParent('root/parent/child', config),
          'root/parent');
      expect(VxComponentNameManager.getParent('root/parent', config), 'root');
      expect(VxComponentNameManager.getParent('root', config), isNull);
    });

    test('getComponentName should return correct component name', () {
      expect(
          VxComponentNameManager.getComponentName(
              'root/parent/child#option', config),
          'root/parent/child');
      expect(VxComponentNameManager.getComponentName('root#option', config),
          'root');
      expect(
          VxComponentNameManager.getComponentName(
              'root/parent/child~option', config),
          'root/parent/child');
    });

    test('getOptionName should return correct option name', () {
      expect(
          VxComponentNameManager.getOptionName(
              'root/parent/child#option', config),
          'option');
      expect(VxComponentNameManager.getOptionName('root#option', config),
          'option');
      expect(
          VxComponentNameManager.getOptionName(
              'root/parent/child~option', config),
          'option');
      expect(VxComponentNameManager.getOptionName('root/parent/child', config),
          isNull);
    });

    test('isRoot should correctly identify root component', () {
      expect(VxComponentNameManager.isRoot('root', config), isTrue);
      expect(VxComponentNameManager.isRoot('root/parent', config), isFalse);
    });

    test('getFullOptionKey should construct correct full option key', () {
      expect(
          VxComponentNameManager.getFullOptionKey(
              'root/parent/child', 'option', config),
          'root/parent/child#option');
      expect(VxComponentNameManager.getFullOptionKey('root', 'option', config),
          'root#option');
    });

    test('createChild should add child to parent correctly', () {
      expect(VxComponentNameManager.createChild('root/parent', 'child', config),
          'root/parent/child');
      expect(VxComponentNameManager.createChild('root', 'parent', config),
          'root/parent');
    });

    test('joinPaths should combine paths correctly', () {
      expect(
          VxComponentNameManager.joinPaths(
              'root/parent', 'child/grandchild', config),
          'root/parent/child/grandchild');
      expect(VxComponentNameManager.joinPaths('root', 'parent/child', config),
          'root/parent/child');
    });

    // Invalid cases
    group('Invalid cases', () {
      test('Invalid component names should throw ArgumentError', () {
        for (var invalidName
            in ComponentNameManagerFixtures.invalidComponentNames) {
          expect(() => VxComponentNameManager.getParent(invalidName, config),
              throwsArgumentError);
          expect(() => VxComponentNameManager.isRoot(invalidName, config),
              throwsArgumentError);
          expect(
              () => VxComponentNameManager.createChild(
                  invalidName, 'child', config),
              throwsArgumentError);
          expect(
              () => VxComponentNameManager.createChild(
                  'parent', invalidName, config),
              throwsArgumentError);
        }
      });

      test('Invalid option keys should throw ArgumentError', () {
        for (var invalidKey in ComponentNameManagerFixtures.invalidOptionKeys) {
          expect(
              () => VxComponentNameManager.getComponentName(invalidKey, config),
              throwsArgumentError);
          expect(() => VxComponentNameManager.getOptionName(invalidKey, config),
              throwsArgumentError);
          expect(
              () => VxComponentNameManager.getFullOptionKey(
                  'root/parent', invalidKey, config),
              throwsArgumentError);
        }
      });
    });
  });
}
