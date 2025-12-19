
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/astrology_service.dart';
import '../../models/astrology_card.dart';

class AstrologyTrinityDrawScreen extends StatefulWidget {
  const AstrologyTrinityDrawScreen({super.key});

  @override
  State<AstrologyTrinityDrawScreen> createState() =>
      _AstrologyTrinityDrawScreenState();
}

class _AstrologyTrinityDrawScreenState
    extends State<AstrologyTrinityDrawScreen> {
  final AstrologyService _astrologyService = AstrologyService();
  Map<String, AstrologyCard>? _trinityCards;
  bool _isLoading = false;
  String? _error;

  // 抽牌邏輯
  Future<void> _drawCards() async {
    setState(() {
      _isLoading = true;
      _error = null;
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

  // 生成最終分享的完整文案
  String _buildFullShareText() {
    if (_trinityCards == null) return '';
    
    final protagonist = _trinityCards!['protagonist']!;
    final situation = _trinityCards!['situation']!;
    final style = _trinityCards!['style']!;

    return '''
占星三位一體指引：
${_buildGuidanceText()}

【主角：${protagonist.name}】
${protagonist.description}

【情境：${situation.name}】
${situation.description}

【風格：${style.name}】
${style.description}

【綜合建議】
${protagonist.advice}
${situation.advice}
${style.advice}
''';
  }

  // 生成核心導引文案
  String _buildGuidanceText() {
    if (_trinityCards == null) {
      return '請點擊下方按鈕抽取您的三位一體牌組';
    }

    final protagonist = _trinityCards!['protagonist']!;
    final situation = _trinityCards!['situation']!;
    final style = _trinityCards!['style']!;

    return '「${protagonist.name}」在「${situation.name}」，以「${style.name}」的方式呈現。';
  }

  // 分享功能
  void _shareResult() {
    if (_trinityCards != null) {
      final shareText = _buildFullShareText();
      Share.share(shareText, subject: '我的占星三位一體牌組');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // 深藍紫色背景
      appBar: AppBar(
        title: const Text('占星三位一體', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: _trinityCards == null
          ? null
          : FloatingActionButton(
              onPressed: _shareResult,
              backgroundColor: const Color(0xFFE94560),
              child: const Icon(Icons.share),
            ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE94560)));
    }

    if (_error != null) {
      return Center(
          child: Text(_error!, style: const TextStyle(color: Colors.redAccent)));
    }

    if (_trinityCards == null) {
      return _buildInitialView();
    }

    return _buildResultView();
  }
  
  // 初始介面
  Widget _buildInitialView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Color(0xFFF0C419), size: 100),
          const SizedBox(height: 20),
          const Text(
            '探索宇宙給你的指引',
            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            '點擊按鈕，抽取代表你的主角、情境與風格',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome),
            label: const Text('抽取三星牌'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFE94560),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: _drawCards,
          ),
        ],
      ),
    );
  }

  // 結果介面
  Widget _buildResultView() {
    final protagonist = _trinityCards!['protagonist']!;
    final situation = _trinityCards!['situation']!;
    final style = _trinityCards!['style']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 組合文案
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            ),
            child: Text(
              _buildGuidanceText(),
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          // 三張卡片
          _buildAstrologyCard('主角', protagonist),
          _buildAstrologyCard('情境', situation),
          _buildAstrologyCard('風格', style),
          const SizedBox(height: 30),
          // 重新抽牌按鈕
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('再抽一次'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0F3460),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: _drawCards,
          ),
          const SizedBox(height: 80), // 為 FAB 留出空間
        ],
      ),
    );
  }

  // 單張卡片的 Widget
  Widget _buildAstrologyCard(String title, AstrologyCard card) {
    return Card(
      color: const Color(0xFF16213E).withOpacity(0.8),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          '$title：${card.name}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: const Text(
          '點擊展開查看詳解與建議',
          style: TextStyle(color: Colors.white70),
        ),
        iconColor: const Color(0xFFE94560),
        collapsedIconColor: const Color(0xFFF0C419),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('詳解'),
                Text(card.description, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
                const SizedBox(height: 16),
                _buildSectionHeader('建議'),
                Text(card.advice, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        '【 $title 】',
        style: const TextStyle(
          color: Color(0xFFF0C419),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
