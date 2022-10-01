import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_dhobi_dashboard/databases/batch_database.dart';

import 'auth/auth_service.dart';
import 'databases/cart_database.dart';
import 'databases/schedule_database.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final destinationProvider = StateProvider<int>((ref) {
  return 0;
});

final scheduleDatabaseProvider = Provider<ScheduleDatabase>((ref) {
  return ScheduleDatabase();
});

final cartDatabaseProvider = Provider<CartDatabase>((ref) {
  return CartDatabase();
});

final batchDatabaseProvider = Provider<BatchDatabase>((ref) {
  return BatchDatabase();
});
final statusProvider = StateProvider<int>((ref) {
  return 0;
});

//110