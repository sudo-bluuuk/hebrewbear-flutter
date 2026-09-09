import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/wordtypes.dart';
import 'package:hebrewbear/layouts/wordslist/wordslist.dart';
import 'package:hebrewbear/widgets/wordtypechip.dart';

void main() {
  const word = WordsSchemaData(
    id: 1,
    root: 'כתב',
    translate: 'write',
    type: 'Paal',
  );

  Future<void> pumpButtonsAt(WidgetTester tester, double width) {
    return tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: width, child: const ConjugationButtons(word: word)),
        ),
      ),
    ));
  }

  group('ConjugationButtons', () {
    testWidgets('sits in a row when there is space', (tester) async {
      await pumpButtonsAt(tester, 900);

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Column), findsNothing);
      expect(find.byType(ConjugationButton), findsNWidgets(3));
    });

    testWidgets('stacks into a column when the row will not fit',
        (tester) async {
      await pumpButtonsAt(tester, 200);

      expect(find.byType(Column), findsWidgets);
      expect(find.byType(ConjugationButton), findsNWidgets(3));
    });

    // The layout picks between row and column from a measured width, so sweep
    // the range rather than pinning one hand-chosen breakpoint: no width may
    // overflow, and all three buttons must always survive.
    testWidgets('never overflows at any width', (tester) async {
      for (var width = 120.0; width <= 900.0; width += 4.0) {
        await pumpButtonsAt(tester, width);
        expect(tester.takeException(), isNull, reason: 'overflowed at $width');
        expect(find.byType(ConjugationButton), findsNWidgets(3),
            reason: 'lost a button at $width');
      }
    });

    testWidgets('switches exactly at the measured width', (tester) async {
      late double measured;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          measured = ConjugationButtons.rowWidthFor(context);
          return const SizedBox.shrink();
        }),
      ));

      await pumpButtonsAt(tester, measured);
      expect(find.byType(Column), findsNothing, reason: 'should still be a row');

      await pumpButtonsAt(tester, measured - 1);
      expect(find.byType(Column), findsWidgets, reason: 'should have stacked');
    });
  });

  group('WordTypeChip', () {
    Future<Color> chipColor(WidgetTester tester, String type) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: Center(child: WordTypeChip(type: type))),
      ));
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(WordTypeChip),
        matching: find.byType(Container),
      ));
      return (container.decoration as BoxDecoration).color!;
    }

    testWidgets('shows the type as its label', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: WordTypeChip(type: 'Hitpael'))),
      ));

      expect(find.text('Hitpael'), findsOneWidget);
    });

    testWidgets('gives each category its own colour', (tester) async {
      final verb = await chipColor(tester, 'Paal');
      final noun = await chipColor(tester, nounType);
      final adjective = await chipColor(tester, adjectiveType);

      expect({verb, noun, adjective}, hasLength(3));
    });

    testWidgets('gives every binyan the same colour', (tester) async {
      final colors = <Color>{};
      for (final binyan in binyanim) {
        colors.add(await chipColor(tester, binyan));
      }

      expect(colors, hasLength(1));
    });
  });
}
