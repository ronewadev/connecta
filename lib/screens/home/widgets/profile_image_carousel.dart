import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class ProfileImagesCarousel extends StatelessWidget {
  final UserModelInfo user;
  final double height;

  const ProfileImagesCarousel({
    Key? key,
    required this.user,
    this.height = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: PageView.builder(
        itemCount: user.profileImages.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(user.profileImages[index]),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Page indicator
                if (user.profileImages.length > 1)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: List.generate(
                        user.profileImages.length,
                            (i) => Expanded(
                          child: Container(
                            height: 3,
                            margin: EdgeInsets.only(
                              right: i == user.profileImages.length - 1 ? 0 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: i == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Online indicator
                if (user.isOnline)
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
