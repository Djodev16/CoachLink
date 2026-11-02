import 'package:flutter/material.dart';
import '../models/goal.dart'; 

class GoalsProvider with ChangeNotifier {
  final List<Goal> _goals = [];
  final List<String> _badges = [];

  List<Goal> get goals => _goals;
  List<String> get badges => _badges;

  int get completedGoalsCount => _goals.where((g) => g.progress >= g.target).length;

  void addGoal(String title) {
    _goals.add(Goal(
      title: title,
      progress: 0.0,
      target: 10.0, 
    )); 
    notifyListeners(); 
  }

  void incrementProgress(int index) {
    if (index >= 0 && index < _goals.length) {
      if (_goals[index].progress < _goals[index].target) {
        _goals[index].progress += 1.0;
        
        if (_goals[index].progress == _goals[index].target) {
          _checkAndAssignBadge(_goals[index].title);
        }
        
        notifyListeners(); 
      }
    }
  }

  void _checkAndAssignBadge(String goalTitle) {
    String newBadge = "";
    if (goalTitle.toLowerCase().contains("code") || goalTitle.contains("برمجة")) {
      newBadge = "💻 Developer Hero";
    } else if (goalTitle.toLowerCase().contains("piano") || goalTitle.contains("موسيقى")) {
      newBadge = "🎹 Maestro";
    } else if (goalTitle.toLowerCase().contains("english") || goalTitle.contains("لغة")) {
      newBadge = "🗣️ Polyglot";
    } else {
      newBadge = "🌟 Goal Crusher";
    }

    if (!_badges.contains(newBadge)) {
      _badges.add(newBadge);
    }
  }

  void decrementProgress(int index) {
    if (index >= 0 && index < _goals.length) {
      if (_goals[index].progress > 0) {
        _goals[index].progress -= 1.0;
        notifyListeners();
      }
    }
  }

  void deleteGoal(int index) {
    if (index >= 0 && index < _goals.length) {
      _goals.removeAt(index); 
      notifyListeners(); 
    }
  }
}