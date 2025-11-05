import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/invoice_filter_bar.dart';
import 'widgets/invoice_card.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final invoices = [
      {'method': 'Bank'},
      {'method': 'Mobile Banking'},
      {'method': 'Bank'},
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Invoice'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvoiceFilterBar(
                selectedDate: selectedDate,
                onDateSelected: (date) => setState(() => selectedDate = date),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: invoices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder:
                      (_, index) => InvoiceCard(
                        orderId: 'OZC-2025-0912-1234',
                        course: 'Basic English Grammar',
                        seller: 'Arpita Ghose Tushi',
                        amount: '750 BDT',
                        method: invoices[index]['method']!,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
