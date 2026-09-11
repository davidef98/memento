import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'book_detail.g.dart';

/// {@template book_detail}
/// Detailed information about a single work, as returned by the
/// Open Library Works API (`/works/{key}.json`).
/// {@endtemplate}
@immutable
@JsonSerializable()
class BookDetail extends Equatable {
  /// {@macro book_detail}
  const BookDetail({
    required this.key,
    required this.title,
    this.description,
    this.subjects,
    this.covers,
    this.firstPublishDate,
  });

  /// An empty [BookDetail], used as the default state value before
  /// any book detail has actually been fetched.
  static const empty = BookDetail(key: '', title: '');

  /// Creates a [BookDetail] from a JSON map.
  factory BookDetail.fromJson(Map<String, dynamic> json) =>
      _$BookDetailFromJson(json);

  /// The Open Library work key (e.g. `/works/OL1168083W`).
  final String key;

  /// The title of the work.
  final String title;

  /// A synopsis of the work, if available.
  ///
  /// Open Library returns this either as a plain [String] or as an
  /// object `{"type": "/type/text", "value": "..."}`. Both shapes are
  /// normalized to a plain [String] here.
  @JsonKey(fromJson: _descriptionFromJson, toJson: _descriptionToJson)
  final String? description;

  /// The subjects/genres associated with the work, if available.
  final List<String>? subjects;

  /// The identifiers of the cover images associated with the work.
  ///
  /// Combine with the Covers API to build image URLs:
  /// `https://covers.openlibrary.org/b/id/{coverId}-M.jpg`
  final List<int>? covers;

  /// The first publish date of the work, if known.
  @JsonKey(name: 'first_publish_date')
  final String? firstPublishDate;

  /// Converts this [BookDetail] into a JSON map.
  Map<String, dynamic> toJson() => _$BookDetailToJson(this);

  @override
  List<Object?> get props => [
    key,
    title,
    description,
    subjects,
    covers,
    firstPublishDate,
  ];
}

String? _descriptionFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map<String, dynamic>) return value['value'] as String?;
  return null;
}

dynamic _descriptionToJson(String? description) => description;