import 'package:flutter/material.dart';

class RoundCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;
  final String placeholder;
  RoundCheckbox(
      {bool value, this.onChanged, disabled = false, this.placeholder})
      : this.disabled = disabled,
        this.value = value ?? false;

  _RoundCheckboxState createState() => _RoundCheckboxState();
}

class _RoundCheckboxState extends State<RoundCheckbox> {
  bool _value = false;

  void initState() {
    super.initState();
    _value = widget.value;
  }

  _toggle() {
    if (widget.onChanged != null) widget.onChanged(value);
    setState(() {
      _value = !_value;
    });
  }

  bool get value => !widget.disabled && _value;

  @override
  Widget build(BuildContext context) {
    final double size = 28.0;

    return Container(
      margin: EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Theme.of(context).accentColor,
          onTap: widget.disabled ? null : () {},
          onLongPress: widget.disabled ? null : _toggle,
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
                  color: (value || widget.disabled)
                      ? Colors.transparent
                      : Colors.black12,
                  width: 2),
              boxShadow: value
                  ? [
                      BoxShadow(
                          blurRadius: 4, spreadRadius: 1, color: Colors.black38)
                    ]
                  : [],
            ),
            child: Text(
              widget.placeholder ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: value
                      ? Colors.white.withAlpha(0xdd)
                      : Colors.black.withAlpha(0x88)),
            ),
          ),
        ),
      ),
    );
  }
}
