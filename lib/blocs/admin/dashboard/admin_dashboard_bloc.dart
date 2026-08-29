import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/admin_dashboard_model.dart';
import '../../../repositories/admin_repository.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

/// Drives the Control Room dashboard (Admin — Screen 1).
class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminRepository repository;

  AdminDashboardBloc({required this.repository}) : super(const AdminDashboardInitial()) {
    on<LoadDashboard>(_onLoad);
    on<RefreshDashboard>(_onRefresh);
  }

  Future<void> _onLoad(LoadDashboard event, Emitter<AdminDashboardState> emit) async {
    emit(const AdminDashboardLoading());
    await _fetch(emit);
  }

  Future<void> _onRefresh(RefreshDashboard event, Emitter<AdminDashboardState> emit) async {
    final current = state;
    if (current is AdminDashboardLoaded) {
      emit(current.copyWith(isRefreshing: true));
    }
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<AdminDashboardState> emit) async {
    try {
      final data = await repository.getDashboardData();
      emit(AdminDashboardLoaded(data));
    } catch (e) {
      emit(const AdminDashboardError('Could not load the Control Room. Pull to retry.'));
    }
  }
}
