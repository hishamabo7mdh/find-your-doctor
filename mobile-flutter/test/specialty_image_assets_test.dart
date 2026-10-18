import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const images = [
    'assets/images/respiratory.svg',
    'assets/images/blood.svg',
    'assets/images/orthopedics.svg',
    'assets/images/gynecology.svg',
    'assets/images/ent.svg',
  ];

  for (final image in images) {
    testWidgets('$image loads as a specialty image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SvgPicture.asset(image, width: 100, height: 100),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  }
}
