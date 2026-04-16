import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';

class ImageGalleryUploadSection<T> extends StatelessWidget {
  const ImageGalleryUploadSection({
    super.key,
    required this.images,
    required this.imageUrlBuilder,
    required this.onUpload,
    required this.onDelete,
    this.descriptionBuilder,
    this.canUpload = true,
    this.uploading = false,
    this.unsavedHintText = '请先保存后再上传图片',
    this.emptyText = '暂无图片，点击下方按钮上传',
    this.uploadButtonText = '上传图片',
    this.maxCount,
    this.limitHintText,
  });

  final List<T> images;
  final String Function(T image) imageUrlBuilder;
  final String? Function(T image)? descriptionBuilder;
  final Future<void> Function() onUpload;
  final Future<void> Function(T image) onDelete;
  final bool canUpload;
  final bool uploading;
  final String unsavedHintText;
  final String emptyText;
  final String uploadButtonText;
  final int? maxCount;
  final String? limitHintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final reachedMaxCount =
        maxCount != null && maxCount! > 0 && images.length >= maxCount!;
    final effectiveHint = reachedMaxCount
        ? (limitHintText ?? '最多上传 $maxCount 张图片')
        : limitHintText;

    if (!canUpload) {
      return Text(
        unsavedHintText,
        style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (images.isEmpty)
          Text(
            emptyText,
            style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
          )
        else
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: images.map((image) {
              final description = descriptionBuilder?.call(image)?.trim() ?? '';
              return _ImageGalleryTile(
                imageUrl: imageUrlBuilder(image),
                description: description,
                onDelete: () => onDelete(image),
              );
            }).toList(),
          ),
        if (effectiveHint != null && effectiveHint.isNotEmpty) ...[
          SizedBox(height: sectionSpacing),
          Text(
            effectiveHint,
            style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
          ),
        ],
        SizedBox(height: sectionSpacing),
        if (uploading)
          const Center(child: CircularProgressIndicator())
        else
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: reachedMaxCount ? null : onUpload,
              icon: const Icon(Icons.add_photo_alternate, size: 18),
              label: Text(uploadButtonText),
            ),
          ),
      ],
    );
  }
}

class _ImageGalleryTile extends StatelessWidget {
  const _ImageGalleryTile({
    required this.imageUrl,
    required this.description,
    required this.onDelete,
  });

  final String imageUrl;
  final String description;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    final resolvedUrl = FileLinkUtil.resolveUrl(imageUrl);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          child: resolvedUrl == null
              ? _buildBrokenPlaceholder(theme, subtleText)
              : Image.network(
                  resolvedUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _buildBrokenPlaceholder(theme, subtleText),
                ),
        ),
        if (description.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: Colors.black54,
              child: Text(
                description,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrokenPlaceholder(ThemeData theme, Color subtleText) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      ),
      child: Icon(Icons.broken_image, color: subtleText),
    );
  }
}
