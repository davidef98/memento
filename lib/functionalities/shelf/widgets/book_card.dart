import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/functionalities/shelf/models/saved_book_extension.dart';
import 'package:memento/theme.dart';
import 'package:shelf_api/shelf_api.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/image_network_placeholders/barrel.dart';

/// A card widget representing a saved book within the user's shelf library.
///
/// Displays cover art fetched from Open Library (with loading and error fallbacks),
/// title, author names, page count, and a platform-adaptive trailing arrow.
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  /// The saved book entity containing details like title, authors, pages, and cover ID.
  final SavedBook book;

  /// Optional callback invoked when tapping the card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final cardWidth = media.width * 0.9;
    final cardHeight = media.height * 0.12;
    final imageWidth = cardWidth * 0.16;
    final imageHeight = media.height * 0.1;
    final textWidth = cardWidth * 0.80;
    final textPadding = media.width * 0.04;
    final actionButtonWidth = cardWidth * 0.04;
    final dividerMargin = cardWidth * 0.2;
    final isIOS = context.isIOS;

    /// Constructs the Open Library image URL.
    final coverUrl = book.coverI != null
        ? 'https://covers.openlibrary.org/b/id/${book.coverI}-M.jpg'
        : '';

    final authorsText = (book.authorName != null && book.authorName!.isNotEmpty)
        ? book.authorName!.join(', ')
        : null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Material(
          color: AppThemes.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            splashColor: AppThemes.transparent,
            highlightColor: AppThemes.transparent,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// Book cover image container
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppThemes.unselectedItemColor.withValues(alpha: 0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                          child: coverUrl.isNotEmpty
                              ? Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded || frame != null) {
                                return child;
                              }
                              return const ImageNetworkLoader(
                                radius: 8,
                                size: 16,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return ImageNetworkError(
                                maxLines: 2,
                                iconSize: 16,
                                iconColor: AppThemes.secondaryColor,
                                textStyle: UnifiedTextStyles.badge12,
                              );
                            },
                          )
                              : ImageNetworkError(
                            maxLines: 2,
                            iconSize: 16,
                            iconColor: AppThemes.secondaryColor,
                            textStyle: UnifiedTextStyles.badge12,
                          ),
                        ),
                      ),

                      /// Book details section (Title, Authors, Page Count)
                      Container(
                        width: textWidth,
                        padding: EdgeInsets.symmetric(horizontal: textPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: UnifiedTextStyles.bodyText16.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (authorsText != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                authorsText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: UnifiedTextStyles.bodyText15.copyWith(
                                  color: AppThemes.unselectedItemColor,
                                ),
                              ),
                            ],
                            if (book.numberOfPagesMedium != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  if (book.numberOfPagesMedium != null) ...[
                                    Text(
                                      '${book.numberOfPagesMedium} pag.',
                                      style: UnifiedTextStyles.badge12.copyWith(
                                        color: AppThemes.unselectedItemColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '•',
                                      style: UnifiedTextStyles.badge12.copyWith(
                                        color: AppThemes.unselectedItemColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  LectureProgress(
                                    status: book.readingStatus,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      /// Trailing navigation icon adapted for iOS/Android platforms.
                      SizedBox(
                        width: actionButtonWidth,
                        child: Center(
                          child: Icon(
                            isIOS ? CupertinoIcons.chevron_forward : Icons.arrow_forward,
                            size: 20,
                            color: AppThemes.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Indented bottom divider line.
                Container(
                  height: 0.5,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: dividerMargin),
                  color: AppThemes.unselectedItemColor.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LectureProgress extends StatelessWidget {
  final ReadingStatus status;
  final Color finishedIconColor;
  final Color inProgressIconColor;
  final Color notStartedIconColor;
  final double size;

  const LectureProgress({
    super.key,
    required this.status,
    this.finishedIconColor = AppThemes.accentColor2,
    this.inProgressIconColor = AppThemes.accentColor3,
    this.notStartedIconColor = AppThemes.secondaryColor,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final l10n = AppLocalizations.of(context)!;

    final IconData iconData = switch (status) {
      ReadingStatus.finished => isIOS ? CupertinoIcons.checkmark_alt_circle_fill : Icons.check_circle,
      ReadingStatus.inProgress => isIOS ? CupertinoIcons.book : Icons.menu_book,
      ReadingStatus.notStarted => isIOS ? CupertinoIcons.timer : Icons.timer,
    };

    final Color color = switch (status) {
      ReadingStatus.finished => finishedIconColor,
      ReadingStatus.inProgress => inProgressIconColor,
      ReadingStatus.notStarted => notStartedIconColor,
    };

    final String text = switch (status) {
      ReadingStatus.finished => l10n.readingStatusFinished,
      ReadingStatus.inProgress => l10n.readingStatusInProgress,
      ReadingStatus.notStarted => l10n.readingStatusNotStarted,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: size,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: UnifiedTextStyles.badge12.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}