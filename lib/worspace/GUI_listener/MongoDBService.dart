

import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  final db = Db('mongodb://192.168.1.100:27017/SAIF');
  var collection;
  String collection_Name ="";

  MongoDBService( String collectionName) {
    collection_Name = collectionName;
  }

  Future<void> connect() async {
    await db.open();
    collection = db.collection(collection_Name);
  }

  Future<List<dynamic>> fetchData() async {
    final documents = await collection.find().toList();
    print(documents);
    return documents.map((doc) => doc as Map<String, dynamic>).toList();
  }
/**
  Stream<Stream> watchChanges() {
    return collection.watch();
  }*/
}
