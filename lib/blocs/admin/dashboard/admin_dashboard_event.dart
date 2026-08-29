part of 'admin_dashboard_bloc.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends AdminDashboardEvent {
  const LoadDashboard();
}

/// Pull-to-refresh / manual refresh — same handler as LoadDashboard but
/// kept as a distinct event so the UI can skip the full-screen loader and
/// show a lighter refresh indicator instead.
class RefreshDashboard extends AdminDashboardEvent {
  const RefreshDashboard();
}
