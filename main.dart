import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:async';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hassnain Khan - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  bool _isDarkMode = true;
  late AnimationController _typingController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  String _displayText = '';
  String _fullText = 'CS Student | Flutter Learner | Tech Enthusiast';
  int _textIndex = 0;
  Timer? _typingTimer;

  final List<String> _sections = [
    'Home',
    'About',
    'Education',
    'Experience',
    'Skills',
    'Testimonials',
    'Contact',
  ];
  final List<GlobalKey> _sectionKeys = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _sections.length; i++) {
      _sectionKeys.add(GlobalKey());
    }

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startTypingAnimation();
    _fadeController.forward();
  }

  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _displayText = _fullText.substring(0, _textIndex + 1);
          _textIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _textIndex = 0;
              _displayText = '';
            });
            _startTypingAnimation();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _typingController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0F0F23) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
        elevation: 0,
        title: Text(
          'Hassnain Khan',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          // Dark Mode Toggle
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 16),
          // Responsive Navigation
          if (MediaQuery.of(context).size.width > 600)
            ...List.generate(
              _sections.length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                  onPressed: () => _scrollToSection(i),
                  child: Text(
                    _sections[i],
                    style: GoogleFonts.poppins(
                      color:
                          _currentIndex == i
                              ? const Color(0xFF6366F1)
                              : (_isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                      fontWeight:
                          _currentIndex == i
                              ? FontWeight.w600
                              : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          if (MediaQuery.of(context).size.width <= 600)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.menu,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
              onSelected: (value) {
                final index = _sections.indexOf(value);
                if (index != -1) _scrollToSection(index);
              },
              itemBuilder:
                  (context) =>
                      _sections
                          .map(
                            (section) => PopupMenuItem(
                              value: section,
                              child: Text(section),
                            ),
                          )
                          .toList(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeroSection(),
            _buildAboutSection(),
            _buildEducationSection(),
            _buildExperienceSection(),
            _buildSkillsSection(),
            _buildTestimonialsSection(),
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index < _sectionKeys.length &&
        _sectionKeys[index].currentContext != null) {
      Scrollable.ensureVisible(
        _sectionKeys[index].currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildHeroSection() {
    return Container(
      key: _sectionKeys[0],
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              _isDarkMode
                  ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                  : [Colors.blue[50]!, Colors.purple[50]!],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image with 3D Flip Effect
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 2000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform(
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(value * 0.1),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6366F1),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color:
                                  _isDarkMode
                                      ? const Color(0xFF1A1A2E)
                                      : Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 60,
                                  color: const Color(0xFF6366F1),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your Photo Here',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF6366F1),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Add profile.jpg to\nassets/images/',
                                  style: GoogleFonts.poppins(
                                    fontSize: 8,
                                    color:
                                        _isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            FadeTransition(
              opacity: _fadeController,
              child: Text(
                'Hassnain Khan',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 48 : 36,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Animated Typing Effect
            Container(
              height: 60,
              child: Center(
                child: Text(
                  _displayText,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 16,
                    color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Download Resume Button
            _buildDownloadResumeButton(),
            const SizedBox(height: 32),
            // Social Buttons with Hover Effects
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildSocialButton(
                  icon: Icons.email,
                  label: 'Email',
                  onTap: () => _launchUrl('mailto:hasnainkhan6173@gmail.com'),
                ),
                _buildSocialButton(
                  icon: Icons.phone,
                  label: 'Call',
                  onTap: () => _launchUrl('tel:03038503030'),
                ),
                _buildSocialButton(
                  icon: Icons.link,
                  label: 'LinkedIn',
                  onTap:
                      () => _launchUrl(
                        'https://linkedin.com/in/hassnain-khan-779466350',
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadResumeButton() {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: InkWell(
              onTap: () => _downloadResume(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isHovered
                            ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                            : [
                              const Color(0xFF6366F1).withOpacity(0.8),
                              const Color(0xFF6366F1),
                            ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow:
                      isHovered
                          ? [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                          : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.download,
                      color: Colors.white,
                      size: isHovered ? 22 : 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Download Resume',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isHovered ? 16 : 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _downloadResume() {
    // Simulate download - in a real app, this would download a PDF
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Resume download started!'),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      _isDarkMode
                          ? const Color(0xFF6366F1).withOpacity(0.2)
                          : const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color:
                        isHovered
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF6366F1).withOpacity(0.3),
                  ),
                  boxShadow:
                      isHovered
                          ? [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ]
                          : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: const Color(0xFF6366F1),
                      size: isHovered ? 22 : 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6366F1),
                        fontWeight: FontWeight.w500,
                        fontSize: isHovered ? 15 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return Container(
      key: _sectionKeys[1],
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 64 : 32,
      ),
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeController,
            child: Text(
              'About Me',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width > 600 ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Computer Science Student | Tech Enthusiast | Aspiring Flutter Developer',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'I\'m a Computer Science student at the University of Engineering and Technology (UET) Peshawar, passionate about technology, problem-solving, and software development. I enjoy learning new skills and staying updated with the latest advancements in tech.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color:
                              _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Currently, I am exploring Flutter development to build cross-platform mobile applications and enhance my programming knowledge. My goal is to gain hands-on experience, work on real-world projects, and contribute to the tech industry.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color:
                              _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'I\'m always eager to connect, collaborate, and grow with fellow tech enthusiasts. Let\'s innovate together!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color:
                              _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection() {
    return Container(
      key: _sectionKeys[2],
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 64 : 32,
      ),
      color: _isDarkMode ? const Color(0xFF16213E) : Colors.grey[50],
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeController,
            child: Text(
              'Education',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width > 600 ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Color(0xFF6366F1),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'University of Engineering & Technology (UET) Peshawar',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color:
                                  _isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bachelor\'s in Computer Science',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF6366F1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'October 2024 – June 2028',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  _isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Abbottabad Campus',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  _isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Container(
      key: _sectionKeys[3],
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 64 : 32,
      ),
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeController,
            child: Text(
              'Experience',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width > 600 ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.work,
                        color: Color(0xFF6366F1),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Computer Science Student',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color:
                                  _isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'UET Peshawar',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF6366F1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'October 2024 – Present',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  _isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Currently pursuing a BS in Computer Science. Exploring programming and databases while developing problem-solving skills. Passionate about learning new technologies and expanding my expertise.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    final List<Map<String, dynamic>> skills = [
      {'name': 'Dart', 'level': 0.7, 'color': const Color(0xFF00B4AB)},
      {'name': 'Java', 'level': 0.8, 'color': const Color(0xFFED8B00)},
      {
        'name': 'Flutter Development',
        'level': 0.6,
        'color': const Color(0xFF02569B),
      },
    ];

    return Container(
      key: _sectionKeys[4],
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 64 : 32,
      ),
      color: _isDarkMode ? const Color(0xFF16213E) : Colors.grey[50],
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeController,
            child: Text(
              'Skills',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width > 600 ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children:
                  skills.map((skill) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                skill['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                              Text(
                                '${(skill['level'] * 100).toInt()}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color:
                                      _isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  _isDarkMode
                                      ? Colors.grey[700]
                                      : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: skill['level'],
                              child: Container(
                                decoration: BoxDecoration(
                                  color: skill['color'],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    final List<Map<String, dynamic>> testimonials = [
      {
        'name': 'Dr. Sarah Johnson',
        'role': 'Computer Science Professor',
        'text':
            'Hassnain shows exceptional problem-solving skills and a genuine passion for technology. His dedication to learning Flutter development is impressive.',
        'rating': 5,
      },
      {
        'name': 'Ahmed Khan',
        'role': 'Classmate & Study Partner',
        'text':
            'Working with Hassnain on projects has been great. He\'s always eager to learn new technologies and helps others understand complex concepts.',
        'rating': 5,
      },
      {
        'name': 'Maria Rodriguez',
        'role': 'Tech Mentor',
        'text':
            'Hassnain\'s enthusiasm for mobile development and his willingness to take on challenging projects makes him stand out among his peers.',
        'rating': 4,
      },
    ];

    return Container(
      key: _sectionKeys[5],
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 64 : 32,
      ),
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeController,
            child: Text(
              'Testimonials',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width > 600 ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).size.width > 900
                      ? 3
                      : MediaQuery.of(context).size.width > 600
                      ? 2
                      : 1,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
            ),
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              return _buildTestimonialCard(testimonials[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Map<String, dynamic> testimonial) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isHovered
                          ? const Color(0xFF6366F1)
                          : const Color(0xFF6366F1).withOpacity(0.2),
                  width: isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isHovered
                            ? const Color(0xFF6366F1).withOpacity(0.3)
                            : Colors.black.withOpacity(0.1),
                    blurRadius: isHovered ? 20 : 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < testimonial['rating']
                            ? Icons.star
                            : Icons.star_border,
                        color: const Color(0xFFFFD700),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '"${testimonial['text']}"',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 16),
                  Text(
                    testimonial['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    testimonial['role'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSection() {
    return Container(
      key: _sectionKeys[6],
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 64 : 32,
      ),
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeController,
            child: Text(
              'Contact',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width > 600 ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              Expanded(
                child: _buildContactCard(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: 'hasnainkhan6173@gmail.com',
                  onTap: () => _launchUrl('mailto:hasnainkhan6173@gmail.com'),
                ),
              ),
              Expanded(
                child: _buildContactCard(
                  icon: Icons.phone,
                  title: 'Phone',
                  subtitle: '03038503030',
                  onTap: () => _launchUrl('tel:03038503030'),
                ),
              ),
              Expanded(
                child: _buildContactCard(
                  icon: Icons.location_on,
                  title: 'Location',
                  subtitle: 'Mardan District, Khyber Pakhtunkhwa, Pakistan',
                  onTap: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Let\'s Connect!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'I\'m always open to new opportunities and collaborations.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                StatefulBuilder(
                  builder: (context, setState) {
                    bool isHovered = false;

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: InkWell(
                          onTap:
                              () => _launchUrl(
                                'https://linkedin.com/in/hassnain-khan-779466350',
                              ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isHovered ? Colors.grey[100] : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow:
                                  isHovered
                                      ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF6366F1,
                                          ).withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.link,
                                  color: const Color(0xFF6366F1),
                                  size: isHovered ? 22 : 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Connect on LinkedIn',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6366F1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: isHovered ? 16 : 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isHovered
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF6366F1).withOpacity(0.2),
                    width: isHovered ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isHovered
                              ? const Color(0xFF6366F1).withOpacity(0.4)
                              : Colors.black.withOpacity(0.1),
                      blurRadius: isHovered ? 25 : 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isHovered
                                ? const Color(0xFF6366F1).withOpacity(0.2)
                                : const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            isHovered
                                ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                                : null,
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFF6366F1),
                        size: isHovered ? 36 : 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color:
                            isHovered
                                ? Colors.grey[300]
                                : (_isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600]),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
