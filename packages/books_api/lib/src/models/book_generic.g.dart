// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_generic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookGeneric _$BookGenericFromJson(Map<String, dynamic> json) => BookGeneric(
      key: json['key'] as String,
      title: json['title'] as String,
      authorName: (json['author_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      coverI: (json['cover_i'] as num?)?.toInt(),
      firstPublishYear: (json['first_publish_year'] as num?)?.toInt(),
      numberOfPagesMedium: (json['number_of_pages_median'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookGenericToJson(BookGeneric instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'author_name': instance.authorName,
      'cover_i': instance.coverI,
      'first_publish_year': instance.firstPublishYear,
      'number_of_pages_median': instance.numberOfPagesMedium,
    };
