import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // UI states
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  bool isEmailValid = false;
  bool hasTypedEmail = false;

  // Email Regex
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void checkEmail(String value){
    setState(() {
      hasTypedEmail = value.isNotEmpty;
      isEmailValid = emailRegex.hasMatch(value);
    });
  }

  void validate(){

    if(!_formKey.currentState!.validate()){
      return;
    }

    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match"))
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registration Successful"))
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Register'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// EMAIL FIELD
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: emailController,
                  onChanged: checkEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),

                    // Tick / Cross icon
                    suffixIcon: hasTypedEmail
                        ? Icon(
                            isEmailValid ? Icons.check_circle : Icons.cancel,
                            color: isEmailValid ? Colors.green : Colors.red,
                          )
                        : null,
                  ),

                  validator: (value){
                    if(value == null || value.isEmpty)
                      return "Email required";

                    if(!emailRegex.hasMatch(value))
                      return "Enter valid email";

                    return null;
                  },
                ),
              ),

              /// PASSWORD FIELD
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),

                    // Eye button
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: (){
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),

                  validator: (value){
                    if(value == null || value.isEmpty)
                      return "Password required";

                    if(value.length < 6)
                      return "Min 6 characters";

                    return null;
                  },
                ),
              ),

              /// CONFIRM PASSWORD FIELD
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: hideConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: (){
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                    ),
                  ),

                  validator: (value){
                    if(value == null || value.isEmpty)
                      return "Confirm your password";

                    if(value != passwordController.text)
                      return "Passwords do not match";

                    return null;
                  },
                ),
              ),

              const SizedBox(height: 10),

              /// REGISTER BUTTON
              ElevatedButton(
                onPressed: validate,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
