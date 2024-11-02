import 'package:airview_tech/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';

class OfferDetail extends StatelessWidget {
  final Ticket ticket;

  const OfferDetail({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('${ticket.departure} > ${ticket.arrival}',
          //     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          // centerTitle: true,
          // backgroundColor: const Color(0xFF73AEF5),
          // foregroundColor: Colors.white,
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${ticket.departure} > ${ticket.arrival}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            SellerInfoSection(ticket: ticket),
            const SizedBox(height: 16),
            PricingSection(ticket: ticket),
            const SizedBox(height: 16),
            FlightDetailsSection(ticket: ticket),
            const SizedBox(height: 16),
            Text("Description".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              ticket.description ?? "",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final Email email = Email(
                      body: 'Hi',
                      subject: 'Contact',
                      recipients: [ticket.sellerEmail ?? ""],
                      isHTML: false,
                    );

                    try {
                      await FlutterEmailSender.send(email);
                    } catch (error) {
                      print('Error sending email: $error');
                    }
                  },
                  icon: const Icon(Icons.mail),
                  label: Text("Contact".tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF6D),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlightDetailsSection extends StatelessWidget {
  final Ticket ticket;

  const FlightDetailsSection({Key? key, required this.ticket})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(
          label: Text("Arrival".tr,
              style: TextStyle(fontSize: 16, color: Colors.black)),
          value: ticket.departure ?? '',
        ),
        InfoRow(
          label: Text("Depart".tr,
              style: TextStyle(fontSize: 16, color: Colors.black)),
          value: ticket.arrival ?? '',
        ),
        InfoRow(
          label: const Icon(Icons.date_range, size: 20, color: Colors.grey),
          value: "Date depart".tr +
              "${ticket.goDate} - " +
              "Date arrival".tr +
              "${ticket.returnDate}",
        ),
      ],
    );
  }
}

class SellerInfoSection extends StatelessWidget {
  final Ticket ticket;

  const SellerInfoSection({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.ownerName ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ],
    );
  }
}

class PricingSection extends StatelessWidget {
  final Ticket ticket;

  const PricingSection({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Prix d achat: ",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              '€${ticket.price ?? '100'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              '${ticket.noOfTickets ?? 0} billet(s) disponible(s)',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final Widget label;
  final String value;

  const InfoRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label,
          const SizedBox(width: 4),
          Flexible(
              child: Text(value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF00BF6D),
                  ))),
        ],
      ),
    );
  }
}
