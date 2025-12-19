
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// App 根組件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '星領神絵',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0D0F14),
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
        fontFamily: 'NotoSansTC', // 可以考慮添加適合的字體
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/quiz': (context) => const QuizPage(),
      },
    );
  }
}

// 新的入口頁面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 頂部 Logo 和標語
                Row(
                  children: [
                    Image.asset('assets/images/logo.png', width: 50, height: 50),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '24 小時在线陪伴,',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                          ),
                          Text(
                            '為你的情绪找到出口',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '24/7 companionship, a way out for your emotions',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // 心理測驗模塊
                ModuleCard(
                  icon: Icons.psychology,
                  title: '心理測驗',
                  subtitle: 'Psychological insight Test',
                  description: '揍秉你此刻的內在狀態',
                  buttonText: '開始測驗',
                  buttonColor: const Color(0xFF4A4E69),
                  onPressed: () {
                    Navigator.pushNamed(context, '/quiz');
                  },
                ),
                const SizedBox(height: 24),

                // 占星牌卡模塊
                ModuleCard(
                  icon: Icons.filter_vintage,
                  title: '占星牌卡',
                  subtitle: 'Astrology Guidance Cards',
                  description: 'Signs × 行星 × 宮位・全方位指引',
                  buttonText: '抽一張牌',
                  buttonColor: const Color(0xFF0081A7),
                  onPressed: () {
                    // TODO: 導航到占星牌卡頁面
                  },
                ),
                const SizedBox(height: 24),

                // 塔羅牌專區模塊
                ModuleCard(
                  icon: Icons.style, // 這裡用一個風格圖示作為塔羅牌的代表
                  title: '塔羅牌專區',
                  subtitle: 'Tarot Reading',
                  description: '探索你的人生、事業、愛情，獲得指引',
                  buttonText: '開始占卜',
                  buttonColor: const Color(0xFF5C549A), // 新增一個紫色調按鈕
                  onPressed: () {
                    // TODO: 導航到塔羅牌頁面
                  },
                ),
                const SizedBox(height: 40),

                // 底部 VIP 和諮詢按鈕
                Row(
                  children: [
                    Expanded(
                      child: BottomButton(
                        icon: Icons.star,
                        text: 'VIP 深度解析',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BottomButton(
                        icon: Icons.headset_mic,
                        text: '專人諮詢預約',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// 可重用的功能模塊卡片
class ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  const ModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(description, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(buttonText, style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// 底部按鈕
class BottomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const BottomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF1E1E2E),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
      ),
    );
  }
}


// 原本的測驗頁面，已重命名為 QuizPage
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? _question; // 問題文字
  List<String> _options = []; // 選項陣列
  List<String> _results = []; // 結果陣列
  bool _isLoading = true; // 是否正在載入資料

  @override
  void initState() {
    super.initState();
    // 頁面初始化時，從 Firestore 抓取資料
    _fetchQuizData();
  }

  // 從 Firestore 的 'psychology_tests/Q1' 文件抓取資料
  Future<void> _fetchQuizData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('psychology_tests')
          .doc('Q1')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // 更新畫面狀態
          setState(() {
            _question = data['question'] as String?;
            // 將 Firestore 回傳的 List<dynamic> 轉換為 List<String>
            _options = List<String>.from(data['options'] as List);
            _results = List<String>.from(data['results'] as List);
            _isLoading = false; // 載入完成
          });
        }
      } else {
        // 文件不存在
        setState(() {
          _isLoading = false;
        });
        print("錯誤：找不到 'psychology_tests/Q1' 文件");
      }
    } catch (e) {
      // 發生錯誤
      setState(() {
        _isLoading = false;
      });
      print("抓取資料時發生錯誤: $e");
    }
  }

  // 根據按鈕索引顯示對應的結果彈窗
  void _showResultDialog(int index) {
    // 確保索引在結果陣列的範圍內
    if (index < _results.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E2E),
            content: Text(_results[index], style: const TextStyle(color: Colors.white)),
            actions: <Widget>[
              TextButton(
                child: const Text('關閉', style: TextStyle(color: Colors.white70)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('心理測驗'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _question == null
                ? const Text('找不到問題資料。')
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          _question!,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ..._options.asMap().entries.map((entry) {
                          int idx = entry.key;
                          String optionText = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              onPressed: () => _showResultDialog(idx),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A4E69),
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(optionText),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
