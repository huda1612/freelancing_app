import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final Function(int index) onOptionSelected;
  final int selectedIndex;

  const QuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.onOptionSelected,
    required this.selectedIndex,
  });

//   @override
//   State<QuestionCard> createState() => _QuestionCardState();
// }

// class _QuestionCardState extends State<QuestionCard> {
//   // int selectedIndex = -1;
//   // final isSelected = widget.selectedIndex == index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  AppColors.purple.withOpacity(0.05),
                  Colors.transparent,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppColors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.quiz_rounded,
                    color: AppColors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.purple,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 0, thickness: 1, color: Colors.grey),

          // Options
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: List.generate(options.length, (index) {
                final isSelected = selectedIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        // ignore: deprecated_member_use
                        ? AppColors.purple.withOpacity(0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(unselectedWidgetColor: Colors.grey[400]),
                    child: CheckboxListTile(
                      value: isSelected,
                      title: Text(
                        options[index],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color:
                              isSelected ? AppColors.purple : Colors.grey[800],
                        ),
                      ),
                      // onChanged: (value) {
                      //   setState(() {
                      //     selectedIndex = index;
                      //   });
                      // },
                      onChanged: (value) {
                        onOptionSelected(index);
                      },
                      activeColor: AppColors.purple,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selected: isSelected,
                      // ignore: deprecated_member_use
                      selectedTileColor: AppColors.purple.withOpacity(0.08),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
