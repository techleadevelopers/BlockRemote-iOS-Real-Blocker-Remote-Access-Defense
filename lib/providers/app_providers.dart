import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_stats.dart';
import '../models/lesson.dart';
import '../models/chat_message.dart';
import 'package:flutter/material.dart';

final userStatsProvider = StateNotifierProvider<UserStatsNotifier, UserStats>(
  (ref) => UserStatsNotifier(),
);

class UserStatsNotifier extends StateNotifier<UserStats> {
  UserStatsNotifier() : super(const UserStats());

  void addXp(int amount) {
    int newXp = state.currentXp + amount;
    int newLevel = state.level;
    int newMaxXp = state.maxXp;
    if (newXp >= state.maxXp) {
      newXp = newXp - state.maxXp;
      newLevel++;
      newMaxXp = (state.maxXp * 1.2).toInt();
    }
    state = UserStats(
      currentXp: newXp,
      maxXp: newMaxXp,
      level: newLevel,
      streak: state.streak,
      speakingScore: state.speakingScore,
      readingScore: state.readingScore,
      grammarScore: state.grammarScore,
      listeningScore: state.listeningScore,
      writingScore: state.writingScore,
    );
  }
}

final lessonsProvider = Provider<List<Lesson>>((ref) {
  return const [
    Lesson(
      id: '1',
      title: 'Greetings',
      subtitle: 'Learn basic greetings and introductions',
      icon: Icons.waving_hand,
      progress: 0.8,
      xpReward: 50,
      difficulty: 'Beginner',
    ),
    Lesson(
      id: '2',
      title: 'Daily Routine',
      subtitle: 'Describe your daily activities',
      icon: Icons.wb_sunny,
      progress: 0.5,
      xpReward: 75,
      difficulty: 'Beginner',
    ),
    Lesson(
      id: '3',
      title: 'Food & Drinks',
      subtitle: 'Order at restaurants and cafes',
      icon: Icons.restaurant,
      progress: 0.2,
      xpReward: 100,
      difficulty: 'Intermediate',
    ),
    Lesson(
      id: '4',
      title: 'Travel Talk',
      subtitle: 'Navigate airports, hotels and transport',
      icon: Icons.flight,
      progress: 0.0,
      xpReward: 120,
      difficulty: 'Intermediate',
    ),
    Lesson(
      id: '5',
      title: 'Business English',
      subtitle: 'Professional conversations and emails',
      icon: Icons.business_center,
      progress: 0.0,
      xpReward: 150,
      difficulty: 'Advanced',
      isLocked: true,
    ),
    Lesson(
      id: '6',
      title: 'Idioms & Slang',
      subtitle: 'Common expressions and cultural phrases',
      icon: Icons.auto_awesome,
      progress: 0.0,
      xpReward: 200,
      difficulty: 'Advanced',
      isLocked: true,
    ),
  ];
});

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(
  (ref) => ChatMessagesNotifier(),
);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier()
      : super([
          ChatMessage(
            id: '0',
            text: 'Hello! I\'m your AI language tutor. How can I help you practice today? 🎓',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void setTyping(bool isTyping) {
    if (isTyping) {
      state = [
        ...state,
        ChatMessage(
          id: 'typing',
          text: '',
          isUser: false,
          timestamp: DateTime.now(),
          isTyping: true,
        ),
      ];
    } else {
      state = state.where((m) => !m.isTyping).toList();
    }
  }
}

final currentPageProvider = StateProvider<int>((ref) => 0);

final isRecordingProvider = StateProvider<bool>((ref) => false);
