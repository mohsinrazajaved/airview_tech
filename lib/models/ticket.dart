import 'package:intl/intl.dart';

class Ticket {
  String? currentUserUid;
  String? ticketid;
  String? type;
  String? arrival;
  String? departure;
  String? goDate;
  String? returnDate;
  String? description;
  String? title;
  String? city;
  String? country;
  String? price;
  String? dateTime;
  String? ownerName;
  String? ownerPhotoUrl;
  int? noOfTickets;
  DateTime? time;

  Ticket({
    this.currentUserUid,
    this.type,
    this.dateTime,
    this.time,
    this.title,
    this.description,
    this.city,
    this.country,
    this.price,
    this.ownerName,
    this.arrival,
    this.departure,
    this.goDate,
    this.returnDate,
    this.ownerPhotoUrl,
    this.noOfTickets,
  });

  Map<String, dynamic> toJson(Ticket ticket) {
    Map<String, dynamic> data = {};
    data['ownerUid'] = ticket.currentUserUid;
    data['ticketId'] = ticket.ticketid;
    data['dateTime'] = ticket.dateTime;
    data['title'] = ticket.title;
    data['time'] = ticket.time;
    data['city'] = ticket.city;
    data['description'] = ticket.description;
    data['country'] = ticket.country;
    data['price'] = ticket.price;
    data['type'] = ticket.type;
    data['ownerName'] = ticket.ownerName;
    data['arrival'] = ticket.arrival;
    data['departure'] = ticket.departure;
    data['goDate'] = ticket.goDate;
    data['returnDate'] = ticket.returnDate;
    data['noOfTickets'] = ticket.noOfTickets;

    return data;
  }

  Ticket.fromJson(Map<String, dynamic> mapData) {
    currentUserUid = mapData['ownerUid'];
    title = mapData['title'];
    description = mapData['description'];
    city = mapData['city'];
    country = mapData['country'];
    price = mapData['price'];
    type = mapData['type'];
    ticketid = mapData['ticketId'];
    dateTime = mapData['dateTime'];
    ownerName = mapData['ownerName'];
    time = DateFormat('dd-MM-yyyy HH:mm').parse(mapData['dateTime']);
    arrival = mapData['arrival'];
    departure = mapData['departure'];
    goDate = mapData['goDate'];
    returnDate = mapData['returnDate'];
    noOfTickets = mapData['noOfTickets'];
  }
}
