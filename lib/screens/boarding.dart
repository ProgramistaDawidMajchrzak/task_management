import 'package:flutter/material.dart';
import 'package:task_management_go_online/widgets/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> setShowBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('show_boarding', 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/boarding_img.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color(0xFF192E51).withOpacity(0.8),
              padding:
                  const EdgeInsets.symmetric(vertical: 22.0, horizontal: 0.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      'Task Management APP',
                      style: poppinsBold.copyWith(
                          color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        await setShowBoarding().then(
                            (value) => {Navigator.pushNamed(context, '/home')});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            const Color(0xFF192E51).withOpacity(0.8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 22.0, horizontal: 102.0),
                        child: Text(
                          'Explore',
                          style: poppinsBold.copyWith(
                            color: const Color(0xFF192E51).withOpacity(0.8),
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String description;
  final int currPage;
  final Function onNext;
  final PageController pageController;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.description,
    required this.currPage,
    required this.onNext,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: const Color(0xFF192E51).withOpacity(0.8),
        padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 0.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                description,
                style: poppinsBold.copyWith(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  onNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF192E51).withOpacity(0.8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 22.0, horizontal: 102.0),
                  child: Text(
                    'Dalej',
                    style: poppinsBold.copyWith(
                      color: const Color(0xFF192E51).withOpacity(0.8),
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ChooseRole');
                },
                child: Text(
                  "Pomiń",
                  style:
                      poppinsBold.copyWith(color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
