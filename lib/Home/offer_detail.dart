import 'package:airview_tech/models/ticket.dart';
import 'package:flutter/material.dart';

class OfferDetail extends StatelessWidget {
  final Ticket ticket;

  const OfferDetail({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${ticket.departure} > ${ticket.arrival}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF73AEF5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SellerInfoSection(ticket: ticket),
            const SizedBox(height: 16),
            PricingSection(ticket: ticket),
            const SizedBox(height: 16),
            FlightDetailsSection(ticket: ticket),
            const SizedBox(height: 16),
            const Text('Description',
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
                  onPressed: () {},
                  icon: const Icon(Icons.mail),
                  label: const Text('Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF73AEF5),
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
          label: const Text('Départ',
              style: TextStyle(fontSize: 16, color: Colors.black)),
          value: ticket.departure ?? '',
        ),
        InfoRow(
          label: const Text('Arrivée',
              style: TextStyle(fontSize: 16, color: Colors.black)),
          value: ticket.arrival ?? '',
        ),
        InfoRow(
          label: const Icon(Icons.date_range, size: 20, color: Colors.grey),
          value:
              'Date départ ${ticket.goDate} - Date retour ${ticket.returnDate}',
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
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(ticket.ownerPhotoUrl ?? ''),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.ownerName ?? 'Benni',
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
              'Prix d\'achat: ',
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
                  style: const TextStyle(fontSize: 16, color: Colors.orange))),
        ],
      ),
    );
  }
}
