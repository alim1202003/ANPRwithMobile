import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> scannedPlates;

  const HistoryPage({super.key, required this.scannedPlates});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _deletePlate(int index) {
    setState(() {
      widget.scannedPlates.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plaka silindi.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Plakayı Sil'),
            content: const Text('Bu plakayı silmek istediğine emin misin?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sil', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş'),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body:
          widget.scannedPlates.isEmpty
              ? const Center(child: Text("Henüz plaka taranmadı."))
              : ListView.builder(
                itemCount: widget.scannedPlates.length,
                itemBuilder: (context, index) {
                  final plateInfo = widget.scannedPlates[index];
                  final plate = plateInfo['plate'];
                  final time = plateInfo['time'];
                  return Dismissible(
                    key: UniqueKey(),
                    direction:
                        DismissDirection.endToStart, // Sağdan sola kaydır
                    confirmDismiss: (direction) async {
                      final confirm = await _confirmDelete(context);
                      if (confirm == true) {
                        _deletePlate(index);
                        return true;
                      }
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          plate,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          time,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.history,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
