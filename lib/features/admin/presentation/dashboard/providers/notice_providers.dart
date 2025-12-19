import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final latestNoticesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('notices')
      .orderBy('createdAt', descending: true)
      .limit(3)
      .snapshots()
      .map((snap) {
        return snap.docs.map((d) {
          final data = d.data();
          return {
            'id': d.id,
            'title': data['title'] ?? '',
            'subtitle': data['description'] ?? '',
            'audience': data['audience'] ?? 'All',
            'time': _formatTime(data['createdAt']),
          };
        }).toList();
      });
});

String _formatTime(Timestamp? ts) {
  if (ts == null) return '';
  final dt = ts.toDate();
  return '${dt.day} ${_month(dt.month)} ${dt.year}, '
      '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}

String _month(int m) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[m - 1];
}
