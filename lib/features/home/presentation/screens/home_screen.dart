import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TextButton.icon(
                          label: Text('test'),
                          icon: Icon(Icons.text_decrease),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          label: Text('test'),
                          icon: Icon(Icons.text_decrease),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          label: Text('test'),
                          icon: Icon(Icons.text_decrease),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          label: Text('test'),
                          icon: Icon(Icons.text_decrease),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
