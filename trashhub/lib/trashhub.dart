import 'package:flutter/material.dart';
//import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhub/home.dart';
import 'package:trashhub/login.dart';
import 'package:trashhub/register.dart';

class TrashHub extends StatefulWidget {
  const TrashHub({super.key});

  @override
  State<TrashHub> createState() => _TrashHubState();
}

class _TrashHubState extends State<TrashHub> {
  runGateway() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loggedin_username') != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return const Home();
        }),
        (route) => false,
      );
    } else {
      print('Please Login!');
    }
  }

  @override
  void initState() {
    super.initState();
    runGateway();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrashHub'),
        backgroundColor: Colors.green,
        // leading: Image.asset('assets/TrashHubIcon1.png'),
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/TrashHubBg.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to TrashHub',
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Log in or Register to continue',
                  style: GoogleFonts.lato(color: Colors.blue),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: NeoPopButton(
                        color: Colors.green,
                        buttonPosition: Position.fullBottom,
                        depth: 7,
                        onTapUp: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Text("Login"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: NeoPopButton(
                        color: Colors.green,
                        bottomShadowColor:
                            const Color.fromARGB(255, 42, 118, 45),
                        rightShadowColor: const Color.fromARGB(255, 53, 114, 53),
                        buttonPosition: Position.fullBottom,
                        depth: 7,
                        onTapUp: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        border: Border.all(
                          color: Colors.green,
                          width: 0,
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Wrap(
            //   alignment: WrapAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            //     ElevatedButton.icon(
            //       onPressed: () {

            //       },
            //       icon: const Icon(Icons.login),
            //       label: const Text('  Log in  '),
            //     ),
            //     const SizedBox(
            //       width: 20,
            //     ),
            //     ElevatedButton.icon(
            //       onPressed: () {

            //       },
            //       icon: const Icon(Icons.person),
            //       label: const Text('Register'),
            //     ),
            //   ],
            // ),

            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const Home(),
            //       ),
            //     );
            //   },
            //   icon: const Icon(Icons.developer_mode),
            //   label: const Text('Dev Home'),
            // )
          ),
        ),
      ),
    );
  }
}
