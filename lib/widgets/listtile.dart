import 'package:flutter/material.dart';

class Listtile extends StatefulWidget {
  const Listtile({
    super.key,
    required this.status,
    required this.title,
    required this.description,
    required this.date,
    required this.onEdit,
    required this.onDelete,
  });

  final String status;
  final String title;
  final String description;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<Listtile> createState() => _ListtileState();
}

class _ListtileState extends State<Listtile> {
  Color getChipColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return const Color(0xFF17C1E8); // light blue
      case 'completed':
        return const Color(0xFF21BF73); // green
      case 'cancelled':
        return const Color(0xFFF15056); // pink
      case 'progress':
        return const Color(0xFFCB0C9F); // purple
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: "bold",
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 12, fontFamily: "regular"),
            ),
            const SizedBox(height: 8),
            Text(
              "Date: ${widget.date}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getChipColor(widget.status),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.status,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 235, 238, 241),
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
