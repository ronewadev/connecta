import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/auth/onboarding/upload_images_screen.dart';
import 'package:image_picker/image_picker.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final String email;
  final String password;

  const PersonalDetailsScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _bioController = TextEditingController();

  String _selectedGender = '';
  String _selectedNationality = '';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _genders = ['Male', 'Female', 'Non-binary', 'Other'];

  final List<String> _countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan',
    'Bahamas', 'Bahrain', 'Bangladesh', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi',
    'Cambodia', 'Cameroon', 'Canada', 'Cape Verde', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic',
    'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic',
    'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia',
    'Fiji', 'Finland', 'France',
    'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana',
    'Haiti', 'Honduras', 'Hungary',
    'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Ivory Coast',
    'Jamaica', 'Japan', 'Jordan',
    'Kazakhstan', 'Kenya', 'Kiribati', 'Kuwait', 'Kyrgyzstan',
    'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg',
    'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar',
    'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Korea', 'North Macedonia', 'Norway',
    'Oman',
    'Pakistan', 'Palau', 'Palestine', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal',
    'Qatar',
    'Romania', 'Russia', 'Rwanda',
    'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria',
    'Taiwan', 'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu',
    'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan',
    'Vanuatu', 'Vatican City', 'Venezuela', 'Vietnam',
    'Yemen',
    'Zambia', 'Zimbabwe'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _usernameController.addListener(() => setState(() {}));
    _ageController.addListener(() => setState(() {}));
    _mobileController.addListener(() => setState(() {}));
    _bioController.addListener(() => setState(() {}));

    _animationController.forward();
  }

  bool _isFormValid() {
    final hasUsername = _usernameController.text.isNotEmpty &&
        _usernameController.text.length >= 3;
    final hasValidAge = _ageController.text.isNotEmpty &&
        int.tryParse(_ageController.text) != null &&
        int.parse(_ageController.text) >= 18 &&
        int.parse(_ageController.text) <= 100;
    final hasGender = _selectedGender.isNotEmpty;
    final hasNationality = _selectedNationality.isNotEmpty;
    final hasProfile = _profileImage != null;
    final hasBio = _bioController.text.isNotEmpty && _bioController.text.length >= 20;

    return hasUsername && hasValidAge && hasGender && hasNationality && hasProfile && hasBio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B46C1),
              Color(0xFF9333EA),
              Color(0xFFEC4899),
              Color(0xFFBE185D),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Colors.white.withOpacity(0.8)],
                            ).createShader(bounds),
                            child: const Text(
                              'Tell us about yourself',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Help us create your perfect profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildProfileImageSection(),
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.15),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        _buildTextField(
                                          controller: _usernameController,
                                          label: 'Username',
                                          icon: FontAwesomeIcons.user,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a username';
                                            }
                                            if (value.length < 3) {
                                              return 'Username must be at least 3 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        _buildTextField(
                                          controller: _ageController,
                                          label: 'Age',
                                          icon: FontAwesomeIcons.birthdayCake,
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Required';
                                            }
                                            final age = int.tryParse(value);
                                            if (age == null || age < 18 || age > 100) {
                                              return 'Invalid age (18-100)';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        _buildGenderDropdown(),
                                        const SizedBox(height: 16),
                                        _buildTextField(
                                          controller: _mobileController,
                                          label: 'Mobile (Optional)',
                                          icon: FontAwesomeIcons.phone,
                                          keyboardType: TextInputType.phone,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildNationalityDropdown(),
                                        const SizedBox(height: 16),
                                        _buildBioTextField(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFEC4899),
                                  Color(0xFFBE185D),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEC4899).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_isFormValid()) {
                                  _continueToNext();
                                } else {
                                  // Show validation errors
                                  _formKey.currentState?.validate();
                                  if (_profileImage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Please upload a profile picture'),
                                        backgroundColor: const Color(0xFFEC4899),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Text(
                'Step 1 of 6',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.17, // 1/6
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        Text(
          'Profile Picture',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _pickProfileImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: _profileImage != null
                  ? null
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.file(
                      _profileImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.camera,
                        color: Colors.white.withOpacity(0.8),
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Required for profile',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Widget _buildBioTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: _bioController,
        maxLines: 4,
        maxLength: 300,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: 'Bio',
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
          hintText: 'Tell us about yourself... (at least 20 characters)',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8, top: 12),
            child: FaIcon(
              FontAwesomeIcons.penToSquare,
              color: Colors.white.withOpacity(0.8),
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: const TextStyle(color: Colors.yellowAccent, fontSize: 12),
          counterStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please write a bio';
          }
          if (value.length < 20) {
            return 'Bio must be at least 20 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: FaIcon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: const TextStyle(color: Colors.yellowAccent, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender.isEmpty ? null : _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: FaIcon(
              FontAwesomeIcons.venus,
              color: Colors.white.withOpacity(0.8),
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        dropdownColor: const Color(0xFF6B46C1),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        icon: FaIcon(
          FontAwesomeIcons.chevronDown,
          color: Colors.white.withOpacity(0.8),
          size: 16,
        ),
        items: _genders.map((gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select gender';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNationalityDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedNationality.isEmpty ? null : _selectedNationality,
        decoration: InputDecoration(
          labelText: 'Nationality',
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: FaIcon(
              FontAwesomeIcons.globe,
              color: Colors.white.withOpacity(0.8),
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        dropdownColor: const Color(0xFF6B46C1),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        icon: FaIcon(
          FontAwesomeIcons.chevronDown,
          color: Colors.white.withOpacity(0.8),
          size: 16,
        ),
        isExpanded: true,
        menuMaxHeight: 300,
        items: _countries.map((country) {
          return DropdownMenuItem(
            value: country,
            child: Text(
              country,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedNationality = value ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select nationality';
          }
          return null;
        },
      ),
    );
  }

  void _continueToNext() {
    if (_formKey.currentState!.validate() && _profileImage != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => UploadImagesScreen(
            email: widget.email,
            password: widget.password,
            username: _usernameController.text,
            age: int.parse(_ageController.text),
            gender: _selectedGender,
            mobile: _mobileController.text,
            nationality: _selectedNationality,
            bio: _bioController.text,
            profileImage: _profileImage,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      // Show validation errors
      _formKey.currentState?.validate();
      if (_profileImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please upload a profile picture'),
            backgroundColor: const Color(0xFFEC4899),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}