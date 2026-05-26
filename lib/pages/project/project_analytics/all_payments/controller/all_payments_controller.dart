import 'package:belcka/pages/project/project_analytics/all_payments/model/payments_model.dart';
import 'package:get/get.dart';

class AllPaymentsController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isDataUpdated = false.obs;

  final received = [
    Payment(address: '1 Topham, Woodgreen', postcode: 'IG2 9PS', amount: 25000, date: DateTime(2025, 9, 16), status: PaymentStatus.paid),
    Payment(address: '24 Topham, Woodgreen', postcode: 'IP2 1PS', amount: 25000, date: DateTime(2025, 9, 16), status: PaymentStatus.paid),
    Payment(address: '168 Topham, Woodgreen', postcode: 'EG2 1PS', amount: 50000, date: DateTime(2025, 7, 12), status: PaymentStatus.paid),
    Payment(address: '3 Topham, Woodgreen', postcode: 'IG2 1PS', amount: 50000, date: DateTime(2025, 6, 13), status: PaymentStatus.paid),
    Payment(address: '12 Topham, Woodgreen', postcode: 'IG3 2PS', amount: 25000, date: DateTime(2025, 5, 20), status: PaymentStatus.paid),
    Payment(address: '7 Topham, Woodgreen', postcode: 'IP1 3PS', amount: 50000, date: DateTime(2025, 4, 8), status: PaymentStatus.paid),
  ];

  final invoiced = [
    Payment(address: '55 Topham, Woodgreen', postcode: 'IG4 1PS', amount: 30000, date: DateTime(2025, 10, 1), status: PaymentStatus.pending),
    Payment(address: '88 Topham, Woodgreen', postcode: 'EG1 2PS', amount: 45000, date: DateTime(2025, 9, 28), status: PaymentStatus.overdue),
    Payment(address: '101 Topham, Woodgreen', postcode: 'IG2 5PS', amount: 20000, date: DateTime(2025, 9, 15), status: PaymentStatus.pending),
  ];

  int tab = 0;
  bool incVat = false;

  List<Payment> get payments => tab == 0 ? received : invoiced;

  double get total {
    final sum = payments.fold(0.0, (s, p) => s + p.amount);
    return incVat ? sum * 1.2 : sum;
  }

  @override
  void onInit() {
    super.onInit();

  }
  void onBackPress() {
    Get.back();
  }
}
