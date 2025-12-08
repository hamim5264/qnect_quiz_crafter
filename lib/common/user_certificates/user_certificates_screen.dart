import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import 'user_certificates_controller.dart';

class UserCertificatesScreen extends ConsumerStatefulWidget {
  const UserCertificatesScreen({super.key});

  @override
  ConsumerState<UserCertificatesScreen> createState() =>
      _UserCertificatesScreenState();
}

class _UserCertificatesScreenState
    extends ConsumerState<UserCertificatesScreen> {
  String filter = "All";
  String search = "";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userCertificatesProvider);

    final filtered = state.items.where((item) {
      final matchSearch = item.certName.toLowerCase().contains(search);
      final matchFilter = filter == "All"
          ? true
          : item.levelGroup == (filter == "Level 05" ? 5 : 10);
      return matchSearch && matchFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "My Certificates"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(state.items.length),
            const SizedBox(height: 16),

            _buildSearchBar(),
            const SizedBox(height: 16),

            _buildFilters(),
            const SizedBox(height: 16),

            Expanded(
              child: state.loading
                  ? const Center(child: AppLoader(),)
                  : filtered.isEmpty
                  ? _buildEmpty()
                  : _buildList(filtered),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ WIDGETS -----------------------

  Widget _buildHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.workspace_premium_rounded,
            color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Text(
          "$count certificates earned",
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        onChanged: (v) => setState(() => search = v.toLowerCase()),
        decoration: const InputDecoration(
          filled: false,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: "Search certificate",
          hintStyle: TextStyle(color: Colors.white70),
          icon: Icon(Icons.search, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ["All", "Level 05", "Level 10"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filters.map((f) {
        final selected = f == filter;
        return GestureDetector(
          onTap: () => setState(() => filter = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: selected
                  ? AppColors.secondaryDark
                  : Colors.white.withOpacity(.10),
            ),
            child: Text(
              f,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_rounded, color: Colors.white30, size: 70),
          const SizedBox(height: 12),
          const Text(
            "No Certificates Yet",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Complete your levels to earn certificates!",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<UserCertificate> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final c = items[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(.10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.certName,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: AppTypography.family,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Issued on ${c.issueDate}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: AppTypography.family,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
