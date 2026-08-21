import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testapp4/main.dart';

void main() {
  testWidgets('StudySync app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudySyncApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
