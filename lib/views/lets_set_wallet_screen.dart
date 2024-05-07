import 'package:budget_buddy/views/you_are_set_screen.dart';
import 'package:flutter/material.dart';
class WalletSetupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BudgetBuddy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00838F),
      ),
      body: Container(
        color: Color(0xFF00838F),
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Let's setup your wallet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/wallet.png',
              height: 250,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BudgetPage()));

              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text("Let's go",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0x919719D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
