import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index)? onItemSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onItemSelected,
  });

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color gray = Color(0xFF657491);
  static const Color borderColor = Color(0xFFE4E9F2);

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(
        icon: Icons.home_outlined,
        label: 'Minhas Aulas',
      ),
      _NavItem(
        icon: Icons.calendar_today_outlined,
        label: 'Agendar Aulas',
      ),
      _NavItem(
        icon: Icons.chat_bubble_outline,
        label: 'Mensagens',
      ),
      _NavItem(
        icon: Icons.person_outline,
        label: 'Perfil',
      ),
    ];

    return Container(
      height: 86,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          final item = items[index];

          return Expanded(
            child: InkWell(
              onTap: () {
                if (onItemSelected != null) {
                  onItemSelected!(index);
                }
              },
              child: Column(
                children: [
                  Container(
                    height: 3,
                    width: 84,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Icon(
                    item.icon,
                    color: isSelected ? primaryBlue : gray,
                    size: 29,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? primaryBlue : gray,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({
    required this.icon,
    required this.label,
  });
}