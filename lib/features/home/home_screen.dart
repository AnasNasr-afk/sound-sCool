import 'package:flutter/material.dart';

enum PracticeStage { generate, recording, feedback }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String selectedLanguage = 'German';
  String selectedLevel = 'A2';
  PracticeStage currentStage = PracticeStage.generate;

  // Dummy data for the practice session
  String generatedText = '';
  List<String> words = [];
  List<Color> wordColors = [];
  bool isRecording = false;
  bool isGenerating = false;
  int finalScore = 0;
  int totalWords = 0;

  late AnimationController _recordingController;
  late Animation<double> _recordingAnimation;

  final Map<String, String> languageFlags = {
    'German': '🇩🇪',
    'Spanish': '🇪🇸',
    'French': '🇫🇷',
    'Italian': '🇮🇹',
  };

  @override
  void initState() {
    super.initState();
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _recordingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _recordingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _recordingController.dispose();
    super.dispose();
  }

  void _generateText() {
    setState(() {
      isGenerating = true;
    });

    // Simulate text generation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isGenerating = false;
        generatedText = 'Ich gehe heute zum Supermarkt. Ich kaufe Brot und Milch.';
        words = generatedText.split(' ');
        wordColors = List.filled(words.length, Colors.grey[400]!);
        currentStage = PracticeStage.recording;
      });
    });
  }

  void _startRecording() {
    setState(() {
      isRecording = true;
    });

    // Simulate word-by-word recognition with color feedback
    _simulateWordRecognition();
  }

  void _simulateWordRecognition() {
    int wordIndex = 0;
    final timer = Stream.periodic(const Duration(milliseconds: 800), (i) => i);

    timer.take(words.length).listen((index) {
      if (mounted && isRecording) {
        setState(() {
          // Simulate pronunciation accuracy - some green, some yellow
          if (index == 2 || index == 6) {
            wordColors[index] = Colors.yellow[600]!; // Mistakes
          } else {
            wordColors[index] = Colors.green[500]!; // Correct
          }
        });
      }
    }).onDone(() {
      if (mounted) {
        _finishRecording();
      }
    });
  }

  void _finishRecording() {
    setState(() {
      isRecording = false;
      currentStage = PracticeStage.feedback;

      // Calculate score
      int correctWords = wordColors.where((color) => color == Colors.green[500]!).length;
      totalWords = words.length;
      finalScore = ((correctWords / totalWords) * 10).round();
    });
  }

  void _tryAgain() {
    setState(() {
      currentStage = PracticeStage.recording;
      wordColors = List.filled(words.length, Colors.grey[400]!);
      isRecording = false;
      finalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Layer 1: Header
              _buildHeader(),
              const SizedBox(height: 24),

              // Layer 2: Learning Progress
              _buildLearningProgress(),
              const SizedBox(height: 24),

              // Layer 3: Language & Level Selection
              _buildLanguageSelection(),
              const SizedBox(height: 32),

              // Layer 4: Practice Area (The Magic Happens Here)
              Expanded(child: _buildPracticeArea()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ahlan Anas Nasr 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.mic, color: Colors.green[600], size: 14),
                const SizedBox(width: 4),
                Text(
                  '7 free records left',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.more_vert, color: Colors.grey[600], size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildLearningProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This Month',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '12 sessions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '↗️ +3 from last month',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.trending_up,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showLanguagePicker(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Text(languageFlags[selectedLanguage]!, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          selectedLanguage,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey[500], size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showLevelPicker(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedLevel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStageHeader(),
          const SizedBox(height: 24),
          Expanded(child: _buildStageContent()),
          const SizedBox(height: 24),
          _buildActionButton(),
          if (currentStage == PracticeStage.feedback) ...[
            const SizedBox(height: 16),
            _buildFeedbackScore(),
          ],
        ],
      ),
    );
  }

  Widget _buildStageHeader() {
    String title = '';
    String subtitle = '';

    switch (currentStage) {
      case PracticeStage.generate:
        title = 'Ready to Practice';
        subtitle = 'Generate or type your practice text';
        break;
      case PracticeStage.recording:
        title = isRecording ? 'Recording...' : 'Read the Text';
        subtitle = isRecording ? 'Speak clearly and naturally' : 'Tap to start recording';
        break;
      case PracticeStage.feedback:
        title = 'Great Job!';
        subtitle = 'Here\'s how you did';
        break;
    }

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStageContent() {
    switch (currentStage) {
      case PracticeStage.generate:
        return _buildGenerateContent();
      case PracticeStage.recording:
        return _buildRecordingContent();
      case PracticeStage.feedback:
        return _buildFeedbackContent();
    }
  }

  Widget _buildGenerateContent() {
    if (isGenerating) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Generating $selectedLevel $selectedLanguage text...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 2, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'Generate Practice Text',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI will create $selectedLevel level $selectedLanguage text',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Or type your own text to practice',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingContent() {
    return Column(
      children: [
        // Generated text with word-by-word coloring
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 8,
            children: words.asMap().entries.map((entry) {
              final index = entry.key;
              final word = entry.value;
              final color = wordColors[index];

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color == Colors.grey[400] ? Colors.transparent : color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color == Colors.grey[400] ? Colors.grey[800] : color,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        if (isRecording) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Recording...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFeedbackContent() {
    int correctWords = wordColors.where((color) => color == Colors.green[500]!).length;
    int incorrectWords = wordColors.where((color) => color == Colors.yellow[600]!).length;

    return Column(
      children: [
        // Text with final colors
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 8,
            children: words.asMap().entries.map((entry) {
              final index = entry.key;
              final word = entry.value;
              final color = wordColors[index];

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color == Colors.grey[400] ? Colors.transparent : color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color == Colors.grey[400] ? Colors.grey[800] : color,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Feedback stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFeedbackStat('Correct', correctWords.toString(), Colors.green[600]!),
            _buildFeedbackStat('Needs Work', incorrectWords.toString(), Colors.yellow[600]!),
            _buildFeedbackStat('Total', totalWords.toString(), Colors.grey[600]!),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedbackStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    IconData icon;
    String text;
    Color color;
    VoidCallback? onPressed;

    switch (currentStage) {
      case PracticeStage.generate:
        icon = Icons.auto_awesome;
        text = isGenerating ? 'Generating...' : 'Generate Text';
        color = Colors.blue[600]!;
        onPressed = isGenerating ? null : _generateText;
        break;
      case PracticeStage.recording:
        icon = isRecording ? Icons.stop : Icons.mic;
        text = isRecording ? 'Recording...' : 'Start Recording';
        color = isRecording ? Colors.red[600]! : Colors.blue[600]!;
        onPressed = isRecording ? _finishRecording : _startRecording;
        break;
      case PracticeStage.feedback:
        icon = Icons.refresh;
        text = 'Try Again';
        color = Colors.orange[600]!;
        onPressed = _tryAgain;
        break;
    }

    Widget buttonChild = Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: onPressed == null ? Colors.grey[300] : color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed == null ? [] : [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: onPressed == null ? Colors.grey[600] : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: onPressed == null ? Colors.grey[600] : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Add pulsing animation for recording state
    if (isRecording) {
      return AnimatedBuilder(
        animation: _recordingAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _recordingAnimation.value,
            child: buttonChild,
          );
        },
      );
    }

    return buttonChild;
  }

  Widget _buildFeedbackScore() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: finalScore >= 8 ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: finalScore >= 8 ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            finalScore >= 8 ? Icons.celebration : Icons.emoji_events,
            color: finalScore >= 8 ? Colors.green[600] : Colors.orange[600],
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Score: $finalScore/10',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: finalScore >= 8 ? Colors.green[700] : Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ...languageFlags.entries.map((entry) {
                return ListTile(
                  leading: Text(entry.value, style: const TextStyle(fontSize: 24)),
                  title: Text(entry.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  trailing: selectedLanguage == entry.key ? Icon(Icons.check, color: Colors.blue[600]) : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = entry.key;
                      // Reset to generate stage when language changes
                      currentStage = PracticeStage.generate;
                      generatedText = '';
                      words.clear();
                      wordColors.clear();
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showLevelPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Level',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'].map((level) {
                  final isSelected = level == selectedLevel;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLevel = level;
                        // Reset to generate stage when level changes
                        currentStage = PracticeStage.generate;
                        generatedText = '';
                        words.clear();
                        wordColors.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[600] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        level,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}