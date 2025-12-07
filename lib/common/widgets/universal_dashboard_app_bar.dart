// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../ui/design_system/tokens/colors.dart';
// import '../../ui/design_system/tokens/typography.dart';
// import '../screens/chat/providers/chat_unread_provider.dart';
// import '../services/xp_service.dart';
//
// class UniversalDashboardAppBar extends ConsumerWidget {
//   final String role;
//   final String greeting;
//   final String username;
//   final String email;
//   final String motto;
//   final String levelText;
//   final String xpText;
//   final String? profileImage;
//   final bool isGuest;
//   final VoidCallback? onLoginTap;
//
//   const UniversalDashboardAppBar({
//     super.key,
//     required this.role,
//     required this.greeting,
//     required this.username,
//     required this.email,
//     required this.motto,
//     required this.levelText,
//     required this.xpText,
//     this.profileImage,
//     this.isGuest = false,
//     this.onLoginTap,
//   });
//
//   String _guestName() {
//     final list = [
//       "Guest User",
//       "Guest Learner",
//       "Explorer",
//       "New Visitor",
//       "Guest Member",
//     ];
//     return list[Random().nextInt(list.length)];
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool isTeacher = role == "teacher";
//
//     final bool effectiveIsGuest = isTeacher ? false : isGuest;
//     final String finalName = effectiveIsGuest ? _guestName() : username;
//
//     final xpAsync = ref.watch(userXpProvider);
//
//     final String effectiveLevelText = xpAsync.maybeWhen(
//       data: (xp) => xp?.levelText ?? levelText,
//       orElse: () => levelText,
//     );
//
//     final String effectiveXpText =
//         effectiveIsGuest
//             ? "XP 0"
//             : xpAsync.maybeWhen(
//               data: (xp) => xp?.xpText ?? xpText,
//               orElse: () => xpText,
//             );
//
//     final String finalXp = effectiveIsGuest ? "XP 0" : effectiveXpText;
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
//       decoration: BoxDecoration(
//         color: AppColors.primaryDark,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (isTeacher) {
//                     context.push(
//                       '/teacher-profile',
//                       extra: {
//                         'username': username,
//                         'email': email,
//                         'profileImage': profileImage,
//                       },
//                     );
//                   } else {
//                     context.push(
//                       '/student-profile',
//                       extra: {
//                         'isGuest': effectiveIsGuest,
//                         'username': finalName,
//                         'email': email,
//                         'profileImage': profileImage,
//                       },
//                     );
//                   }
//                 },
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       height: 65,
//                       width: 65,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: _buildProfileImage(isTeacher, effectiveIsGuest),
//                       ),
//                     ),
//                     if (!effectiveIsGuest)
//                       Positioned(
//                         bottom: -4,
//                         right: -4,
//                         child: Container(
//                           height: 28,
//                           width: 28,
//                           decoration: BoxDecoration(
//                             color: AppColors.chip3,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 1),
//                           ),
//                           child: const Icon(
//                             Icons.edit_rounded,
//                             color: AppColors.textPrimary,
//                             size: 14,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       greeting,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontFamily: AppTypography.family,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       finalName,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontFamily: AppTypography.family,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       effectiveIsGuest && !isTeacher
//                           ? "Welcome to QuizCrafter!"
//                           : motto,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontFamily: AppTypography.family,
//                         color: Colors.white.withValues(alpha: .85),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     if (!effectiveIsGuest)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.chip1,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           effectiveLevelText,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontFamily: AppTypography.family,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               Column(
//                 children: [
//                   _glassButton(
//                     disabled: effectiveIsGuest,
//                     icon: CupertinoIcons.bell,
//                     onTap: () {},
//                   ),
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       _glassButton(
//                         disabled: effectiveIsGuest,
//                         icon: CupertinoIcons.bubble_right,
//                         onTap: () {
//                           if (!effectiveIsGuest) {
//                             context.pushNamed(
//                               'messages',
//                               pathParameters: {"role": role},
//                             );
//                           }
//                         },
//                       ),
//                       if (!effectiveIsGuest)
//                         Positioned(right: 0, top: -2, child: _UnreadBadge(ref)),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 18),
//
//           _buildXPBar(finalXp, effectiveIsGuest, effectiveLevelText),
//
//           const SizedBox(height: 10),
//
//           if (effectiveIsGuest && !isTeacher)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "You're in guest mode ",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontFamily: AppTypography.family,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: onLoginTap,
//                   child: const Text(
//                     "Login now",
//                     style: TextStyle(
//                       color: AppColors.secondaryDark,
//                       fontFamily: AppTypography.family,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _UnreadBadge(WidgetRef ref) {
//     final unread = ref
//         .watch(unreadMessageCountProvider)
//         .maybeWhen(data: (count) => count, orElse: () => 0);
//
//     if (unread == 0) return const SizedBox();
//
//     return Container(
//       padding: const EdgeInsets.all(5),
//       decoration: const BoxDecoration(
//         color: Colors.redAccent,
//         shape: BoxShape.circle,
//       ),
//       child: Text(
//         unread > 9 ? "9+" : unread.toString(),
//         style: const TextStyle(
//           fontSize: 10,
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontFamily: AppTypography.family,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileImage(bool isTeacher, bool effectiveIsGuest) {
//     if (effectiveIsGuest && !isTeacher ||
//         profileImage == null ||
//         profileImage!.isEmpty) {
//       return Container(
//         color: Colors.white12,
//         child: const Icon(Icons.person, color: Colors.white70, size: 40),
//       );
//     }
//     return Image.network(profileImage!, fit: BoxFit.cover);
//   }
//
//   Widget _glassButton({
//     required bool disabled,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return ClipOval(
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color:
//               disabled
//                   ? Colors.white.withValues(alpha: 0.12)
//                   : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           icon: Icon(icon, color: Colors.white, size: 20),
//           onPressed: disabled ? null : onTap,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildXPBar(String xpString, bool effectiveIsGuest, String levelText) {
//     final int currentXP =
//         int.tryParse(xpString.replaceAll("XP", "").trim()) ?? 0;
//
//     const int maxXP = 1000;
//     final double progress =
//         (!effectiveIsGuest) ? (currentXP / maxXP).clamp(0.0, 1.0) : 0;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Progress to $levelText",
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 12,
//                 fontFamily: AppTypography.family,
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.secondaryDark,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 xpString,
//                 style: const TextStyle(
//                   color: AppColors.textPrimary,
//                   fontSize: 11,
//                   fontFamily: AppTypography.family,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(30),
//           child: LinearProgressIndicator(
//             value: progress,
//             minHeight: 8,
//             backgroundColor: Colors.white24,
//             valueColor: const AlwaysStoppedAnimation<Color>(
//               AppColors.secondaryDark,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';
import '../screens/chat/providers/chat_unread_provider.dart';
import '../services/xp_service.dart';

class UniversalDashboardAppBar extends ConsumerWidget {
  final String role;
  final String greeting;
  final String username;
  final String email;
  final String motto;
  final String levelText;
  final String xpText;
  final String? profileImage;
  final bool isGuest;
  final VoidCallback? onLoginTap;

  const UniversalDashboardAppBar({
    super.key,
    required this.role,
    required this.greeting,
    required this.username,
    required this.email,
    required this.motto,
    required this.levelText,
    required this.xpText,
    this.profileImage,
    this.isGuest = false,
    this.onLoginTap,
  });

  String _guestName() {
    final list = [
      "Guest User",
      "Guest Learner",
      "Explorer",
      "New Visitor",
      "Guest Member",
    ];
    return list[Random().nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTeacher = role == "teacher";
    final bool effectiveIsGuest = isTeacher ? false : isGuest;
    final String finalName = effectiveIsGuest ? _guestName() : username;

    // XP service provider
    final xpAsync = ref.watch(userXpProvider);

    // Extract REAL XP + LEVEL from XP Service
    final int realXP = xpAsync.maybeWhen(
      data: (xp) => xp?.xp ?? 0,
      orElse: () => 0,
    );

    final int realLevel = xpAsync.maybeWhen(
      data: (xp) => xp?.level ?? 1,
      orElse: () => 1,
    );

    final String effectiveLevelText = xpAsync.maybeWhen(
      data: (xp) => xp?.levelText ?? levelText,
      orElse: () => levelText,
    );

    final String effectiveXpText =
    effectiveIsGuest
        ? "XP 0"
        : xpAsync.maybeWhen(
      data: (xp) => xp?.xpText ?? xpText,
      orElse: () => xpText,
    );

    final String finalXp = effectiveIsGuest ? "XP 0" : effectiveXpText;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (isTeacher) {
                    context.push(
                      '/teacher-profile',
                      extra: {
                        'username': username,
                        'email': email,
                        'profileImage': profileImage,
                      },
                    );
                  } else {
                    context.push(
                      '/student-profile',
                      extra: {
                        'isGuest': effectiveIsGuest,
                        'username': finalName,
                        'email': email,
                        'profileImage': profileImage,
                      },
                    );
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildProfileImage(isTeacher, effectiveIsGuest),
                      ),
                    ),
                    if (!effectiveIsGuest)
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: AppColors.chip3,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: AppColors.textPrimary,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      finalName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      effectiveIsGuest && !isTeacher
                          ? "Welcome to QuizCrafter!"
                          : motto,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppTypography.family,
                        color: Colors.white.withValues(alpha: .85),
                      ),
                    ),
                    const SizedBox(height: 6),

                    if (!effectiveIsGuest)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.chip1,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          effectiveLevelText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Column(
                children: [
                  _glassButton(
                    disabled: effectiveIsGuest,
                    icon: CupertinoIcons.bell,
                    onTap: () {},
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _glassButton(
                        disabled: effectiveIsGuest,
                        icon: CupertinoIcons.bubble_right,
                        onTap: () {
                          if (!effectiveIsGuest) {
                            context.pushNamed(
                              'messages',
                              pathParameters: {"role": role},
                            );
                          }
                        },
                      ),
                      if (!effectiveIsGuest)
                        Positioned(right: 0, top: -2, child: _UnreadBadge(ref)),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // FIXED XP BAR
          _buildXPBar(
            finalXp,
            effectiveIsGuest,
            effectiveLevelText,
            realXP: realXP,
            realLevel: realLevel,
          ),

          const SizedBox(height: 10),

          if (effectiveIsGuest && !isTeacher)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You're in guest mode ",
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: AppTypography.family,
                  ),
                ),
                GestureDetector(
                  onTap: onLoginTap,
                  child: const Text(
                    "Login now",
                    style: TextStyle(
                      color: AppColors.secondaryDark,
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _UnreadBadge(WidgetRef ref) {
    final unread = ref
        .watch(unreadMessageCountProvider)
        .maybeWhen(data: (count) => count, orElse: () => 0);

    if (unread == 0) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
      child: Text(
        unread > 9 ? "9+" : unread.toString(),
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: AppTypography.family,
        ),
      ),
    );
  }

  Widget _buildProfileImage(bool isTeacher, bool effectiveIsGuest) {
    if (effectiveIsGuest && !isTeacher ||
        profileImage == null ||
        profileImage!.isEmpty) {
      return Container(
        color: Colors.white12,
        child: const Icon(Icons.person, color: Colors.white70, size: 40),
      );
    }
    return Image.network(profileImage!, fit: BoxFit.cover);
  }

  Widget _glassButton({
    required bool disabled,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipOval(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
          disabled
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 20),
          onPressed: disabled ? null : onTap,
        ),
      ),
    );
  }

  Widget _buildXPBar(
      String xpString,
      bool effectiveIsGuest,
      String levelText, {
        required int realXP,
        required int realLevel,
      }) {
    if (effectiveIsGuest) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Progress to LEVEL 01",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(height: 6),
          LinearProgressIndicator(
            value: 0,
            minHeight: 8,
            backgroundColor: Colors.white24,
          ),
        ],
      );
    }

    // Each level = 1000 XP
    const int levelXPChunk = 1000;

    // XP at the beginning of this level
    int minXP = (realLevel - 1) * levelXPChunk;

    // XP inside this level
    int inLevelXP = realXP - minXP;

    // Clamp
    if (inLevelXP < 0) inLevelXP = 0;
    if (inLevelXP > levelXPChunk) inLevelXP = levelXPChunk;

    double progress = inLevelXP / levelXPChunk;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress to $levelText",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: AppTypography.family,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "XP $inLevelXP / $levelXPChunk",
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor:
            const AlwaysStoppedAnimation<Color>(AppColors.secondaryDark),
          ),
        ),
      ],
    );
  }
}
