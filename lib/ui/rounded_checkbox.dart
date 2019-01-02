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

    return Container(
      margin: EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Theme.of(context).accentColor,
          onTap: disabled ? null : () {},
          onLongPress: disabled ? null : _toggle,
          onDoubleTap: disabled ? null : _toggle,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 160),
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? Theme.of(context).accentColor : Colors.transparent,
              border: Border.all(
                  color:
                      (value || disabled) ? Colors.transparent : Colors.black12,
                  width: 2),
              boxShadow: value
                  ? [
                      BoxShadow(
                          blurRadius: 4, spreadRadius: 1, color: Colors.black38)
                    ]
                  : [],
            ),
            child: placeholder == null
                ? Icon(
                    Icons.check,
                    color: textColor,
                    size: 18,
                  )
                : Text(
                    placeholder,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  ),
          ),
        ),
      ),
    );
  }
}
