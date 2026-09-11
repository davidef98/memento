// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedBook _$SavedBookFromJson(Map<String, dynamic> json) => SavedBook(
      id: json['id'] as String,
      title: json['title'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
      authorName: (json['authorName'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      coverI: (json['coverI'] as num?)?.toInt(),
      numberOfPagesMedium: (json['numberOfPagesMedium'] as num?)?.toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$SavedBookToJson(SavedBook instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorName': instance.authorName,
      'coverI': instance.coverI,
      'numberOfPagesMedium': instance.numberOfPagesMedium,
      'savedAt': instance.savedAt.toIso8601String(),
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
