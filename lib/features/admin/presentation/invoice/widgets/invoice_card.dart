import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';

class InvoiceCard extends StatefulWidget {
  final String orderId;
  final String course;
  final String seller;
  final String amount;
  final String method;
  final bool initiallyRefunded;

  const InvoiceCard({
    super.key,
    required this.orderId,
    required this.course,
    required this.seller,
    required this.amount,
    required this.method,
    this.initiallyRefunded = false,
  });

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool isRefunded = false;

  @override
  void initState() {
    super.initState();
    isRefunded = widget.initiallyRefunded;
  }

  void _showRefundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: "Confirm Refund",
            message:
                "Are you sure you want to refund ${widget.amount} for this order?",
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            iconColor: Colors.redAccent,
            confirmColor: Colors.redAccent,
            onConfirm: () {
              setState(() => isRefunded = true);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.amount,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                  decoration:
                      isRefunded
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor: Colors.redAccent,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Order Id: ${widget.orderId}\n'
            'Course: ${widget.course}\n'
            'Sold By: ${widget.seller}',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _tag(widget.method, AppColors.chip3),
              const SizedBox(width: 10),
              _refundButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _refundButton(BuildContext context) {
    final color =
        isRefunded ? Colors.grey.withValues(alpha: 0.6) : AppColors.chip2;

    return GestureDetector(
      onTap: isRefunded ? null : () => _showRefundDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isRefunded ? 'Refunded' : 'Refund',
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
