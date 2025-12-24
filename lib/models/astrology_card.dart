// lib/models/astrology_card.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AstrologyCard {
  final String name;
  final String advice;
  final String description;

  AstrologyCard({
    required this.name,
    required this.advice,
    required this.description,
  });

  // 這是從 Firestore 轉換資料的工廠構造函數
  factory AstrologyCard.fromFirestore(Map<String, dynamic> data) {
    // 1. 關鍵修正：先抓出 Map 盒子 (Map 結構)，再拿裡面的 zh 欄位
    // 這樣才能讀到資料庫裡 name -> zh 的內容
    final Map<String, dynamic> nameMap = data['name'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> interpretationMap = data['interpretation'] as Map<String, dynamic>? ?? {};

    return AstrologyCard(
      // 2. 對齊您的變數名稱，從盒子裡精準取出繁體中文
      name: nameMap['zh'] ?? '未命名', 
      // 這裡將 advice 和 description 都對準資料庫的解說欄位
      advice: interpretationMap['zh'] ?? '暫無建議', 
      description: interpretationMap['zh'] ?? '暫無詳解',
    );
  }
}
