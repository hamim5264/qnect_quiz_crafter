// import 'package:flutter/material.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String name;
//   final String avatar;
//   final bool isActive;
//
//   const ChatAppBar({
//     super.key,
//     required this.name,
//     required this.avatar,
//     required this.isActive,
//   });
//
//   @override
//   Size get preferredSize => const Size.fromHeight(92);
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(20),
//         bottomRight: Radius.circular(20),
//       ),
//       child: Container(
//         color: AppColors.secondaryDark,
//         padding: const EdgeInsets.fromLTRB(12, 8, 16, 12),
//         child: SafeArea(
//           bottom: false,
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: () => Navigator.pop(context),
//                 borderRadius: BorderRadius.circular(22),
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: const BoxDecoration(
//                     color: AppColors.primaryDark,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     size: 22,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 28),
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.transparent,
//                     radius: 22,
//                     backgroundImage: AssetImage(avatar),
//                   ),
//                   if (isActive)
//                     Positioned(
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         width: 11,
//                         height: 11,
//                         decoration: BoxDecoration(
//                           color: Colors.greenAccent,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 1.4),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontFamily: AppTypography.family,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       isActive ? 'Active Now' : 'Active a few mins ago',
//                       style: const TextStyle(
//                         fontFamily: AppTypography.family,
//                         fontSize: 13,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String? avatar;
  final bool isActive;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.avatar,
    required this.isActive,
  });

  @override
  Size get preferredSize => const Size.fromHeight(92);

  ImageProvider? _buildAvatar() {
    if (avatar == null || avatar!.trim().isEmpty || avatar == "default_user") {
      return null;
    }
    if (avatar!.startsWith('http')) {
      return NetworkImage(avatar!);
    }
    return AssetImage(avatar!) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    final avatarProvider = _buildAvatar();

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        color: AppColors.secondaryDark,
        padding: const EdgeInsets.fromLTRB(12, 8, 16, 12),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 28),

              // 🔥 Avatar with fallback & active status
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    backgroundImage: avatarProvider,
                    child: avatarProvider == null
                        ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 26,
                    )
                        : null,
                  ),
                  if (isActive)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.4),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // 🔥 Name + Active status
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      isActive ? 'Active Now' : 'Active a few mins ago',
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
