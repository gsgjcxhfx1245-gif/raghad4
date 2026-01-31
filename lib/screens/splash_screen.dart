import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));

    await _animationController.reverse();

    Get.off(() => LoginScreen(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.brown[50]!,
              Colors.brown[100]!,
              Colors.brown[200]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.brown[800]!,
                          Colors.brown[600]!,
                          Colors.brown[400]!,
                        ],
                        center: Alignment.center,
                        radius: 0.8,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 5,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.mosque,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              Column(
                children: [
                  Text(
                    'حصن المسلم',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'تطوير النفس والروح',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[700],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              Container(
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '﷽',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.brown,
                            fontFamily: 'Traditional Arabic',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              RotationTransition(
                turns: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.linear,
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.brown.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.brown,
                    backgroundColor: Colors.brown.withOpacity(0.1),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                'جاري التحميل...',
                style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}