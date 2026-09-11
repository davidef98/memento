import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'book_generic.dart';

part 'book_list_results.g.dart';

/// {@template book_list_results}
/// The response returned by the Open Library Search API
/// (`/search.json`): a page of [BookGeneric] results.
/// {@endtemplate}
@immutable
@JsonSerializable()
class BookListResults extends Equatable {
  /// {@macro book_list_results}
  const BookListResults({
    required this.numFound,
    required this.start,
    required this.numFoundExact,
    required this.docs,
  });

  /// Creates a [BookListResults] from a JSON map.
  factory BookListResults.fromJson(Map<String, dynamic> json) =>
      _$BookListResultsFromJson(json);

  /// The total number of matching results found by the search.
  final int numFound;

  /// The offset of the first result in this page.
  final int start;

  /// Whether [numFound] is an exact count.
  final bool numFoundExact;

  /// The list of books returned for this page of results.
  final List<BookGeneric> docs;

  /// Converts this [BookListResults] into a JSON map.
  Map<String, dynamic> toJson() => _$BookListResultsToJson(this);

  @override
  List<Object?> get props => [numFound, start, numFoundExact, docs];
}