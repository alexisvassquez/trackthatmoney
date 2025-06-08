class Goal {
    final String id;
    final String title;
    final double targetAmount;
    double savedAmount;
    final DateTime createdAt;
    List<double> milestones; // optional, calculated or user-defined
  
    Goal({
        required this.id,
        required this.title,
        required this.targetAmount,
        this.savedAmount = 0.0,
        DateTime? createdAt,
        List<double>? milestones,
    })    : createdAt = createdAt ?? DateTime.now(),
            milestones = milestones ?? generateDefaultMilestones(targetAmount);

    void addContribution(double amount) {
        savedAmount += amount;
    }

    bool get isCompleted => savedAmount >= targetAmount;

    double get progressPercent => (savedAmount / targetAmount).clamp(0.0, 1.0);

    List<double> getCompletedMilestones() {
        return milestones.where((m) => savedAmount >= m).toList();
    }

    Map<String, dynamic> toJson() => {
            'id': id,
            'title': title,
            'targetAmount': targetAmount,
            'savedAmount': savedAmount,
            'createdAt': createdAt.toIso8601String(),
            'milestones': milestones,
        };

    factory Goal.fromJson(Map<String, dynamic> json) {
        return Goal(    
            id: json['id'],
            title: json['title'],
            targetAmount: json['targetAmount'],
            savedAmount: json['savedAmount'],
            createdAt: DateTime.parse(json['createdAt']),
            milestones: List<double>.from(json['milestones']),
        );
    }
    
    static List<double> generateDefaultMilestones(double target) {
        List<double> steps = [];
        for (int i = 1; i <= 4; i++) {
            steps.add(target * i / 4);
        }
        return steps;
    }
}
