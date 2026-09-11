import 'package:books_api/books_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/theme.dart';

import '../../../utilities/utilities.dart';
import '../../../widgets/image_network_placeholders/barrel.dart';

/// A card widget representing an individual book search result.
///
/// Displays the book's cover image (with fallback placeholders), title,
/// authors list, page count, and a platform-adaptive trailing chevron indicator.
class SearchResultBookCard extends StatelessWidget {
  const SearchResultBookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  /// The generic book model containing search result details.
  final BookGeneric book;

  /// Optional callback triggered when tapping the card.
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

    /// Dynamic resolution for `coverI` whether provided as an `int` ID or a URL `String`.
    final String coverUrl = book.coverI != null
        ? (book.coverI is int
        ? 'https://covers.openlibrary.org/b/id/${book.coverI}-M.jpg'
        : book.coverI.toString())
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
                      /// Book cover image container with shadow and rounded right corners.
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

                      /// Book details section (title, author names, and page count).
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
                              Text(
                                '${book.numberOfPagesMedium} pag.',
                                style: UnifiedTextStyles.badge12.copyWith(
                                  color: AppThemes.unselectedItemColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      /// Platform-adaptive trailing navigation icon.
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