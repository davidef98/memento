// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetail _$BookDetailFromJson(Map<String, dynamic> json) => BookDetail(
      key: json['key'] as String,
      title: json['title'] as String,
      description: _descriptionFromJson(json['description']),
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      covers: (json['covers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      firstPublishDate: json['first_publish_date'] as String?,
    );

Map<String, dynamic> _$BookDetailToJson(BookDetail instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'description': _descriptionToJson(instance.description),
      'subjects': instance.subjects,
      'covers': instance.covers,
      'first_publish_date': instance.firstPublishDate,
    };
