import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void handleAppError(dynamic error, {String message = 'An error occurred'}) {
  // Log the error using the logger
  logger.e('Error: $error');

  // Show a toast/snackbar message to the user
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ErrorHandlingExample(),
    );
  }
}

class ErrorHandlingExample extends StatelessWidget {
  void fetchData() async {
    try {
      // Simulate a network request that may fail
      await Future.delayed(Duration(seconds: 2));
      throw Exception('Failed to fetch data');
    } catch (error) {
      handleAppError(error, message: 'Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Handling Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: fetchData,
          child: Text('Fetch Data'),
        ),
      ),
    );
  }
}


//example of how to use it
// import 'error_handling.dart'; // Assuming error_handling.dart is the file containing handleAppError

// void someFunction() {
//   try {
//     // Some code that may throw an error
//   } catch (error) {
//     handleAppError(error, message: 'Error occurred in someFunction');
//   }
// }