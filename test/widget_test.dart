import 'package:flutter_test/flutter_test.dart';

import 'package:kippy/main.dart';

void main() {
  testWidgets('Kippy app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KippyApp());

    // Verify splash screen loads.
    expect(find.text('Kippy'), findsOneWidget);
  });
}
