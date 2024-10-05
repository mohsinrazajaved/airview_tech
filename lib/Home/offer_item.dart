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
      child: Column(
        children: [
          _header(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.date_range, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Date départ ${ticket.goDate} - Date retour ${ticket.returnDate}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.flight_takeoff,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${ticket.departure ?? 'Unknown'} -> ${ticket.arrival ?? 'Unknown'} ",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.confirmation_num,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '${ticket.noOfTickets ?? 0} billet(s) disponible(s)',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${ticket.country ?? 'Unknown'} ${ticket.city ?? 'Unknown'} ",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          _footer()
        ],
      ),
    );
  }

  Container _header() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
          color: Color(0xFF73AEF5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${ticket.departure} > ${ticket.arrival}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _footer() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(ticket.ownerPhotoUrl ?? ''),
              radius: 16,
              backgroundColor: const Color(0xFF73AEF5),
            ),
            const SizedBox(width: 8),
            Text('par ${ticket.ownerName ?? ""}'),
          ],
        ),
      ),
    );
  }
}
