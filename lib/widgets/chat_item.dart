import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bizlevel/theme/color.dart';
import 'chat_notify.dart';
import 'custom_image.dart';

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
    final bool showPhoto = imagePath.isNotEmpty;

    return MouseRegion(
      onEnter: (_) {
        if (kIsWeb) setState(() => _isHover = true);
      },
      onExit: (_) {
        if (kIsWeb) setState(() => _isHover = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHover ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: _isHover ? 0.2 : 0.1),
                  spreadRadius: _isHover ? 2 : 1,
                  blurRadius: _isHover ? 4 : 1,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                if (showPhoto) _buildPhoto(imagePath),
                if (showPhoto) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameAndTime(),
                      const SizedBox(height: 5),
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
            style: const TextStyle(fontSize: 13),
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

  Widget _buildPhoto(String imagePath) {
    return CustomImage(
      imagePath,
      width: widget.profileSize,
      height: widget.profileSize,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          widget.chatData['date'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}
