
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/astrology_card.dart';

class AstrologyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 從指定集合中隨機抽取一張卡片
  Future<AstrologyCard> _drawRandomCard(String collection) async {
    final querySnapshot = await _firestore.collection(collection).get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('$collection 集合為空或不存在。');
    }
    final randomIndex = Random().nextInt(querySnapshot.docs.length);
    final doc = querySnapshot.docs[randomIndex];
    return AstrologyCard.fromFirestore(doc.data());
  }

  // 執行三位一體抽牌
  Future<Map<String, AstrologyCard>> drawTrinityCard() async {
    try {
      // 並行執行三次抽取
      final results = await Future.wait([
        _drawRandomCard('planets'), // 主角
        _drawRandomCard('houses'),  // 情境
        _drawRandomCard('signs'),   // 風格
      ]);

      return {
        'protagonist': results[0],
        'situation': results[1],
        'style': results[2],
      };
    } catch (e) {
      print('抽牌時發生錯誤: $e');
      // 在真實應用中，這裡應該有更完善的錯誤處理
      rethrow;
    }
  }
}
