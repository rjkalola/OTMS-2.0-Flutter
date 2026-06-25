import 'package:flutter/cupertino.dart';

class ProjectBudgetAnalyticsResponse {
  final bool isSuccess;
  final String message;
  final BudgetAnalyticsInfo info;
  final int activeCompanyId;

  ProjectBudgetAnalyticsResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
    required this.activeCompanyId,
  });

  factory ProjectBudgetAnalyticsResponse.fromJson(
      Map<String, dynamic> json) {
    return ProjectBudgetAnalyticsResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: BudgetAnalyticsInfo.fromJson(json['info'] ?? {}),
      activeCompanyId: json['active_company_id'] ?? 0,
    );
  }
}

class BudgetAnalyticsInfo {
  final String currency;
  final double profit;
  final double totalBudget;
  final double totalSpent;
  final double totalLeft;
  final double totalOverSpending;
  final BudgetCategories budgets;

  BudgetAnalyticsInfo({
    required this.currency,
    required this.profit,
    required this.totalBudget,
    required this.totalSpent,
    required this.totalLeft,
    required this.totalOverSpending,
    required this.budgets,
  });

  factory BudgetAnalyticsInfo.fromJson(Map<String, dynamic> json) {
    return BudgetAnalyticsInfo(
      currency: json['currency'] ?? '',
      profit: (json['profit'] ?? 0).toDouble(),
      totalBudget: (json['total_budget'] ?? 0).toDouble(),
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      totalLeft: (json['total_left'] ?? 0).toDouble(),
      totalOverSpending: (json['total_over_spending'] ?? 0).toDouble(),
      budgets: BudgetCategories.fromJson(json['budgets'] ?? {}),
    );
  }
}

class BudgetCategories {
  final BudgetItemAnalytics labor;
  final BudgetItemAnalytics materials;
  final BudgetItemAnalytics others;

  BudgetCategories({
    required this.labor,
    required this.materials,
    required this.others,
  });

  factory BudgetCategories.fromJson(Map<String, dynamic> json) {
    return BudgetCategories(
      labor: BudgetItemAnalytics.fromJson(json['labor'] ?? {}),
      materials: BudgetItemAnalytics.fromJson(json['materials'] ?? {}),
      others: BudgetItemAnalytics.fromJson(json['others'] ?? {}),
    );
  }
}

class BudgetItemAnalytics {
  final double budget;
  final double spent;
  final double left;
  final double overSpending;

  BudgetItemAnalytics({
    required this.budget,
    required this.spent,
    required this.left,
    required this.overSpending,
  });

  factory BudgetItemAnalytics.fromJson(Map<String, dynamic> json) {
    return BudgetItemAnalytics(
      budget: (json['budget'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
      left: (json['left'] ?? 0).toDouble(),
      overSpending: (json['over_spending'] ?? 0).toDouble(),
    );
  }
}
