import 'package:flutter/material.dart';
import '../../../core/theme/loop_colors.dart';
import '../../../core/theme/loop_spacing.dart';
import '../../../core/theme/loop_shadows.dart';
import '../../../core/theme/loop_motion.dart';

/// Primary button with LoopOut styling
/// 
/// A filled button with spring animation feedback
class LoopPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const LoopPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  @override
  State<LoopPrimaryButton> createState() => _LoopPrimaryButtonState();
}

class _LoopPrimaryButtonState extends State<LoopPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LoopMotion.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: LoopMotion.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          height: LoopSpacing.buttonHeight,
          decoration: BoxDecoration(
            color: isDisabled
                ? LoopColors.getDisabled(LoopColors.primaryBlue900)
                : LoopColors.primaryBlue900,
            borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
            boxShadow: _isPressed
                ? LoopShadows.elevation1
                : LoopShadows.primaryButton(LoopColors.primaryBlue900),
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: LoopColors.textInverse,
                          size: LoopSpacing.glyphSm,
                        ),
                        const SizedBox(width: LoopSpacing.space8),
                      ],
                      Text(
                        widget.label.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: LoopColors.textInverse,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Secondary button (outlined)
class LoopSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const LoopSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: LoopSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: LoopSpacing.glyphSm),
              const SizedBox(width: LoopSpacing.space8),
            ],
            Text(label.toUpperCase()),
          ],
        ),
      ),
    );
  }
}

/// Text button (minimal)
class LoopTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const LoopTextButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
