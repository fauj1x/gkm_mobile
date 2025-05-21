class RekapResponse {
  final String status;
  final String message;
  final Map<String, RekapItem> data;

  RekapResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RekapResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>;
    final parsedData = rawData.map((key, value) =>
        MapEntry(key, RekapItem.fromJson(value as Map<String, dynamic>)));

    return RekapResponse(
      status: json['status'],
      message: json['message'],
      data: parsedData,
    );
  }
}

class RekapItem {
  final int count;
  final int min;
  final String status;

  RekapItem({
    required this.count,
    required this.min,
    required this.status,
  });

  factory RekapItem.fromJson(Map<String, dynamic> json) {
    return RekapItem(
      count: json['count'],
      min: json['min'],
      status: json['status'],
    );
  }
}
