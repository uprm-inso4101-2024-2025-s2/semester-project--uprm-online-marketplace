import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Login(),
));

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in to your account"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("login")
            ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("email/username")
            ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("password")
            ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  child: Text("Login")
              )
            ])

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        child: Text(
            "Click",
          style: TextStyle(
            color: Colors.cyan,
          ),
        ),
      ),
    );
  }
}
