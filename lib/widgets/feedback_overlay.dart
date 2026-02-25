import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';

class FeedbackOverlay extends StatefulWidget {
  final String title;
  final String feedback;
  final String? correction;
  final double score;
  final VoidCallback onDismiss;

  const FeedbackOverlay({
    super.key,
    required this.title,
    required this.feedback,
    this.correction,
    required this.score,
    required this.onDismiss,
  });

  @override
  State<FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor() {
    if (widget.score >= 0.8) return BilinguiColors.successGreen;
    if (widget.score >= 0.5) return BilinguiColors.warningAmber;
    return BilinguiColors.errorRed;
  }

  IconData _getScoreIcon() {
    if (widget.score >= 0.8) return Icons.check_circle;
    if (widget.score >= 0.5) return Icons.info;
    return Icons.error;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: BilinguiColors.deepPurple.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getScoreIcon(),
                        color: _getScoreColor(),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: AppFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: BilinguiColors.textPrimary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onDismiss,
                        child: const Icon(Icons.close, color: BilinguiColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getScoreColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.feedback,
                      style: AppFonts.poppins(
                        fontSize: 14,
                        color: BilinguiColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (widget.correction != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BilinguiColors.lavender,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: BilinguiColors.deepPurple.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Suggested Correction:',
                            style: AppFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: BilinguiColors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.correction!,
                            style: AppFonts.poppins(
                              fontSize: 14,
                              color: BilinguiColors.textPrimary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score: ',
                        style: AppFonts.poppins(
                          fontSize: 16,
                          color: BilinguiColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(widget.score * 100).toInt()}%',
                        style: AppFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _getScoreColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
