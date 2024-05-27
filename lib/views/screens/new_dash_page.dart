import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/views/screens/dashboard.dart';
import 'package:my_app/views/screens/monthly_sales.dart';
import 'package:my_app/views/screens/product_rank_page.dart';
import 'package:my_app/views/screens/weekly_sales.dart';
import 'package:my_app/views/screens/yearly_sales.dart';

class NewDashPage extends StatefulWidget {
  const NewDashPage({super.key});

  @override
  State<NewDashPage> createState() => _NewDashPageState();
}

class _NewDashPageState extends State<NewDashPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 4, 83, 158),
            toolbarHeight: 120,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 254, 240, 2),
                ),
              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Image(
                      image: ExactAssetImage('assets/images/hgt_logo.png'),
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Harry Guantero Trading".toUpperCase(),
                      style: GoogleFonts.anton(
                        fontSize: 30,
                        letterSpacing: 10,
                        wordSpacing: 4,
                        color: const Color.fromARGB(255, 254, 240, 2),
                      ),
                    ),
                    Text(
                      "M. Revil St. Corner Barrientos St., Poblacion 2, Oroquieta City Misamis Occidental, Philippines",
                      style: GoogleFonts.anton(
                        fontSize: 15,
                        wordSpacing: 4,
                        color: const Color.fromARGB(255, 254, 240, 2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bottom: TabBar(
                labelColor: const Color.fromARGB(255, 252, 255, 58),
                labelStyle: GoogleFonts.roboto(
                  letterSpacing: 3,
                ),
                tabs: const [
                  Tab(
                    text: 'Daily Sales',
                  ),
                  Tab(
                    text: 'Weekly Sales',
                  ),
                  Tab(
                    text: 'Monthly Sales',
                  ),
                  Tab(
                    text: 'Yearly Sales',
                  ),
                  Tab(
                    text: 'Product Rank',
                  ),
                ]),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 4, 83, 158),
            ),
            child: const Column(
              children: [
                Expanded(
                  child: TabBarView(children: [
                    DashboardPage(),
                    WeeklyPage(),
                    MonthlyPage(),
                    YearlyPage(),
                    ProductRank(),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
