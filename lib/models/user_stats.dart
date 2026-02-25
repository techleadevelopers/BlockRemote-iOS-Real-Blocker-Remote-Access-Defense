class UserStats {
  final int currentXp;
  final int maxXp;
  final int level;
  final int streak;
  final double speakingScore;
  final double readingScore;
  final double grammarScore;
  final double listeningScore;
  final double writingScore;

  const UserStats({
    this.currentXp = 450,
    this.maxXp = 1000,
    this.level = 7,
    this.streak = 12,
    this.speakingScore = 0.7,
    this.readingScore = 0.85,
    this.grammarScore = 0.6,
    this.listeningScore = 0.75,
    this.writingScore = 0.5,
  });
}
