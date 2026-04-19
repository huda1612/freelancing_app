import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';

class SpecialSkillsService {
  SpecialSkillsService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<Either<StatusClasses , List<SpecializationModel>>> getAllSpecializations() async{
    var query = _firebaseFirestore.collection(CollectionsNames.specializations);
    var response = await FirebaseCrud.runGetQuery<SpecializationModel>(query: query, fromMap: (data ,id) => SpecializationModel.fromMap(data , idSlug: id));
    return response;
  } 
}
