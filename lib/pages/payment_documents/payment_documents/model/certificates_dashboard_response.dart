class CertificatesDashboardResponse {
  bool? isSuccess;
  String? message;
  CertificatesDashboardInfo? info;
  int? activeCompanyId;

  CertificatesDashboardResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.activeCompanyId,
  });

  CertificatesDashboardResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? CertificatesDashboardInfo.fromJson(json['info'])
        : null;
    activeCompanyId = json['active_company_id'];
  }
}

class CertificatesDashboardInfo {
  int? valid;
  int? expiringSoon;
  int? expired;
  int? insurance;
  int? totalCertificates;

  CertificatesDashboardInfo({
    this.valid,
    this.expiringSoon,
    this.expired,
    this.insurance,
    this.totalCertificates,
  });

  CertificatesDashboardInfo.fromJson(Map<String, dynamic> json) {
    valid = json['valid'];
    expiringSoon = json['expiring_soon'];
    expired = json['expired'];
    insurance = json['insurance'];
    totalCertificates = json['total_certificates'];
  }
}
