
import 'package:devops_app_midterm/pages/generateByTopic.dart';
import 'package:devops_app_midterm/pages/generateRandom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _started = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startApp() {
    HapticFeedback.lightImpact();
    setState(() {
      _started = true;
    });
  }

  // Callback to return to the landing screen.
  void _goHome() {
    HapticFeedback.lightImpact();
    setState(() {
      _started = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemBackground,
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            'Bible Verse Generator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          backgroundColor: CupertinoColors.systemBackground,
          border: null,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                          ),
                        ),
                        onPressed: _startApp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Create the pages and pass the _goHome callback.
      final pages = [
        GenerateByTopicPage(onBackHome: _goHome),
        GenerateRandomPage(onBackHome: _goHome),
      ];
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: CupertinoColors.activeOrange,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'By Topic',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.shuffle),
              label: 'Random',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) => pages[index],
          );
        },
      );
    }
  }
}
