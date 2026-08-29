part of 'admin_dashboard_bloc.dart';

abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState();

  @override
  List<Object?> get props => [];
}

class AdminDashboardInitial extends AdminDashboardState {
  const AdminDashboardInitial();
}

class AdminDashboardLoading extends AdminDashboardState {
  const AdminDashboardLoading();
}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboardData data;
  final bool isRefreshing;

  const AdminDashboardLoaded(this.data, {this.isRefreshing = false});

  AdminDashboardLoaded copyWith({AdminDashboardData? data, bool? isRefreshing}) {
    return AdminDashboardLoaded(
      data ?? this.data,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [data, isRefreshing];
}

class AdminDashboardError extends AdminDashboardState {
  final String message;
  const AdminDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
