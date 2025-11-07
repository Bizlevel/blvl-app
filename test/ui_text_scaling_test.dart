import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/widgets/common/list_row_tile.dart';

void main() {
  testWidgets('UI renders without overflow at increased text scale', (tester) async {
    final widget = MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
        child: Scaffold(
          body: ListRowTile(
            leadingIcon: Icons.info_outline,
            title: 'Очень длинный заголовок для проверки ужимания и обрезки',
            subtitle: 'Длинное описание для проверки textScaleFactor',
            semanticsLabel: 'Плитка информации',
            onTap: () {},
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Проверяем, что виджет появился и не упал
    expect(find.byType(ListRowTile), findsOneWidget);
  });
}


