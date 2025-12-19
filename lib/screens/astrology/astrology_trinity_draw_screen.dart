
import 'package:flutter/material.dart';
import '../../services/astrology_service.dart';
import '../../models/astrology_card.dart';

class AstrologyTrinityDrawScreen extends StatefulWidget {
  const AstrologyTrinityDrawScreen({super.key});

  @override
  State<AstrologyTrinityDrawScreen> createState() => _AstrologyTrinityDrawScreenState();
}

class _AstrologyTrinityDrawScreenState extends State<AstrologyTrinityDrawScreen> {
  final AstrologyService _astrologyService = AstrologyService();
  Map<String, AstrologyCard>? _trinityCards;
  bool _isLoading = false;
  String? _error;

  // 抽牌邏輯
  Future<void> _drawCards() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _trinityCards = null;
    });

    try {
      final cards = await _astrologyService.drawTrinityCard();
      setState(() {
        _trinityCards = cards;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '抽牌失敗，請稍後再試。';
        _isLoading = false;
      });
    }
  }

  // 生成導引文案
  String _buildGuidanceText() {
    if (_trinityCards == null) {
      return '請點擊下方按鈕抽取您的三位一體牌組';
    }

    final protagonist = _trinityCards!['protagonist']!;
    final situation = _trinityCards!['situation']!;
    final style = _trinityCards!['style']!;

    // 核心商業邏輯：自動生成文案
    return '「${protagonist.name}」在「${situation.name}」，以「${style.name}」的方式呈現。';
  }

  @override
  Widget build(BuildContext context) {
    // UI 骨架，目前僅為佔位
    return Scaffold(
      appBar: AppBar(
        title: const Text('占星三位一體'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 這裡將來會顯示三張牌的 UI
            const SizedBox(height: 20),

            // 顯示組合文案
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _isLoading ? '正在為您抽取能量...' : _buildGuidanceText(),
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // 抽牌按鈕
            ElevatedButton(
              onPressed: _isLoading ? null : _drawCards,
              child: const Text('抽取三星牌'),
            ),

            // 錯誤訊息顯示
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),

            // 將來在這裡顯示詳細解釋和分享按鈕
          ],
        ),
      ),
    );
  }
}
