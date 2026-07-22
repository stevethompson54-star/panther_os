import 'package:flutter_test/flutter_test.dart';
import 'package:panther_os/core/app/app.dart';

void main() {
  testWidgets('PantherOS home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PantherApp());

    expect(find.text('Good Morning, Coach'), findsOneWidget);
    expect(find.text('Begin Practice'), findsOneWidget);
  });
}
