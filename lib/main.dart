import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

// ============== first 1 step as in images

//the link of animation file
  var animationLink = 'assets/login_screen_character.riv';
  StateMachineController? stateMachineController;
// this art borad for shown animtion on the screen
  Artboard? artboard;

// ============== step fourth 4 declaring 5 variables to show other events
  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;

// ============== second 2 step loading assets fo file rive into art borad
  @override
  void initState() {
    //load the animation link into artboard
    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      //use for controlling different actions
      stateMachineController =
          StateMachineController.fromArtboard(art, "Login Machine");
      if (stateMachineController != null) {
        art.addController(stateMachineController!);

        // ============== step fifth 5 we need five method
        //to change the input which will automatically re-activate the [StateMachineController] if necessary.
        stateMachineController!.inputs.forEach((element) {
          if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "numLook") {
            lookNum = element as SMINumber;
          }
        });
      }
      setState(() => artboard = art);
    });

    super.initState();
  }

  // =================== step 6 declare fuction to activate events
  //to see eyes on the start of the text
  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

//to roll eyes according to the text
  void moveEyes(value) {
    lookNum?.change(value.length.toDouble());
  }

//to hide the eyes with hands
  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

//on click event
  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (emailController.text == "mohammed" && passController.text == "123") {
      //happy face
      successTrigger?.fire();
    } else {
      //sad face
      failTrigger?.fire();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          if (artboard != null)
            //third step 3 adding artborad at ui
            SizedBox(
              width: 500,
              height: 300,
              child: Rive(artboard: artboard!),
            ),
            Positioned(
              top: 300,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
            ),
          //field for email
          Column(
            children: [
              const SizedBox(
                height: 320,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                  hintText: 'Enter Email',
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                ),
                onTap: lookAround,
                onChanged: ((value) => moveEyes(value)),
              ),
              const SizedBox(height: 24),

              //field for password
              TextFormField(
                controller: passController,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                  hintText: 'Enter Password',
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                ),
                //for password field
                onTap: handsUpOnEyes,
              ),
              const SizedBox(height: 24),

              // login button
              ElevatedButton(
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blueGrey),
                      fixedSize: MaterialStatePropertyAll(Size(230, 40))),
                  //On login click
                  onPressed: () => {loginClick()},
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  )),
            ],
          ),
          // Container(
          //   color: Colors.white,
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          // )
        ],
      ),
    );
  }
}
