import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:devops_midterm/public/bibleVerseData.dart';

class GenerateRandomPage extends StatefulWidget {
  final VoidCallback onBackHome;
  const GenerateRandomPage({super.key, required this.onBackHome});

  @override
  State<GenerateRandomPage> createState() => _GenerateRandomPageState();
}

class _GenerateRandomPageState extends State<GenerateRandomPage> with SingleTickerProviderStateMixin {
  Map<String, String>? _currentVerse;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGenerating = false;

  void _generateRandomVerse() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isGenerating = true;
    });
    _animationController.reverse().then((_) {
      final random = Random();
      final index = random.nextInt(bibleVerses.length);
      setState(() {
        _currentVerse = bibleVerses[index];
        _isGenerating = false;
      });
      _animationController.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    final random = Random();
    final index = random.nextInt(bibleVerses.length);
    _currentVerse = bibleVerses[index];
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.home, color: CupertinoColors.activeOrange),
          onPressed: widget.onBackHome,
        ),
        middle: const Text(
          'Random Bible Verse',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _currentVerse == null
              ? const Center(child: CupertinoActivityIndicator())
              : Column(
            children: [
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: CupertinoColors.systemGrey5,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.book_fill,
                            size: 40,
                            color: CupertinoColors.activeOrange.withOpacity(0.8),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _currentVerse!['reference'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeOrange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentVerse!['description'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: CupertinoColors.label,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: _isGenerating
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.refresh, size: 18, color: CupertinoColors.white),
                        const SizedBox(width: 8),
                        const Text(
                          'New Verse',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),
                    onPressed: _isGenerating ? null : _generateRandomVerse,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}