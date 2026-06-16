class FormSubmissionStatusInfo {
  bool? hasAssignedForm;
  bool? hasPendingForm;
  bool? allAssignedFormsSubmitted;
  int? totalAssignedForms;
  int? submittedForms;
  int? pendingForms;

  FormSubmissionStatusInfo({
    this.hasAssignedForm,
    this.hasPendingForm,
    this.allAssignedFormsSubmitted,
    this.totalAssignedForms,
    this.submittedForms,
    this.pendingForms,
  });

  FormSubmissionStatusInfo.fromJson(Map<String, dynamic> json) {
    hasAssignedForm = json['has_assigned_form'];
    hasPendingForm = json['has_pending_form'];
    allAssignedFormsSubmitted = json['all_assigned_forms_submitted'];
    totalAssignedForms = json['total_assigned_forms'];
    submittedForms = json['submitted_forms'];
    pendingForms = json['pending_forms'];
  }

  Map<String, dynamic> toJson() {
    return {
      'has_assigned_form': hasAssignedForm,
      'has_pending_form': hasPendingForm,
      'all_assigned_forms_submitted': allAssignedFormsSubmitted,
      'total_assigned_forms': totalAssignedForms,
      'submitted_forms': submittedForms,
      'pending_forms': pendingForms,
    };
  }
}
