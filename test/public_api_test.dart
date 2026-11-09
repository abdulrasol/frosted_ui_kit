import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  test('public entry point exposes canonical APIs', () {
    expect(BlurredCard, isNotNull);
    expect(CircleButton, isNotNull);
    expect(FrostedNavigationBottomBar, isNotNull);
    expect(FrostedPerformance.android, isNotNull);
    expect(FrostedThemeData.dark, isNotNull);
  });
}
