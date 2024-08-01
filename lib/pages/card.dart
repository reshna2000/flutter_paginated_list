import 'package:flutter/material.dart';

import '../utils/Colors.dart';

class DataCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const DataCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = data['image'] ?? '';

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF066f55),
              /// Loads image from URL if provided
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Text(
                '${data['id']}',
                style: TextStyle(color: Colors.white),
              )
                  : null,
            ),
            ///view details
            title: Text('${data['firstName']} ${data['lastName']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${data['age']}'),
                Text('Gender: ${data['gender']}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
