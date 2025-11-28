class AdminGrowthState {
  final bool loading;
  final int currentMonthUsers;
  final int previousMonthUsers;

  const AdminGrowthState({
    this.loading = true,
    this.currentMonthUsers = 0,
    this.previousMonthUsers = 0,
  });

  AdminGrowthState copyWith({
    bool? loading,
    int? currentMonthUsers,
    int? previousMonthUsers,
  }) {
    return AdminGrowthState(
      loading: loading ?? this.loading,
      currentMonthUsers: currentMonthUsers ?? this.currentMonthUsers,
      previousMonthUsers: previousMonthUsers ?? this.previousMonthUsers,
    );
  }
}
