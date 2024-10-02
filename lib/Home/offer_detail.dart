import 'package:airview_tech/models/ticket.dart';
import 'package:flutter/material.dart';

class OfferDetail extends StatelessWidget {
  final Ticket ticket;

  const OfferDetail({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${ticket.departure} > ${ticket.arrival}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${ticket.departure} > ${ticket.arrival}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
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
            SellerInfoSection(ticket: ticket),
            const SizedBox(height: 16),
            PricingSection(ticket: ticket),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.contact_phone),
              label: const Text('Contact'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
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
          label: 'Aéroport de départ',
          value: ticket.departure ?? '',
        ),
        InfoRow(
          label: 'Aéroport d’arrivée',
          value: ticket.arrival ?? '',
        ),
        InfoRow(
          label: 'Date',
          value:
              'date départ ${ticket.goDate} - date retour ${ticket.returnDate}',
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
            const Text('Membre depuis 3 mois'),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.verified, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('Identité vérifiée'),
              ],
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
                  decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
        const Text(
          'Soit 1.67% d\'économies',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          Flexible(
              child: Text(value,
                  style: const TextStyle(fontSize: 16, color: Colors.orange))),
        ],
      ),
    );
  }
}
