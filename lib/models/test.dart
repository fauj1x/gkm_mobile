class TestModel {
  final int id; // <= tambahkan baris ini
  final String text;

  TestModel({
    required this.id, // <= tambahkan ini
    required this.text,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'], // <= tambahkan ini
      text: json['text']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // <= tambahkan ini
      'text': text,
    };
  }
}