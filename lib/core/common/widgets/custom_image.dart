 

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:layer_kit/layer_kit.dart';
import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../defaults.dart';
import '../../utils/devlog.dart';

class CustomImage extends StatelessWidget {
  final String? url;
  final Uint8List? imageData;
  late double borderRadius;
  final BorderRadius? radius;
  final double? height;
  final double? width;
  final double? size;
  final BoxFit? fit;
  final Color? color;
  final BoxShape? shape;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final ImageProvider placeHolderImage;
  final bool showOriginal;
  final ColorFilter? colorFilter;

  CustomImage({
    super.key,
    this.url,
    this.imageData,
    this.radius,
    this.height,
    this.color,
    this.fit,
    this.shape,
    this.size,
    this.width,
    double? borderRadius,
    required this.placeHolderImage,
    this.border,
    this.boxShadow,
    this.showOriginal = false,
    this.colorFilter,
  }) : assert(
          size == null || (height == null && width == null),
          "\n\nIf you provide size, it will be used as height & width. Otherwise, specify height & width separately.\n",
        ) {
    this.borderRadius = borderRadius ?? D.defaultRadius;
  }

  @override
  Widget build(BuildContext context) {
    return url != null && url!.startsWith("http")
        ? CachedNetworkImage(
            imageUrl: url!,
            maxHeightDiskCache: showOriginal ? null : 400,
            maxWidthDiskCache: showOriginal ? null : 300,
            errorWidget: (context, url, error) => _buildContainer(
                context, placeHolderImage, BoxFit.cover, Colors.grey.shade100),
            placeholder: (context, url) => Skeletonizer(
                child: _buildContainer(context, placeHolderImage, BoxFit.cover,
                    Colors.grey.shade100)),
            imageBuilder: (context, image) =>
                _buildContainer(context, image, fit ?? BoxFit.cover, color),
          )
        : _buildContainer(
            context, _resolveImageProvider(), fit ?? BoxFit.cover, color);
  }

  DecorationImage? decorationImage(BuildContext context) {
    if (url == null || url!.trim().isEmpty || url == "https://") {
      return null;
    }

    ImageProvider imageProvider = _resolveImageProvider();

    return DecorationImage(
      image: imageProvider,
      fit: fit ?? BoxFit.cover,
      colorFilter: colorFilter,
    );
  }

  ImageProvider _resolveImageProvider() {
    if (imageData != null) {
      devlog("Memory Image Loaded: $imageData");
      return MemoryImage(imageData!);
    } else if (url == null || url!.trim().isEmpty) {
      return placeHolderImage;
    } else if (url!.startsWith('http')) {
      return CachedNetworkImageProvider(url!);
    } else if (url!.startsWith('assets/')) {
      return AssetImage(url!);
    } else if (url!.startsWith('/')) {
      return FileImage(File(url!));
    } else {
      return MemoryImage(Uint8List.fromList(url!.codeUnits));
    }
  }

  Container _buildContainer(
      BuildContext context, ImageProvider image, BoxFit fit, Color? color) {
    return Container(
      height: size ?? height,
      width: size ?? width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: shape == BoxShape.circle
            ? null
            : (radius ?? BorderRadius.circular(borderRadius)),
        border: border,
        boxShadow: boxShadow,
        shape: shape ?? BoxShape.rectangle,
        image: decorationImage(context),
      ),
    );
  }
}
