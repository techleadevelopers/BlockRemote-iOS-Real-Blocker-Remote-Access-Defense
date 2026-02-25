import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';
import '../models/lesson.dart';
import '../providers/app_providers.dart';
import '../widgets/feedback_overlay.dart';
import '../widgets/gradient_button.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  final Lesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  bool _showFeedback = false;
  int _currentStep = 0;

  final _sampleSteps = const [
    LessonStep(
      instruction: 'Translate the following sentence:',
      type: 'translate',
      content: 'How are you doing today?',
    ),
    LessonStep(
      instruction: 'Listen and repeat:',
      type: 'speak',
      content: 'Nice to meet you!',
    ),
    LessonStep(
      instruction: 'Fill in the blank:',
      type: 'fill',
      content: 'I ___ learning English every day.',
    ),
  ];

  void _completeStep() {
    setState(() => _showFeedback = true);
  }

  void _nextStep() {
    setState(() {
      _showFeedback = false;
      if (_currentStep < _sampleSteps.length - 1) {
        _currentStep++;
      } else {
        ref.read(userStatsProvider.notifier).addXp(widget.lesson.xpReward);
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: BilinguiColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'Lesson Complete!',
              style: AppFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: BilinguiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+${widget.lesson.xpReward} XP earned',
              style: AppFonts.poppins(
                fontSize: 16,
                color: BilinguiColors.deepPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Continue',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = _sampleSteps[_currentStep];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F0FF), Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: BilinguiColors.cardSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: BilinguiColors.softLilac.withOpacity(0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: BilinguiColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Hero(
                            tag: 'lesson_${widget.lesson.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                widget.lesson.title,
                                style: AppFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: BilinguiColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${_currentStep + 1}/${_sampleSteps.length}',
                          style: AppFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: BilinguiColors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_currentStep + 1) / _sampleSteps.length,
                        backgroundColor: BilinguiColors.softLilac.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          BilinguiColors.deepPurple,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: BilinguiColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              step.type == 'translate'
                                  ? Icons.translate
                                  : step.type == 'speak'
                                      ? Icons.record_voice_over
                                      : Icons.edit_note,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            step.instruction,
                            textAlign: TextAlign.center,
                            style: AppFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: BilinguiColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: BilinguiColors.cardSurface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: BilinguiColors.softLilac.withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              step.content,
                              textAlign: TextAlign.center,
                              style: AppFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: BilinguiColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: BilinguiColors.softLilac.withOpacity(0.3),
                              ),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Type your answer here...',
                                hintStyle: AppFonts.poppins(
                                  color: BilinguiColors.textSecondary.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                              ),
                              style: AppFonts.poppins(
                                fontSize: 16,
                                color: BilinguiColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          GradientButton(
                            text: 'Check Answer',
                            onPressed: _completeStep,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_showFeedback)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FeedbackOverlay(
                    title: 'Good Job!',
                    feedback:
                        'Your answer is mostly correct. Keep practicing to improve your accuracy.',
                    correction: 'Consider using "am" instead of "is" in this context.',
                    score: 0.85,
                    onDismiss: _nextStep,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
