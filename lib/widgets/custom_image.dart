import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
    this.image, {
    super.key,
    this.width = 100,
    this.height = 100,
    this.bgColor,
    this.borderWidth = 0,
    this.borderColor,
    this.trBackground = false,
    this.fit = BoxFit.cover,
    this.isNetwork = true,
    this.radius = 50,
    this.borderRadius,
    this.isShadow = true,
  });

  final String image;
  final double width;
  final double height;
  final double borderWidth;
  final bool isShadow;
  final Color? borderColor;
  final Color? bgColor;
  final bool trBackground;
  final bool isNetwork;
  final double radius;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bool isAsset = image.startsWith('assets/');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        boxShadow: [
          if (isShadow)
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        child: isAsset
            ? Image.asset(
                image,
                width: width,
                height: height,
                fit: fit,
              )
            : _buildNetworkImage(),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const BlankImageWidget(),
      errorWidget: (context, url, error) => const BlankImageWidget(),
    );
  }
}

class BlankImageWidget extends StatelessWidget {
  const BlankImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child:
          const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
    );
  }
}
