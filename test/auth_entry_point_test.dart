import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/auth.dart';

void main() {
  test('optional auth entry point exposes domain and presentation APIs', () {
    expect(UserEntity, isNotNull);
    expect(AuthRepository, isNotNull);
    expect(AuthController, isNotNull);
    expect(AuthScreen, isNotNull);
  });
}
