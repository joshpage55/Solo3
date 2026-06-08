import 'package:flutter_test/flutter_test.dart';

import 'package:tip_calculator/main.dart';

void main() {
  testWidgets('Tip calculator screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TipCalculatorApp());

    expect(find.text('Tip Calculator'), findsOneWidget);
    expect(find.text('Calculate Tip'), findsOneWidget);
    expect(find.text('Bill Amount'), findsOneWidget);
  });
}
