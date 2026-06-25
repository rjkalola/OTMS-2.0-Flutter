class ProjectAnalyticsResponse {
  final bool isSuccess;
  final String message;
  final ProjectAnalyticsInfo info;
  final int activeCompanyId;

  ProjectAnalyticsResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
    required this.activeCompanyId,
  });

  factory ProjectAnalyticsResponse.fromJson(Map<String, dynamic> json) {
    return ProjectAnalyticsResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: ProjectAnalyticsInfo.fromJson(json['info'] ?? {}),
      activeCompanyId: json['active_company_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IsSuccess': isSuccess,
      'message': message,
      'info': info.toJson(),
      'active_company_id': activeCompanyId,
    };
  }
}

class ProjectAnalyticsInfo {
  final Project project;
  final Budget budget;
  final Counts counts;

  ProjectAnalyticsInfo({
    required this.project,
    required this.budget,
    required this.counts,
  });

  factory ProjectAnalyticsInfo.fromJson(Map<String, dynamic> json) {
    return ProjectAnalyticsInfo(
      project: Project.fromJson(json['project'] ?? {}),
      budget: Budget.fromJson(json['budget'] ?? {}),
      counts: Counts.fromJson(json['counts'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project': project.toJson(),
      'budget': budget.toJson(),
      'counts': counts.toJson(),
    };
  }
}

class Project {
  final int id;
  final int companyId;
  final String name;
  final double budget;
  final bool status;
  final String startDate;
  final String? endDate;

  Project({
    required this.id,
    required this.companyId,
    required this.name,
    required this.budget,
    required this.status,
    required this.startDate,
    this.endDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      name: json['name'] ?? '',
      budget: (json['budget'] ?? 0).toDouble(),
      status: json['status'] ?? false,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'budget': budget,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

class Budget {
  final double projectBudget;
  final double allocatedBudget;
  final double remainingBudget;
  final List<BudgetBreakdown> breakdown;

  Budget({
    required this.projectBudget,
    required this.allocatedBudget,
    required this.remainingBudget,
    required this.breakdown,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      projectBudget: (json['project_budget'] ?? 0).toDouble(),
      allocatedBudget: (json['allocated_budget'] ?? 0).toDouble(),
      remainingBudget: (json['remaining_budget'] ?? 0).toDouble(),
      breakdown: (json['breakdown'] as List<dynamic>? ?? [])
          .map((e) => BudgetBreakdown.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_budget': projectBudget,
      'allocated_budget': allocatedBudget,
      'remaining_budget': remainingBudget,
      'breakdown': breakdown.map((e) => e.toJson()).toList(),
    };
  }
}

class BudgetBreakdown {
  final int id;
  final String type;
  final String budgetAmount;
  final double amount;

  BudgetBreakdown({
    required this.id,
    required this.type,
    required this.budgetAmount,
    required this.amount,
  });

  factory BudgetBreakdown.fromJson(Map<String, dynamic> json) {
    return BudgetBreakdown(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      budgetAmount: json['budget_amount']?.toString() ?? '0',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'budget_amount': budgetAmount,
      'amount': amount,
    };
  }
}

class Counts {
  final int addresses;
  final int tasks;
  final int checklogs;
  final int worklogs;

  Counts({
    required this.addresses,
    required this.tasks,
    required this.checklogs,
    required this.worklogs,
  });

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      addresses: json['addresses'] ?? 0,
      tasks: json['tasks'] ?? 0,
      checklogs: json['checklogs'] ?? 0,
      worklogs: json['worklogs'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addresses': addresses,
      'tasks': tasks,
      'checklogs': checklogs,
      'worklogs': worklogs,
    };
  }
}