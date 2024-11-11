import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfolio/models/award.dart';

class AwardController {
  List<Award> awardlist = [];
  final CollectionReference _awardref =
  FirebaseFirestore.instance.collection('awards');

  Future<List<Award>> getAllAwards() async {
    QuerySnapshot snapshot = await _awardref.get();
    awardlist = snapshot.docs
        .map((doc) => Award.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    // print(awardlist);
    return awardlist;
  }
}
