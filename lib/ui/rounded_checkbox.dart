import 'package:flutter/material.dart';

class RoundCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;
  final String placeholder;
  final double size;
  RoundCheckbox(
      {bool value,
      this.onChanged,
      disabled = false,
      this.placeholder,
      double size})
      : this.disabled = disabled,
        this.value = value ?? false,
        this.size = size ?? 28;

  _toggle() {
    if (onChanged != null) onChanged(!value);
  }

  @override
  Widget build(BuildContext context) {
    Color textColor =
        value ? Colors.white.withAlpha(0xdd) : Colors.black.withAlpha(0x88);
    if (disabled || (placeholder == null && !value))
      textColor = Colors.transparent;

    final color = Theme.of(context).accentColor;

    return Container(
      margin: EdgeInsets.all(4),
      child: GestureDetector(
        onLongPress: disabled ? null : _toggle,
        onDoubleTap: disabled ? null : _toggle,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 160),
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value && placeholder != null ? color : Colors.transparent,
            border: Border.all(
                color: (value)
                    ? color
                    : Theme.of(context).textTheme.body1.color.withAlpha(0x44),
                width: 2),
          ),
          child: placeholder == null
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 160),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? color : Colors.transparent,
                  ),
                  width: size * 0.55,
                  height: size * 0.55,
                )
              : Text(
                  placeholder,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
        ),
      ),
    );
  }
}
