import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PrismCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? background;

  const PrismCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    this.background,
  });

  @override
  State<PrismCard> createState() => _PrismCardState();
}

class _PrismCardState extends State<PrismCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.background ?? (_hovering && widget.onTap != null ? AppColors.bgSurface : AppColors.bgVoid);

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: AppColors.border1, width: 1),
      ),
      padding: widget.padding,
      child: widget.child,
    );

    if (widget.onTap == null) return content;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.onTap,
        child: content,
      ),
    );
  }
}
