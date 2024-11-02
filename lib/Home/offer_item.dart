import 'package:airview_tech/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_widget/ticket_widget.dart';

class OfferItem extends StatelessWidget {
  final Ticket ticket;

  const OfferItem({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TicketWidget(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.35,
      isCornerRounded: true,
      color: const Color(0xFF00BF6D).withOpacity(0.8),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [_header(), _content()],
      ),
    );
  }

  Widget _content() {
    return Padding(
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
                      color: Colors.white,
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
              const Icon(
                Icons.date_range,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${"Date depart".tr} ${ticket.goDate} - ${"Date arrival".tr} ${ticket.returnDate}',
                  style: const TextStyle(
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(
                getImage(),
                width: 16,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                "${ticket.departure ?? 'Unknown'} -> ${ticket.arrival ?? 'Unknown'} ",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.confirmation_num,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                '${ticket.noOfTickets ?? 0} billet(s) disponible(s)',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                '${"name".tr} ${ticket.ownerName ?? ""}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getImage() {
    if (ticket.type == "bus") {
      return "assets/bus.png";
    } else if (ticket.type == "train") {
      return "assets/train.png";
    } else {
      return "assets/plane.png";
    }
  }

  Widget _header() {
    return Padding(
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
    );
  }
}
