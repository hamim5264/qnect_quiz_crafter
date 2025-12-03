import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// 🔍 Search text provider
final courseSearchProvider = StateProvider<String>((ref) => "");

// 🟦 Status filter (All, draft, pending, approved, rejected)
final courseStatusFilterProvider = StateProvider<String>((ref) => "All");

// 🟩 Publish filter (All, published, unpublished)
final publishFilterProvider = StateProvider<String>((ref) => "All");
