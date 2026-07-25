import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qr_master_pro/main.dart';

void main() {
  testWidgets('QR Master Pro launches successfully',
      (WidgetTester tester) async {

    await tester.pumpWidget(const QRMasterApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}