import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfolio/models/crew.dart';

class CrewController {
  List<Crew> crewlist = [];
  final CollectionReference _crewref =
      FirebaseFirestore.instance.collection('crew');

  Future<List<Crew>> getAllCrew() async {
    QuerySnapshot snapshot = await _crewref.get();
    crewlist = snapshot.docs
        .map((doc) => Crew.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    // print(crewlist);
    return crewlist;
  }
}
