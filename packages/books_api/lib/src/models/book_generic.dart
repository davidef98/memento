import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'book_generic.g.dart';

/// {@template book_generic}
/// A generic representation of a book (work) as returned by the
/// Open Library Search API (`/search.json`).
///
/// Only the fields requested via the `fields` query parameter are
/// exposed, keeping payloads small.
/// {@endtemplate}
@immutable
@JsonSerializable()
class BookGeneric extends Equatable {
  /// {@macro book_generic}
  const BookGeneric({
    required this.key,
    required this.title,
    this.authorName,
    this.coverI,
    this.firstPublishYear,
    this.numberOfPagesMedium,
  });

  /// Creates a [BookGeneric] from a JSON map.
  factory BookGeneric.fromJson(Map<String, dynamic> json) =>
      _$BookGenericFromJson(json);

  /// The Open Library work key (e.g. `/works/OL1168083W`).
  final String key;

  /// The title of the work.
  final String title;

  /// The list of author names, if available.
  @JsonKey(name: 'author_name')
  final List<String>? authorName;

  /// The identifier of the cover image, if available.
  ///
  /// Combine with the Covers API to build an image URL:
  /// `https://covers.openlibrary.org/b/id/{coverI}-M.jpg`
  @JsonKey(name: 'cover_i')
  final int? coverI;

  /// The year the work was first published, if known.
  @JsonKey(name: 'first_publish_year')
  final int? firstPublishYear;

  /// The median page count across editions, if known.
  @JsonKey(name: 'number_of_pages_median')
  final int? numberOfPagesMedium;

  /// Converts this [BookGeneric] into a JSON map.
  Map<String, dynamic> toJson() => _$BookGenericToJson(this);

  @override
  List<Object?> get props => [
    key,
    title,
    authorName,
    coverI,
    firstPublishYear,
    numberOfPagesMedium,
  ];
}