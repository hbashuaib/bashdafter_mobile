class DashboardTopDebtorModel {
  final int id;

  final String name;

  final num balance;

  DashboardTopDebtorModel({
    required this.id,
    required this.name,
    required this.balance,
  });

  factory DashboardTopDebtorModel.fromJson(Map<String, dynamic> json) {
    return DashboardTopDebtorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      balance: json['balance'] ?? 0,
    );
  }
}
