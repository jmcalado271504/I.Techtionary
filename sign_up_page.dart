import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/email_service.dart';
import '../../../userhub/dashboard_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();
  final first = TextEditingController();
  final last = TextEditingController();
  final suffix = TextEditingController();

  String? selectedRole = 'Student';
  String? selectedSoftwareDev = 'None';

  bool loading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final List<String> softwareDevOptions = [
    'Web Development',
    'Mobile Development',
    'Game Development',
    'None',
  ];

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    confirmPass.dispose();
    first.dispose();
    last.dispose();
    suffix.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      filled: true,
    );
  }

  void _showWarningDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _generateOtpCode() {
    var rng = math.Random();
    return (100000 + rng.nextInt(900000)).toString();
  }

  void _proceedToOtpVerification({
    required String emailText,
    required String firstName,
    required String lastName,
    required String suffixText,
    required String roleText,
    required String softwareDevText,
    required String passwordText,
  }) async {
    setState(() => loading = true);

    final generatedOtp = _generateOtpCode();

    bool isSent = await EmailService.sendOtpEmail(
      recipientEmail: emailText,
      otpCode: generatedOtp,
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (!isSent) {
      _showWarningDialog(
        "Failed to Send Email",
        "The verification code could not be sent. Please make sure the email address provided is valid and able to receive messages.",
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationPage(
          email: emailText,
          generatedCode: generatedOtp,
          onSuccess: () async {
            setState(() => loading = true);
            try {
              final userCredential = await AuthService.signUp(
                email: emailText,
                password: passwordText,
                first: firstName,
                last: lastName,
              );

              final user = userCredential.user;

              if (user != null) {
                await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                  'firstName': firstName,
                  'lastName': lastName,
                  'suffix': suffixText,
                  'email': emailText,
                  'role': roleText.toLowerCase(),
                  'createdAt': FieldValue.serverTimestamp(),
                }, SetOptions(merge: true));

                // --- TAWAGIN ANG ADMIN NOTIFICATION DITO ---
                await EmailService.sendNewUserNotification(
                  newUserEmail: emailText,
                );
              }

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardPage(
                    initialSoftwareDev: softwareDevText,
                  ),
                ),
                    (route) => false,
              );
            } catch (e) {
              if (!mounted) return;
              _showWarningDialog("Registration Error", e.toString());
            } finally {
              if (mounted) {
                setState(() => loading = false);
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset(
                "assets/icon/app_icon.png",
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 16),
              const Text(
                "Join I.Techtionary",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Create your account and start learning IT.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: fieldDecoration(
                  label: "Email",
                  icon: Icons.email_outlined,
                ).copyWith(
                  hintText: "example123@gmail.com",
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: first,
                decoration: fieldDecoration(
                  label: "First Name",
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: last,
                decoration: fieldDecoration(
                  label: "Last Name",
                  icon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: suffix,
                decoration: fieldDecoration(
                  label: "Suffix (Optional)",
                  icon: Icons.title_outlined,
                ).copyWith(
                  hintText: "e.g., Jr., Sr., III",
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: fieldDecoration(
                  label: "Role",
                  icon: Icons.work_outline,
                ),
                items: const [
                  DropdownMenuItem(value: "Student", child: Text("Student")),
                  DropdownMenuItem(value: "Worker", child: Text("Worker")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedSoftwareDev,
                decoration: fieldDecoration(
                  label: "Software Development",
                  icon: Icons.alt_route,
                ),
                items: softwareDevOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSoftwareDev = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextField(
                controller: pass,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: confirmPass,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : () {
                    final emailText = email.text.trim();
                    final firstName = first.text.trim();
                    final lastName = last.text.trim();
                    final suffixText = suffix.text.trim();
                    final passwordText = pass.text.trim();
                    final confirmPasswordText = confirmPass.text.trim();
                    final softwareDevText = selectedSoftwareDev ?? 'None';

                    final gmailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

                    if (emailText.isEmpty ||
                        firstName.isEmpty ||
                        lastName.isEmpty ||
                        passwordText.isEmpty ||
                        confirmPasswordText.isEmpty ||
                        selectedRole == null) {
                      _showWarningDialog(
                        "Missing Details",
                        "Please fill in all the required fields.",
                      );
                      return;
                    }

                    if (!gmailRegex.hasMatch(emailText)) {
                      _showWarningDialog(
                        "Invalid Email",
                        "Please make sure you entered a real and valid Gmail address (e.g., example@gmail.com).",
                      );
                      return;
                    }

                    if (passwordText.length < 6) {
                      _showWarningDialog(
                        "Password Too Short",
                        "The password must be at least 6 characters long.",
                      );
                      return;
                    }

                    if (passwordText != confirmPasswordText) {
                      _showWarningDialog(
                        "Password Mismatch",
                        "Password and Confirm Password do not match.",
                      );
                      return;
                    }

                    _proceedToOtpVerification(
                      emailText: emailText,
                      firstName: firstName,
                      lastName: lastName,
                      suffixText: suffixText,
                      roleText: selectedRole!,
                      softwareDevText: softwareDevText,
                      passwordText: passwordText,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String generatedCode;
  final VoidCallback onSuccess;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.generatedCode,
    required this.onSuccess,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  static const Color primaryColor = Color(0xFF003366);

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    String enteredCode = controllers.map((c) => c.text).join();

    if (enteredCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the 6-digit code.")),
      );
      return;
    }

    if (enteredCode == widget.generatedCode) {
      widget.onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect verification code. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/icon/app_icon.png",
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.mark_email_read_outlined,
                      size: 70,
                      color: primaryColor),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "The 6-digit code has been sent to:\n${widget.email}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 48,
                    height: 58,
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) {
                        if (event.logicalKey.keyLabel == 'Backspace' &&
                            controllers[index].text.isEmpty &&
                            index > 0) {
                          controllers[index - 1].clear();
                          focusNodes[index - 1].requestFocus();
                        }
                      },
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 2.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code?",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("A new code has been resent to your email."),
                        ),
                      );
                    },
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _verifyCode,
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}