import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bizlevel/theme/color.dart';
import 'chat_notify.dart';
import 'custom_image.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';

class ChatItem extends StatefulWidget {
  const ChatItem(
    this.chatData, {
    super.key,
    this.onTap,
    this.isNotified = true,
    this.profileSize = 50,
  });

  final Map<String, dynamic> chatData;
  final bool isNotified;
  final GestureTapCallback? onTap;
  final double profileSize;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.chatData['image'] as String? ?? '';
    final String botLabel = widget.chatData['botLabel'] as String? ?? '';
    final bool showPhoto = imagePath.isNotEmpty;

    return MouseRegion(
      onEnter: (_) {
        if (kIsWeb) setState(() => _isHover = true);
      },
      onExit: (_) {
        if (kIsWeb) setState(() => _isHover = false);
      },
      child: AnimatedScale(
        scale: _isHover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: BizLevelCard(
            onTap: widget.onTap,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.itemSpacing,
            ),
            semanticsLabel: (widget.chatData['name'] as String?)?.isNotEmpty == true
                ? 'Открыть диалог: ${widget.chatData['name']}'
                : 'Открыть диалог',
            child: Row(
              children: [
                if (showPhoto) _buildPhoto(imagePath, botLabel),
                if (showPhoto) const SizedBox(width: AppSpacing.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameAndTime(),
                      const SizedBox(height: AppSpacing.s5),
                      _buildTextAndNotified(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextAndNotified() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.chatData['last_text'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // fix: inline типографика → Theme.textTheme
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (widget.isNotified)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ChatNotify(
              number: widget.chatData['notify'] ?? 0,
              boxSize: 17,
              color: AppColor.red,
            ),
          )
      ],
    );
  }

  Widget _buildPhoto(String imagePath, String botLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomImage(
          imagePath,
          width: widget.profileSize,
          height: widget.profileSize,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (botLabel.isNotEmpty)
          Text(
            botLabel,
            // fix: inline типографика → textTheme.labelMedium
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
      ],
    );
  }

  Widget _buildNameAndTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            widget.chatData['name'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // fix: inline типографика → textTheme.titleMedium
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: AppSpacing.s5),
        Text(
          widget.chatData['date'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // fix: inline типографика/цвет → textTheme + токен
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: AppColor.onSurfaceSubtle),
        ),
      ],
    );
  }
}
