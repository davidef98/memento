import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'saved_book.g.dart';

/// {@template saved_book}
/// A book saved by the user in their personal library, persisted
/// on-device.
///
/// Deliberately decoupled from `books_api`'s remote models: this is
/// the local, persisted representation and can evolve independently
/// of whatever the remote API returns.
/// {@endtemplate}
@immutable
@JsonSerializable()
class SavedBook extends Equatable {
  /// {@macro saved_book}
  const SavedBook({
    required this.id,
    required this.title,
    required this.savedAt,
    this.authorName,
    this.coverI,
    this.numberOfPagesMedium,
    this.startDate,
    this.endDate,
  });

  /// Creates a [SavedBook] from a JSON map.
  factory SavedBook.fromJson(Map<String, dynamic> json) =>
      _$SavedBookFromJson(json);

  /// The unique identifier of the book (the Open Library work key,
  /// e.g. `/works/OL1168083W`).
  final String id;

  /// The title of the book.
  final String title;

  /// The list of author names, if available.
  final List<String>? authorName;

  /// The identifier of the cover image, if available.
  final int? coverI;

  /// The median page count across editions, if known.
  final int? numberOfPagesMedium;

  /// When the user added this book to their library.
  final DateTime savedAt;

  /// When the user started reading this book, if set.
  final DateTime? startDate;

  /// When the user finished reading this book, if set.
  final DateTime? endDate;

  /// Whether the user has marked this book as finished.
  bool get isCompleted => endDate != null;

  /// Returns a copy of this [SavedBook] with [startDate] and/or
  /// [endDate] replaced. Omitted (null) arguments leave the existing
  /// value unchanged.
  SavedBook copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SavedBook(
      id: id,
      title: title,
      authorName: authorName,
      coverI: coverI,
      numberOfPagesMedium: numberOfPagesMedium,
      savedAt: savedAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  /// Converts this [SavedBook] into a JSON map.
  Map<String, dynamic> toJson() => _$SavedBookToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    authorName,
    coverI,
    numberOfPagesMedium,
    savedAt,
    startDate,
    endDate,
  ];
}