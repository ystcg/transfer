import 'package:flutter_test/flutter_test.dart';
import 'package:unfold/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UnfoldApp());
    expect(find.text('unfold'), findsOneWidget);
  });
}
