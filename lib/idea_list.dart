import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'new_idea.dart';

class IdeaListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _clearLogin() async {
      SharedPreferences.getInstance().then((sp) {
        SharedPreferences pref = sp;
        pref?.setBool("login", false);
      }, onError: (e) {});
    }

    Future<bool> _onBackPressed() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Close App"),
                content: Text("Do you really want to close the Voting app"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No"),
                  ),
                  FlatButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: Text("Yes"),
                  )
                ],
              ));
    }

    Future<bool> _newIdea() {
      return showDialog(context: context,
      builder: (context) => NewIdeaPage());
    }

    void _logout(Choice choice) {
      if (choice.title.toLowerCase() == "logout") {
        _clearLogin();
        main();
      }
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Voting Ideas",
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
          leading: null,
          actions: <Widget>[
            PopupMenuButton<Choice>(
              elevation: 3.2,
              initialValue: choices[0],
              onCanceled: () {
                print("User cancelled");
              },
              tooltip: "Logout button",
              onSelected: _logout,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(8.0), child: Center()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _newIdea,
          tooltip: 'New Idea',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

List<Choice> choices = <Choice>[
  Choice(title: "Logout", icon: Icons.exit_to_app)
];

class Choice {
  String title;
  IconData icon;

  Choice({this.title, this.icon});
}
