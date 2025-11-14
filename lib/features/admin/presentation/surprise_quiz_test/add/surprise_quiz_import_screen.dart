import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../controller/add_surprise_quiz_controller.dart';

class SurpriseQuizImportScreen extends ConsumerStatefulWidget {
  const SurpriseQuizImportScreen({super.key});

  @override
  ConsumerState<SurpriseQuizImportScreen> createState() =>
      _SurpriseQuizImportScreenState();
}

class _SurpriseQuizImportScreenState
    extends ConsumerState<SurpriseQuizImportScreen> {
  String selectedGroup = "HSC";
  String selectedLevel = "Science";

  bool isImporting = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surpriseQuizControllerProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: const CommonRoundedAppBar(
            title: "Import From QC Vault",
            titleSize: 18,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _selector(
                    label: "Group",
                    value: selectedGroup,
                    items: const ["HSC", "SSC"],
                    onChanged: (v) => setState(() => selectedGroup = v),
                  ),
                  const SizedBox(height: 10),

                  _selector(
                    label: "Level",
                    value: selectedLevel,
                    items: const ["Science", "Arts", "Commerce"],
                    onChanged: (v) => setState(() => selectedLevel = v),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isImporting
                              ? null
                              : () async {
                                setState(() => isImporting = true);

                                await ref
                                    .read(
                                      surpriseQuizControllerProvider.notifier,
                                    )
                                    .import20(selectedGroup, selectedLevel);

                                final imported =
                                    ref
                                        .read(surpriseQuizControllerProvider)
                                        .imported;

                                if (imported != null) {
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      Navigator.pop(context, imported);
                                    },
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Import 20 Random Questions",
                        style: TextStyle(
                          fontFamily: "Barlow",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),

        if (isImporting)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset("assets/animations/coffee.json"),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "your request is processing...",
                        style: TextStyle(
                          fontFamily: "Barlow",
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "this my take some times, take a coffee!",
                        style: TextStyle(
                          fontFamily: "Barlow",
                          color: Colors.white70,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _selector({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: $value",
            style: const TextStyle(
              fontFamily: "Barlow",
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: AppColors.primaryLight,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              items:
                  items
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontFamily: "Barlow",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (v) => onChanged(v ?? value),
            ),
          ),
        ],
      ),
    );
  }
}
