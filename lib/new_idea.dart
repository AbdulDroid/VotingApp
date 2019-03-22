import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class NewIdeaPage extends StatelessWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _addIdea() {}
    return Platform.isAndroid == true ? AlertDialog(
      title: Text(
        "Create a new voting idea",
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: Theme.of(context).accentColor),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: "Idea Title",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide())),
                    validator: (val) =>
                        val.length == 0 ? "Title cannot be empty" : null,
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextFormField(
                      decoration: new InputDecoration(
                          labelText: "Idea Description",
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide())),
                      validator: (val) => val.length == 0
                          ? "Please add a little description to your voting idea"
                          : null,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.0,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(0xFF0857AB),
                        splashColor: Colors.white,
                        onPressed: _addIdea,
                        child: Text(
                          "Add Idea",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ) : CupertinoAlertDialog(
      title: Text(
        "Create a new voting idea",
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: Theme.of(context).accentColor),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CupertinoTextField(
                    placeholder: "Idea Title",
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: CupertinoTextField(
                      placeholder: "Idea Description",
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.0,
                      child: CupertinoButton(
                        color: Color(0xFF0857AB),
                        pressedOpacity: 0.5,
                        onPressed: _addIdea,
                        child: Text(
                          "Add Idea",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
