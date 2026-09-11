// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_list_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookListResults _$BookListResultsFromJson(Map<String, dynamic> json) =>
    BookListResults(
      numFound: (json['numFound'] as num).toInt(),
      start: (json['start'] as num).toInt(),
      numFoundExact: json['numFoundExact'] as bool,
      docs: (json['docs'] as List<dynamic>)
          .map((e) => BookGeneric.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookListResultsToJson(BookListResults instance) =>
    <String, dynamic>{
      'numFound': instance.numFound,
      'start': instance.start,
      'numFoundExact': instance.numFoundExact,
      'docs': instance.docs,
    };
