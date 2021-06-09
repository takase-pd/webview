import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema_util.dart';
import 'serializers.dart';

part 'sites_record.g.dart';

abstract class SitesRecord implements Built<SitesRecord, SitesRecordBuilder> {
  static Serializer<SitesRecord> get serializer => _$sitesRecordSerializer;

  @nullable
  @BuiltValueField(wireName: 'site_name')
  String get siteName;

  @nullable
  @BuiltValueField(wireName: 'site_url')
  String get siteUrl;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(SitesRecordBuilder builder) => builder
    ..siteName = ''
    ..siteUrl = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('sites');

  static Stream<SitesRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  SitesRecord._();
  factory SitesRecord([void Function(SitesRecordBuilder) updates]) =
      _$SitesRecord;
}

Map<String, dynamic> createSitesRecordData({
  String siteName,
  String siteUrl,
}) =>
    serializers.serializeWith(
        SitesRecord.serializer,
        SitesRecord((s) => s
          ..siteName = siteName
          ..siteUrl = siteUrl));

SitesRecord get dummySitesRecord {
  final builder = SitesRecordBuilder()
    ..siteName = dummyString
    ..siteUrl = dummyString;
  return builder.build();
}

List<SitesRecord> createDummySitesRecord({int count}) =>
    List.generate(count, (_) => dummySitesRecord);
