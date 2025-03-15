import 'package:devops_midterm/public/bibleVerseData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class GenerateByTopicPage extends StatefulWidget {
  final VoidCallback onBackHome;
  const GenerateByTopicPage({super.key, required this.onBackHome});

  @override
  State<GenerateByTopicPage> createState() => _GenerateByTopicPageState();
}

class _GenerateByTopicPageState extends State<GenerateByTopicPage> {
  String? selectedTopic;
  List<String> topics = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a short loading delay.
    Future.delayed(const Duration(milliseconds: 300), () {
      final Set<String> topicSet = {};
      for (var verse in bibleVerses) {
        final topicsStr = verse['topic'] ?? "";
        // Each verse's topic may be comma-separated.
        for (var t in topicsStr.split(',')) {
          final trimmed = t.trim();
          if (trimmed.isNotEmpty) {
            topicSet.add(trimmed);
          }
        }
      }
      setState(() {
        topics = topicSet.toList()..sort();
        isLoading = false;
      });
    });
  }

  void _selectTopic(String topic) {
    HapticFeedback.selectionClick();
    setState(() {
      selectedTopic = selectedTopic == topic ? null : topic;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter verses that match the selected topic.
    final filteredVerses = selectedTopic == null
        ? []
        : bibleVerses.where((verse) {
      final verseTopics = (verse['topic'] ?? "")
          .split(',')
          .map((t) => t.trim())
          .toList();
      return verseTopics.contains(selectedTopic);
    }).toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.home, color: CupertinoColors.activeOrange),
          onPressed: widget.onBackHome,
        ),
        middle: const Text(
          'Bible Verse by Topic',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      child: SafeArea(
        child: isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a Topic',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Display topics as small tag-like buttons.
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 10.0,
                      children: topics.map((topic) {
                        final isSelected = topic == selectedTopic;
                        return GestureDetector(
                          onTap: () => _selectTopic(topic),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? CupertinoColors.activeOrange : CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              topic,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? CupertinoColors.white : CupertinoColors.label,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    if (selectedTopic != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Text(
                              'Verses about "$selectedTopic"',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.label,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${filteredVerses.length} found',
                              style: TextStyle(
                                fontSize: 15,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Show a placeholder if no topic is selected.
            selectedTopic == null
                ? SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.book, size: 48, color: CupertinoColors.systemGrey),
                    const SizedBox(height: 16),
                    Text(
                      "Select a topic to view verses",
                      style: TextStyle(fontSize: 17, color: CupertinoColors.secondaryLabel),
                    ),
                  ],
                ),
              ),
            )
                : filteredVerses.isEmpty
                ? SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.search, size: 48, color: CupertinoColors.systemGrey),
                    const SizedBox(height: 16),
                    Text(
                      "No verses found for this topic",
                      style: TextStyle(fontSize: 17, color: CupertinoColors.secondaryLabel),
                    ),
                  ],
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final verse = filteredVerses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: CupertinoColors.systemGrey5, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            verse['reference'] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeOrange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            verse['description'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: filteredVerses.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
