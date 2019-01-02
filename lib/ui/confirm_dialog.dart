import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConfirm;
  ConfirmDialog({
    @required this.title,
    @required this.onConfirm,
    String description,
  }) : this.description = description ?? "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text(title),
        content: description != null ? Text(description) : null,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryTextTheme.body1.color,
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: Text("Ok"),
          )
        ],
      ),
    );
  }
}
