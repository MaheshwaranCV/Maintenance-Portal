import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainportal/dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Maintenance Portal';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _title.toUpperCase(),
            style: const TextStyle(
              letterSpacing: 2,
            ),
          ),
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;
  bool passwordVisible = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey[300],
        ),
        Container(
          padding: const EdgeInsets.only(top: 120),
          alignment: Alignment.topCenter,
          child: Text(
            'ENTER YOUR LOGIN CREDENTIALS',
            style: TextStyle(
              fontFamily: 'Serif',
              fontSize: 24,
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: 'USER ID',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          obscureText: !passwordVisible,
                          controller: passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            labelText: 'PASSWORD',
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('LOGIN'),
                            onPressed: isLoading ? null : login,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (errorMessage.isNotEmpty)
          Positioned(
            top: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              padding: const EdgeInsets.all(10),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        // Guidelines Box
        Positioned(
          bottom: 100, // Adjust the position as needed
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'A Maintenance Portal facilitates streamlined operations by managing notifications for equipment issues and generating work orders for efficient maintenance, ensuring timely response and organized task management.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        // Footer Section
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'SAP ERP Portal Development - MAINTENANCE PORTAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login() async {
    if (passwordController.text.isNotEmpty && nameController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      var response = await http.post(
        Uri.parse("http://localhost:3030/login"),
        body: {
          "PASSWORD": passwordController.text,
          "USERNAME": nameController.text,
        },
      );

      if (response.statusCode == 200) {
        if (response.body.contains("TRUE")) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          setState(() {
            errorMessage = 'Invalid Login Credentials. Please try again.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Login Failed. Please try again later.';
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}
