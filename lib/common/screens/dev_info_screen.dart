import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../widgets/collapsible_info_card.dart';

class DevInfoScreen extends StatelessWidget {
  const DevInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Developer Information'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CollapsibleInfoCard(
                title: 'Company Info',
                imagePath: 'assets/images/company/dev_engine.png',
                description: '''
Company: DevEngine  
Team: Qnect  

Powered by DevEngine — building reliable software with craft and care.

If you believe any material infringes your rights, contact us with details and proof of ownership.

Official Website: https://devengine-three.vercel.app  
Address: Mirpur-10, Dhaka  
Email: devengeinesoftsolution@gmail.com  
                ''',
              ),

              const SizedBox(height: 16),

              CollapsibleInfoCard(
                title: 'Developer',
                imagePath: 'assets/images/company/developer.png',
                description: '''
MD. ABDUL HAMIM  
Software Developer • Lead Design • Database Architect  

Founder of DevEngine. Hamim leads product architecture, end-to-end Flutter development, and data modeling. He shapes the design system, performance strategy, and secure backend flows that power QuizCrafter.

Email: hamim.leon@gmail.com
Team Qnect  
Building reliable software with craft and care.
                ''',
              ),

              const SizedBox(height: 16),

              CollapsibleInfoCard(
                title: 'Designer',
                imagePath: 'assets/images/company/designer.png',
                description: '''
MD. RAFIUL ISLAM  
UI/UX Designer • Design Expert • Content Writer  

Rafi crafts intuitive interfaces, smooth user journeys, and clear in-app content. He specializes in visual polish, accessibility, and microcopy that turns complex flows into simple, delightful experiences.

Email: islam15-5320@diu.edu.bd
Team Qnect  
Building reliable software with craft and care.
                ''',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
