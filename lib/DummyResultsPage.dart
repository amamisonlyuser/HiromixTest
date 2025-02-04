import 'package:flutter/material.dart';

class DummyResultsPage extends StatelessWidget {
  const DummyResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results Live'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Results',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Change this to the number of results
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Result ${index + 1}'),
                      subtitle: Text('Description of Result ${index + 1}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to detailed result page or show more info
                        // Placeholder action for now
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped on Result ${index + 1}')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
