import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devops_app_midterm/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Wrap MyApp with CupertinoApp instead of MaterialApp
    await tester.pumpWidget(const CupertinoApp(home: MyApp()));

    // Wait for UI to fully load
    await tester.pumpAndSettle();

    // Debugging: Print all widgets in the tree
    final allWidgets = tester.allWidgets.map((widget) => widget.toString()).toList();
    print('Available Widgets in Tree: $allWidgets');

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget, reason: 'Counter should start at 0');
    expect(find.text('1'), findsNothing, reason: '1 should not be in the UI initially');

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(CupertinoIcons.add)); // Using Cupertino icon
    await tester.pump();

    // Debugging: Print all widgets after tap
    final updatedWidgets = tester.allWidgets.map((widget) => widget.toString()).toList();
    print('Available Widgets in Tree After Tap: $updatedWidgets');

    // Verify that the counter has incremented.
    expect(find.text('0'), findsNothing, reason: '0 should disappear after increment');
    expect(find.text('1'), findsOneWidget, reason: 'Counter should increment to 1');
  });
}
