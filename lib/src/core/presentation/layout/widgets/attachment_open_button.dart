import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

class AttachmentOpenButton extends StatelessWidget {
  const AttachmentOpenButton({
    super.key,
    required this.fileUrl,
    this.label = '查看附件',
    this.errorPrefix = '打开附件失败',
    this.icon = Icons.attach_file_outlined,
  });

  final String? fileUrl;
  final String label;
  final String errorPrefix;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (!FileLinkUtil.hasLink(fileUrl)) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: _open,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Future<void> _open() async {
    try {
      await FileLinkUtil.open(fileUrl);
    } catch (err) {
      ToastUtil.showError('$errorPrefix: $err');
    }
  }
}
