import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/common_rounded_app_bar.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../ui/design_system/tokens/typography.dart';

class NeedHelpScreen extends StatelessWidget {
  const NeedHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(
        title: 'Need Help',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("What we collect (for payments)"),
                bullet("Name, email, phone (for receipts/support)"),
                bullet("Order details: course name, amount, currency, time"),
                bullet("Transaction metadata (Txn ID, status)"),
                bullet("Billing address only if required by provider"),
                divider(),

                sectionTitle("What we don’t collect/store"),
                bullet("Full card numbers, CVV, or PIN"),
                bullet("bKash/Rocket/Nagad wallet PIN"),
                bullet("OTP codes (used once, not stored)"),
                divider(),

                sectionTitle("How your data is used"),
                bullet("To process the payment and deliver access"),
                bullet("To send receipts and notifications"),
                bullet("To resolve disputes & support requests"),
                bullet("To prevent fraud & keep platform safe"),
                divider(),

                sectionTitle("Security & storage"),
                bullet("Data encrypted in transit (HTTPS/TLS)"),
                bullet("Payment secured by PCI-DSS compliant gateways"),
                bullet("Limited internal access; audit logs kept"),
                divider(),

                sectionTitle("Third-party sharing"),
                bullet("Only what’s needed for transaction processing"),
                bullet("We don’t sell your personal data"),
                divider(),

                sectionTitle("Refunds & disputes (summary)"),
                bullet("Follow the in-app Refund Policy"),
                bullet("Refunds go back to original payment method"),
                bullet("Chargebacks may temporarily pause access"),
                divider(),

                sectionTitle("Your controls"),
                bullet("Download receipts from Payment History"),
                bullet("Update contact info in Profile"),
                bullet("Request data removal via Support"),
                divider(),

                sectionTitle("Country & currency"),
                bullet("Prices shown in BDT"),
                bullet("Banks may charge FX fees for non-BDT cards"),
                divider(),

                sectionTitle("Sandbox / test payments"),
                bullet("Clearly marked Sandbox — no real charge"),
                divider(),

                sectionTitle("Contact"),
                bullet("Need help? Contact support with Order ID/Txn ID"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.secondaryDark,
          fontFamily: AppTypography.family,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
                fontFamily: AppTypography.family,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: const Divider(color: Colors.white24, thickness: 1),
    );
  }
}
