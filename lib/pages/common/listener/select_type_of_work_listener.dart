import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';

abstract class SelectTypeOfWorkListener {
  // void onSelectTypeOfWork(int position, int typeOfWorkId, int companyTaskId,
  //     String name, String action);
  void onSelectTypeOfWork(
      List<TypeOfWorkResourcesInfo> listSelectedItems, String action);
}
