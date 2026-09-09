import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/layouts/conjugation/editform.dart';

void main() {
  final latet = '${letters['lamed']}${letters['tav']}${letters['tav']}';
  final linton = '${letters['lamed']}${letters['nun']}${letters['tav']}'
      '${letters['vav']}${letters['nun']}';

  // The dialog's future only completes when it pops, so it is held rather
  // than awaited: each test interacts first, then awaits the outcome.
  late Future<FormEdit?> popped;

  Future<void> openDialog(
    WidgetTester tester, {
    required String current,
    bool isManual = false,
  }) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => popped = showDialog<FormEdit>(
              context: context,
              builder: (_) => EditFormDialog(
                label: 'Infinitive',
                current: current,
                isManual: isManual,
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens prefilled with the form being corrected', (tester) async {
    await openDialog(tester, current: linton);

    expect(find.text(linton), findsOneWidget);
    expect(find.text('Correct Infinitive'), findsOneWidget);
  });

  testWidgets('saving reports the typed form', (tester) async {
    await openDialog(tester, current: linton);
    await tester.enterText(find.byType(TextFormField), latet);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(await popped, isA<FormReplaced>());
    expect(((await popped) as FormReplaced).form, latet);
  });

  testWidgets('surrounding whitespace is trimmed off', (tester) async {
    await openDialog(tester, current: linton);
    await tester.enterText(find.byType(TextFormField), '  $latet  ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(((await popped) as FormReplaced).form, latet);
  });

  testWidgets('cancelling reports nothing', (tester) async {
    await openDialog(tester, current: linton);
    await tester.enterText(find.byType(TextFormField), latet);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(await popped, isNull);
  });

  testWidgets('Reset is hidden for a form that is still generated',
      (tester) async {
    await openDialog(tester, current: linton, isManual: false);

    expect(find.text('Reset'), findsNothing);
  });

  testWidgets('Reset is offered for an already corrected form',
      (tester) async {
    await openDialog(tester, current: latet, isManual: true);
    expect(find.text('Reset'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(await popped, isA<FormReset>());
  });

  testWidgets('a non-Hebrew form is rejected and nothing is reported',
      (tester) async {
    await openDialog(tester, current: linton);
    await tester.enterText(find.byType(TextFormField), 'latet');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Only Hebrew allowed'), findsOneWidget);
    expect(find.byType(EditFormDialog), findsOneWidget, reason: 'stayed open');
  });

  testWidgets('an empty form is rejected', (tester) async {
    await openDialog(tester, current: linton);
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a form'), findsOneWidget);
    expect(find.byType(EditFormDialog), findsOneWidget, reason: 'stayed open');
  });
}
