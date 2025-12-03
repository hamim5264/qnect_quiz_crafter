import 'package:flutter_riverpod/legacy.dart';

final courseSearchProvider = StateProvider<String>((ref) => "");

final courseStatusFilterProvider = StateProvider<String>((ref) => "All");

final publishFilterProvider = StateProvider<String>((ref) => "All");
