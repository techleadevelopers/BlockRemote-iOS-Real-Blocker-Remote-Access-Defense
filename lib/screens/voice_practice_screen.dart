import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';
import '../providers/app_providers.dart';
import '../widgets/voice_button.dart';

class VoicePracticeScreen extends ConsumerWidget {
  const VoicePracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Voice Practice',
              style: AppFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: BilinguiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the mic and speak the phrase below',
              style: AppFonts.poppins(
                fontSize: 14,
                color: BilinguiColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: BilinguiColors.cardSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: BilinguiColors.softLilac.withOpacity(0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: BilinguiColors.deepPurple.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.format_quote,
                    color: BilinguiColors.deepPurple.withOpacity(0.3),
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"Could you tell me how to get to the nearest train station?"',
                    textAlign: TextAlign.center,
                    style: AppFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: BilinguiColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: BilinguiColors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Intermediate',
                      style: AppFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: BilinguiColors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SineWaveWidget(isActive: isRecording),
            const SizedBox(height: 16),
            Text(
              isRecording ? 'Listening...' : 'Tap to start',
              style: AppFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isRecording
                    ? BilinguiColors.deepPurple
                    : BilinguiColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            VoiceButton(
              isRecording: isRecording,
              onPressed: () {
                ref.read(isRecordingProvider.notifier).state = !isRecording;
              },
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BilinguiColors.lavender,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: BilinguiColors.deepPurple.withOpacity(0.6),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Speak clearly and at a natural pace for best results',
                      style: AppFonts.poppins(
                        fontSize: 13,
                        color: BilinguiColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
