import 'package:flutter/material.dart';
import 'package:hebrewbear/layouts/addword/addword.dart';

class HebrewBearSidebar extends StatelessWidget {
  const HebrewBearSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Drawer(
        backgroundColor: Theme.of(context).canvasColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppBar(
              title: const Text("Menu"),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add word', style: TextStyle(fontSize: 16)),
              onTap: () {
                // Close the drawer, then push, so Back returns to the list.
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddWord(type: 'word'),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
