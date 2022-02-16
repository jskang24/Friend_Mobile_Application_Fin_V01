import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_mobile/app/app.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/buy_premium/premium_payment_screen.dart';

class PremiumUpgradeScreen extends StatefulWidget {
  const PremiumUpgradeScreen({Key? key}) : super(key: key);
  static const String route = "upgradeToPremium";
  @override
  _PremiumUpgradeScreenState createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends State<PremiumUpgradeScreen> {
  String plan = "Yearly";
  double price = 89.99;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset("assets/images/premium_bg.png"),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white.withOpacity(0.01),
                title: const Text("Upgrade to Premium"),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/images/premium_icon.svg")
                        ],
                      ),
                    ),
                    const Text(
                      "Get Premium Membership",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 24,
                      ),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: const Text(
                                  "Get ghost mode feature and hide your profile from others",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: const Text(
                                  "Join unlimited communities",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: const Text(
                                  "Contact members with unlimited range",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "Choose a Plan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  plan = "Monthly";
                                  price = 9.99;
                                });
                              },
                              child: Container(
                                height: 138,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 2,
                                    color: plan == "Monthly"
                                        ? Color(0xffFFCE00)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 12),
                                          Text(
                                            "MONTHLY",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: plan == "Monthly"
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: plan == "Monthly"
                                                  ? Color(0xffFFCE00)
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "\$9.99",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: plan == "Monthly"
                                                    ? AppTheme.primaryColor
                                                    : Colors.black),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "per month",
                                            style: TextStyle(
                                                color: plan == "Monthly"
                                                    ? AppTheme.primaryColor
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  plan = "Yearly";
                                  price = 89.99;
                                });
                              },
                              child: Container(
                                height: 138,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 2,
                                    color: plan == "Yearly"
                                        ? Color(0xffFFCE00)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 12),
                                          Text(
                                            "YEARLY",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: plan == "Yearly"
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: plan == "Yearly"
                                                  ? Color(0xffFFCE00)
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "\$89.99",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: plan == "Yearly"
                                                    ? AppTheme.primaryColor
                                                    : Colors.black),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "per year",
                                            style: TextStyle(
                                                color: plan == "Yearly"
                                                    ? AppTheme.primaryColor
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: plan == "Yearly"
                                              ? AppTheme.secondaryColor
                                              : Colors.grey.shade300,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "\$30 Save",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  plan = "Half Yearly";
                                  price = 49.99;
                                });
                              },
                              child: Container(
                                height: 138,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 2,
                                    color: plan == "Half Yearly"
                                        ? Color(0xffFFCE00)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 12),
                                          Text(
                                            "HALF YEAR",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: plan == "Half Yearly"
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: plan == "Half Yearly"
                                                  ? Color(0xffFFCE00)
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "\$49.99",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: plan == "Half Yearly"
                                                    ? AppTheme.primaryColor
                                                    : Colors.black),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "per 6 month",
                                            style: TextStyle(
                                                color: plan == "Half Yearly"
                                                    ? AppTheme.primaryColor
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: plan == "Half Yearly"
                                              ? AppTheme.secondaryColor
                                              : Colors.grey.shade300,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "\$30 Save",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      child: CupertinoButton.filled(
                        child: const Text(
                          "Get Premium",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PremiumPaymentScreen(
                                    plan: plan, price: price)),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
