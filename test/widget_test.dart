// Basic smoke test to ensure app launches
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loopout/core/app.dart';

void main() {
  testWidgets('App smoke test - app launches without crashing', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: LoopOutApp(),
      ),
    );

    // Verify splash screen appears with logo
    expect(find.text('LO'), findsOneWidget);
    expect(find.text('LoopOut'), findsOneWidget);
  });
}
