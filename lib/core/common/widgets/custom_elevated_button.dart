 

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/atoms/border_radius.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/defaults.dart';

import '../../../config/theme/atoms/padding.dart';

class ButtonBorder {
  final double width;
  final Color color;

  ButtonBorder({required this.width, required this.color});
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color? color;
  final BoxShape? shape;
  final double? size;
  final double? height;
  final double? width;
  final double? borderRadius;
  final BorderRadius? radius;
  final ButtonBorder? border;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;

  const CustomElevatedButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.shape,
    this.border,
    this.padding,
    this.size,
    this.height,
    this.width,
    this.borderRadius,
    this.radius,
    this.alignment,
  })  : assert(
            size == null || (height == null && width == null),
            "\n\nIf you give size, it will apply as height and width\n"
            "Consider give height and width or size.\n"),
        assert(radius == null || borderRadius == null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: radius ?? D.defaultRadius.borderRadiusCircular,
      child: Container(
        alignment: alignment,
        padding: padding ?? (Gap.size16, Gap.size8).paddingHV,
        height: size ?? height,
        width: size ?? width,
        decoration: BoxDecoration(
          color: color ?? context.colors.primary,
          borderRadius: radius ?? D.defaultRadius.borderRadiusCircular,
          border: border == null ? null : Border.all(color: border?.color ?? context.colors.primary, width: border?.width ?? 1),
          shape: shape ?? BoxShape.rectangle,
        ),
        child: child,
      ),
    );
  }
}
