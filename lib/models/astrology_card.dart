
// lib/models/astrology_card.dart
class AstrologyCard {
  final String name;
  final String advice;
  final String description;

  AstrologyCard({
    required this.name,
    required this.advice,
    required this.description,
  });

  // 從 Firestore Document 轉換的工廠構造函數
  factory AstrologyCard.fromFirestore(Map<String, dynamic> data) {
    return AstrologyCard(
      name: data['name_zh'] ?? '未知名稱',
      advice: data['advice_zh'] ?? '暫無建議',
      description: data['full_description_zh'] ?? '暫無詳解',
    );
  }
}
