import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/storage_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final data = await StorageHelper.getHistory();
    setState(() {
      _history = data;
      _isLoading = false;
    });
  }

  void _deleteItem(String id) async {
    await StorageHelper.deleteHistoryItem(id);
    _fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            tooltip: 'Clear All',
            onPressed: () async {
              await StorageHelper.clearAllHistory();
              _fetchHistory();
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB703)))
          : _history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.shade700),
                      const SizedBox(height: 16),
                      const Text('No scans or generations yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final isScan = item['type'].toString().contains('Scan');
                    
                    return Dismissible(
                      key: Key(item['id']),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deleteItem(item['id']),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: isScan ? const Color(0xFFFFB703).withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                            child: Icon(
                              isScan ? Icons.qr_code_scanner : Icons.qr_code,
                              color: isScan ? const Color(0xFFFFB703) : Colors.lightBlueAccent,
                            ),
                          ),
                          title: Text(
                            item['value'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          subtitle: Text(
                            "${item['type']} • ${_formatTime(item['timestamp'])}",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: item['value']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied to Clipboard!')),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    final dt = DateTime.tryParse(timestamp);
    if (dt == null) return '';
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}