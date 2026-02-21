import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalpa_yatra/main.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TravelApp()));
    await tester.pumpAndSettle();

    // Verify the app title is rendered
    expect(find.text('Kashi Yatra'), findsWidgets);
  });
}
