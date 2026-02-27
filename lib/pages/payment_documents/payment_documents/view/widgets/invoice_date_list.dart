import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_date_info.dart';
import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/invoice_list.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceDateList extends StatelessWidget {
  InvoiceDateList({super.key, required this.searchText});

  final String searchText;
  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredRecords = controller.listInvoices
          .map((record) {
            final filteredData = (record.data ?? []).where((log) {
              if (StringHelper.isEmptyString(searchText)) return true;
              final name = log.userName?.toLowerCase() ?? '';
              return name.contains(searchText.toLowerCase());
            }).toList();
            return InvoiceDateInfo(
              date: record.date,
              data: filteredData,
            );
          })
          .where((r) => (r.data?.isNotEmpty ?? false))
          .toList();

      return Expanded(
        child: filteredRecords.isNotEmpty
            ? ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final info = filteredRecords[index];
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: TitleTextView(
                            text: info.date ?? "",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        InvoiceList(
                          parentPosition: index,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, _) => const SizedBox(height: 0),
                itemCount: filteredRecords.length,
              )
            : Center(
                child: NoDataFoundWidget(),
              ),
      );
    });
  }
}
