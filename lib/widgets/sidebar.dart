import 'package:flutter/material.dart';
import 'package:hebrewbear/data/wordtypes.dart';
import 'package:hebrewbear/layouts/addword/addword.dart';

class HebrewBearSidebar extends StatelessWidget {
  const HebrewBearSidebar({super.key});

  static IconData _iconFor(WordCategory category) => switch (category) {
        WordCategory.verb => Icons.directions_run,
        WordCategory.noun => Icons.category,
        WordCategory.adjective => Icons.palette,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Drawer(
        backgroundColor: Theme.of(context).canvasColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppBar(
              title: const Text("Menu"),
              automaticallyImplyLeading: false,
            ),
            for (final category in WordCategory.values)
              ListTile(
                leading: Icon(_iconFor(category)),
                title: Text(
                  'Add ${category.label}',
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () {
                  // Close the drawer, then push, so Back returns to the list.
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddWord(category: category),
                  ));
                },
              ),
          ],
        ),
      ),
    );
  }
}
