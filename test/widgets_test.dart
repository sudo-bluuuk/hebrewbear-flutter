import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/wordtypes.dart';
import 'package:hebrewbear/layouts/wordslist/wordslist.dart';
import 'package:hebrewbear/widgets/categoryfilter.dart';
import 'package:hebrewbear/widgets/stripe.dart';
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

  group('CategoryFilter', () {
    Future<void> pumpFilter(
      WidgetTester tester, {
      WordCategory? value,
      ValueChanged<WordCategory?>? onChanged,
      double width = 240,
    }) {
      return tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: CategoryFilter(
                value: value,
                onChanged: onChanged ?? (_) {},
              ),
            ),
          ),
        ),
      ));
    }

    // A null value doubles as Dropdown's "nothing selected" sentinel, so pin
    // that it really renders the All entry rather than falling back to blank.
    testWidgets('shows All when no category is selected', (tester) async {
      await pumpFilter(tester);

      expect(find.text(CategoryFilter.allLabel), findsOneWidget);
    });

    testWidgets('shows the selected category', (tester) async {
      await pumpFilter(tester, value: WordCategory.noun);

      expect(find.text('Noun'), findsOneWidget);
      expect(find.text(CategoryFilter.allLabel), findsNothing);
    });

    testWidgets('offers All plus every category', (tester) async {
      await pumpFilter(tester);
      await tester.tap(find.byType(CategoryFilter));
      await tester.pumpAndSettle();

      for (final label in ['Verb', 'Noun', 'Adjective']) {
        expect(find.text(label), findsWidgets, reason: 'missing $label');
      }
    });

    // Same trap as the tense buttons: the label width depends on the font, so
    // the box must cope with a label too wide for it rather than overflowing.
    testWidgets('never overflows, however narrow the box', (tester) async {
      for (var width = 80.0; width <= 320.0; width += 8.0) {
        await pumpFilter(tester, width: width);
        expect(tester.takeException(), isNull, reason: 'overflowed at $width');
      }
    });

    testWidgets('reports the picked category', (tester) async {
      WordCategory? picked;
      await pumpFilter(tester, onChanged: (value) => picked = value);

      await tester.tap(find.byType(CategoryFilter));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Adjective').last);
      await tester.pumpAndSettle();

      expect(picked, WordCategory.adjective);
    });
  });

  group('stripeColor', () {
    Future<(Color even, Color odd, Color surface)> sample(
      WidgetTester tester,
      Brightness brightness,
    ) async {
      late Color even, odd, surface;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: brightness,
          ),
        ),
        home: Builder(builder: (context) {
          even = stripeColor(context, 0);
          odd = stripeColor(context, 1);
          surface = Theme.of(context).colorScheme.surface;
          return const SizedBox.shrink();
        }),
      ));
      return (even, odd, surface);
    }

    testWidgets('only even rows are tinted', (tester) async {
      final (even, odd, _) = await sample(tester, Brightness.light);

      expect(odd, Colors.transparent);
      expect(even, isNot(Colors.transparent));
    });

    testWidgets('the stripe is lighter than the surface in the dark theme',
        (tester) async {
      final (even, _, surface) = await sample(tester, Brightness.dark);

      expect(even.computeLuminance(), greaterThan(surface.computeLuminance()));
    });

    testWidgets('the stripe stays distinct in the light theme',
        (tester) async {
      final (even, _, surface) = await sample(tester, Brightness.light);

      expect(even, isNot(surface));
    });
  });
}
