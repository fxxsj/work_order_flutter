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
            spacing: SpacingTokens.sm,
            runSpacing: SpacingTokens.sm,
            children: images.asMap().entries.map((entry) {
              final image = entry.value;
              final description = descriptionBuilder?.call(image)?.trim() ?? '';
              return _ImageGalleryTile(
                imageUrl: imageUrlBuilder(image),
                description: description,
                onPreview: () => _showImagePreview(context, entry.key),
                onDelete: () => _confirmAndDelete(context, image),
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
              key: const ValueKey('image_gallery_upload_button'),
              onPressed: reachedMaxCount ? null : onUpload,
              icon: const Icon(Icons.add_photo_alternate, size: 18),
              label: Text(uploadButtonText),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmAndDelete(BuildContext context, T image) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除图片'),
        content: const Text('确定要删除这张图片吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await onDelete(image);
    }
  }

  Future<void> _showImagePreview(BuildContext context, int initialIndex) async {
    final previewImages = images
        .map(
          (image) => _PreviewImage(
            url: imageUrlBuilder(image),
            description: descriptionBuilder?.call(image)?.trim() ?? '',
          ),
        )
        .toList(growable: false);
    if (previewImages.isEmpty) return;

    await showDialog<void>(
      context: context,
      builder: (_) => _ImagePreviewDialog(
        images: previewImages,
        initialIndex: initialIndex,
      ),
    );
  }
}

class _ImageGalleryTile extends StatelessWidget {
  const _ImageGalleryTile({
    required this.imageUrl,
    required this.description,
    required this.onPreview,
    required this.onDelete,
  });

  final String imageUrl;
  final String description;
  final VoidCallback onPreview;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    final resolvedUrl = FileLinkUtil.resolveUrl(imageUrl);

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RadiusTokens.sm),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: resolvedUrl == null ? null : onPreview,
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
              ),
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
            child: Material(
              color: theme.colorScheme.error,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrokenPlaceholder(ThemeData theme, Color subtleText) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
      ),
      child: Icon(Icons.broken_image, color: subtleText),
    );
  }
}

class _PreviewImage {
  const _PreviewImage({required this.url, required this.description});

  final String url;
  final String description;
}

class _ImagePreviewDialog extends StatefulWidget {
  const _ImagePreviewDialog({required this.images, required this.initialIndex});

  final List<_PreviewImage> images;
  final int initialIndex;

  @override
  State<_ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<_ImagePreviewDialog> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.images.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentImage = widget.images[_currentIndex];
    final title = currentImage.description.isEmpty
        ? '图片预览'
        : currentImage.description;

    return Dialog(
      insetPadding: const EdgeInsets.all(SpacingTokens.lg),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.md,
                SpacingTokens.sm,
                SpacingTokens.sm,
                SpacingTokens.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                    style: theme.textTheme.bodySmall,
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final resolvedUrl = FileLinkUtil.resolveUrl(
                    widget.images[index].url,
                  );
                  return Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: resolvedUrl == null
                        ? const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 48,
                          )
                        : InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4,
                            child: Image.network(
                              resolvedUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
            if (widget.images.length > 1)
              Padding(
                padding: const EdgeInsets.all(SpacingTokens.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _currentIndex == 0
                          ? null
                          : () => _animateTo(_currentIndex - 1),
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('上一张'),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    TextButton.icon(
                      onPressed: _currentIndex == widget.images.length - 1
                          ? null
                          : () => _animateTo(_currentIndex + 1),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('下一张'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _animateTo(int index) {
    return _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }
}
