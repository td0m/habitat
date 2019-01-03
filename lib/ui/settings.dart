import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String description;
  final Widget trailing;
  Setting({
    this.onTap,
    @required this.title,
    @required this.description,
    Widget trailing,
  }) : this.trailing = trailing ?? Text("");

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .body1
                            .color
                            .withAlpha(0xaa),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              trailing
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String text;
  SettingsSection(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3, top: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.body2.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }
}
