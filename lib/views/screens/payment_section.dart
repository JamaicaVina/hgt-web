import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/views/screens/completed_orders.dart';
import 'package:my_app/views/screens/confirmed_orders.dart';
import 'package:my_app/views/screens/on_delivery_orders.dart';
import 'package:my_app/views/screens/pending_order.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 4, 83, 158),
            toolbarHeight: 120,
            centerTitle: true,
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
                    text: 'Pending',
                    icon: Icon(Icons.pending,
                        color: Color.fromARGB(255, 254, 240, 2)),
                  ),
                  Tab(
                    text: 'Confirmed',
                    icon: Icon(Icons.check,
                        color: Color.fromARGB(255, 254, 240, 2)),
                  ),
                  Tab(
                    text: 'On-Delivery',
                    icon: Icon(Icons.electric_scooter,
                        color: Color.fromARGB(255, 254, 240, 2)),
                  ),
                  Tab(
                    text: 'Delivered',
                    icon: Icon(Icons.check_box,
                        color: Color.fromARGB(255, 254, 240, 2)),
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
                    PendingPage(),
                    ConfirmedPage(),
                    OnDeliveryPage(),
                    CompletedOrdersPage(),
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
