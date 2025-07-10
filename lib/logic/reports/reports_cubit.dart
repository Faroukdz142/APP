import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/report.dart';


part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());


  Future<void> getReports()async{
    emit(ReportsLoading());
    List<Report> reports =[];
    final usersReports = await FirebaseFirestore.instance.collection("reports").get();
    for (var x in usersReports.docs){
        reports.add(Report.fromJson(x.data()));
    }
    emit(ReportsSuccess(reports: reports));
  }
}
