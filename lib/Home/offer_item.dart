import 'package:airview_tech/models/ticket.dart';
import 'package:flutter/material.dart';

class OfferItem extends StatelessWidget {
  final Ticket ticket;

  const OfferItem({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ticket.departure} > ${ticket.arrival}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '€${ticket.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'date départ ${ticket.goDate} - date retour ${ticket.returnDate}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  ticket.country ?? 'Unknown',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.flight_takeoff, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  ticket.city ?? 'Unknown',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.confirmation_num, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  '1 billet(s) disponible(s)',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(ticket.ownerPhotoUrl ?? ''),
                  radius: 16,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 8),
                Text('par ${ticket.ownerName}'),
                const Icon(Icons.verified, size: 16, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
