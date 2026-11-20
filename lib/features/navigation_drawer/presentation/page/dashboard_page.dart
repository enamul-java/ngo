

import 'package:flutter/material.dart';

class ExpenseDashboardApp extends StatelessWidget {
  const ExpenseDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Flutter UI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F6F8),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6650E8),
          brightness: Brightness.light,
        ),
      ),
      home: const ExpenseDashboardPage(),
    );
  }
}

class ExpenseDashboardPage extends StatefulWidget {
  const ExpenseDashboardPage({super.key});

  @override
  State<ExpenseDashboardPage> createState() =>
      _ExpenseDashboardPageState();
}

class _ExpenseDashboardPageState
    extends State<ExpenseDashboardPage> {
  int _selectedTab = 0;
  bool _showNotificationDot = true;

  final List<ExpenseItem> _expenses = [
    ExpenseItem(
      title: 'House Rent',
      date: '10:00 am 15 March, 2025',
      amount: 300.00,
      icon: Icons.home_outlined,
    ),
    ExpenseItem(
      title: 'Internet Bill',
      date: '12:00 pm 15 March, 2025',
      amount: 85.00,
      icon: Icons.wifi,
    ),
    ExpenseItem(
      title: 'Groceries',
      date: '09:30 am 14 March, 2025',
      amount: 240.00,
      icon: Icons.shopping_cart_outlined,
    ),
    ExpenseItem(
      title: 'Transportation',
      date: '08:15 am 14 March, 2025',
      amount: 50.00,
      icon: Icons.directions_bus_outlined,
    ),
    ExpenseItem(
      title: 'Electricity',
      date: '06:40 pm 13 March, 2025',
      amount: 132.50,
      icon: Icons.bolt,
    ),
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _addCard() {
    _showMessage('Add Card selected');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16, 12, 16, 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildPaymentCards(),
                    const SizedBox(height: 26),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildExpensesSection(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 40,
              right: 40,
              bottom: 28,
              child: _buildBottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello DailyFlutterUI',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.6,
                  color: Color(0xFF18171B),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Let's save your money.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        _circleButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {
            setState(() {
              _showNotificationDot = false;
            });
            _showMessage('No new notifications');
          },
          showDot: _showNotificationDot,
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const CircleAvatar(
            backgroundColor: Color(0xFFE9E3DF),
            child: Icon(
              Icons.person,
              size: 30,
              color: Color(0xFF4D403B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 25, color: const Color(0xFF29272D)),
              if (showDot)
                Positioned(
                  top: 3,
                  right: 5,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF5350),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Overlapping payment cards
  Widget _buildPaymentCards() {
    return SizedBox(
      height: 360,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // First card
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 150,
                child: _PaymentCard(
                  color: const Color(0xFF087E79),
                  brand: 'VISA',
                  number: '•••• •••• 9312',
                  height: 150,
                ),
              ),

              // Second card
              Positioned(
                top: 54,
                left: 0,
                right: 0,
                height: 150,
                child: _PaymentCard(
                  color: const Color(0xFFB87509),
                  brand: '●',
                  number: '•••• •••• 2585',
                  height: 150,
                  isMastercard: true,
                ),
              ),

              // Main card
              Positioned(
                top: 110,
                left: 0,
                right: 0,
                height: 240,
                child: _buildMainCard(),
              ),

              // Add card action
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: const Color(0xFF111014),
                  borderRadius: BorderRadius.circular(32),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: _addCard,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.white,
                            size: 26,
                          ),
                          SizedBox(width: 9),
                          Text(
                            'Add Card',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
        },
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7655F4),
            Color(0xFF6542E5),
            Color(0xFF7250ED),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6542E5).withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                '•••• •••• 7845',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\$56,782.80',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 37,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.7,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Exp. Date',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    '08/26',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Name',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'dailyflutterui',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Quick action panel
  Widget _buildQuickActions() {
    final actions = [
      _ActionItem('Send', Icons.north_east_rounded),
      _ActionItem('Request', Icons.south_west_rounded),
      _ActionItem('TopUp', Icons.credit_card_outlined),
      _ActionItem('More', Icons.grid_view_rounded),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _showMessage(
                '${action.label} selected',
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0EFF2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      size: 24,
                      color: const Color(0xFF222027),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    action.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26242A),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Expenses
  Widget _buildExpensesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Manage Expenses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _showMessage('Showing all expenses'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._expenses.map(
                (expense) => _ExpenseRow(expense: expense),
          ),
        ],
      ),
    );
  }

  // Floating bottom navigation
  Widget _buildBottomNavigation() {
    const icons = [
      Icons.home_rounded,
      Icons.receipt_long_outlined,
      Icons.bar_chart_rounded,
      Icons.person_outline_rounded,
    ];

    const labels = ['Home', 'Bills', 'Stats', 'Profile'];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF111014),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: List.generate(icons.length, (index) {
          final selected = _selectedTab == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
                if (index != 0) {
                  _showMessage('${labels[index]} selected');
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 60,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      color: selected
                          ? const Color(0xFF111014)
                          : const Color(0xFF85818B),
                      size: 24,
                    ),
                    if (selected) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          labels[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111014),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Reusable payment card
class _PaymentCard extends StatelessWidget {
  final Color color;
  final String brand;
  final String number;
  final double height;
  final bool isMastercard;

  const _PaymentCard({
    required this.color,
    required this.brand,
    required this.number,
    required this.height,
    this.isMastercard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMastercard)
            const SizedBox(
              width: 30,
              height: 30,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: Color(0xFFEB302D),
                    ),
                  ),
                  Positioned(
                    left: 11,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: Color(0xFFF5A623),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              brand,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Expense model
class ExpenseItem {
  final String title;
  final String date;
  final double amount;
  final IconData icon;

  const ExpenseItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
  });
}

// Reusable expense row
class _ExpenseRow extends StatelessWidget {
  final ExpenseItem expense;

  const _ExpenseRow({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFF0EFF2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              expense.icon,
              color: const Color(0xFF302D36),
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF25232A),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  expense.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF17151B),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem {
  final String label;
  final IconData icon;

  const _ActionItem(this.label, this.icon);
}
