class TopDebtorModel {
  final int id;

  final String name;

  final num balance;
  final int rank;

  TopDebtorModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.rank,
  });

  factory TopDebtorModel.fromJson(Map<String, dynamic> json) {
    return TopDebtorModel(
      id: json['id'] ?? 0,

      name: json['name'] ?? '',

      balance: json['balance'] ?? 0,

      rank: json['rank'] ?? 0,
    );
  }
}
