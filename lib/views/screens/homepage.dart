import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/controller/home_controller.dart';
import 'package:my_app/new/messagepage.dart';
import 'package:my_app/services/notif_service.dart';
import 'package:my_app/views/chat_screen/messaging_screen.dart';
import 'package:my_app/views/screens/about_us.dart';
import 'package:my_app/views/screens/category_page.dart';
import 'package:my_app/views/screens/add_remove_products.dart';
import 'package:my_app/views/screens/add_remove_promo.dart';
import 'package:my_app/views/screens/customer_feedback.dart';
import 'package:my_app/views/screens/dashboard.dart';
import 'package:my_app/views/screens/completed_orders.dart';
import 'package:my_app/views/screens/new_dash_page.dart';

import 'package:my_app/views/screens/payment_section.dart';
import 'package:my_app/views/screens/privacy_policy.dart';
import 'package:my_app/views/screens/terms_and_conditions.dart';
import 'package:my_app/views/screens/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _controller = PageController();

  NavigationRailLabelType labelType = NavigationRailLabelType.none;

  static final notifications = NotificationService();

  @override
  void initState() {
    _controller;
    notifications.firebaseNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    elevation: 10,
                    minWidth: 100,
                    backgroundColor: Colors.grey[300],
                    unselectedIconTheme: const IconThemeData(
                      color: Colors.black,
                    ),
                    selectedIconTheme: const IconThemeData(
                      color: Color.fromARGB(255, 4, 83, 158),
                    ),
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                        _controller.jumpToPage(_selectedIndex);
                      });
                    },
                    labelType: labelType,
                    destinations: <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.dashcube,
                        ),
                        label: Text(
                          'Dashboard',
                          style: GoogleFonts.roboto(
                            color: Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.cart_shopping,
                          size: 35,
                        ),
                        label: Text(
                          'Orders & Payment',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.box,
                          size: 35,
                        ),
                        label: Text(
                          'Add/Remove Category',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.store,
                          size: 35,
                        ),
                        label: Text(
                          'Add/Remove Product',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.rectangle_ad,
                          size: 35,
                        ),
                        label: Text(
                          'Add/Remove Promo',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ), NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.envelope_open_text,
                          size: 35,
                        ),
                        label: Text(
                          'Messages',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                       NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.user_group,
                          size: 35,
                        ),
                        label: Text(
                          'Users',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.comments,
                          size: 35,
                        ),
                        label: Text(
                          'Customer Feedback',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                       NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.file_circle_check,
                          size: 35,
                        ),
                        label: Text(
                          'Privacy Policy',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(
                           FontAwesome.user_shield,
                          size: 35,
                        ),
                        label: Text(
                          ' Terms and Conditions',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(
                          FontAwesome.circle_info,
                          size: 35,
                        ),
                        label: Text(
                          'About Us',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
                            letterSpacing: 2,
                          ),
                        ),
                      ), 
                    
                    ],
                  ),
                ),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 7,
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: const [
                  NewDashPage(),
                  PaymentSection(),
                  CategoryPage(),
                 AddorRemoveProductsPage(),
                  AddRemovePromo(),
                  MessagesPage(),
                  ViewUserPage(),
                  CustomerFeedbackPage(),
                  TermsAndConditionsPage(),
                  PrivacyPolicyPage(),
                  AboutUsPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
