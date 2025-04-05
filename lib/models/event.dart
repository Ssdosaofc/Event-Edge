class Event{
  String poster;
  String title;
  String description;
  String address;
  String state;
  String country;
  String category;
  int tickets;
  int sold;
  int refunded;
  int remaining;
  String timestamp;
  String start;
  String end;
  int price;

  Event({
    required this.poster,
    required this.title,
    required this.description,
    required this.address,
    required this.state,
    required this.country,
    required this.category,
    required this.tickets,
    required this.timestamp,
    required this.start,
    required this.end,
    required this.price,
    this.sold = 0,
    this.refunded = 0,
  }) : remaining = tickets - sold + refunded;

  Map<String, dynamic> toMap() {
    return {
      'poster': poster,
      'title': title,
      'description': description,
      'address': address,
      'state': state,
      'country': country,
      'category': category,
      'tickets': tickets,
      'sold': sold,
      'refunded': refunded,
      'remaining': remaining,
      'timestamp': timestamp,
      'start': start,
      'end': end,
      'price':price,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      poster: map['poster'],
      title: map['title'],
      description: map['description'],
      address: map['address'],
      state: map['state'],
      country: map['country'],
      category: map['category'],
      tickets: map['tickets'],
      sold: map['sold'] ?? 0,
      refunded: map['refunded'] ?? 0,
      timestamp: map['timestamp'],
      start: map['start'],
      end: map['end'],
      price: map['price']
    );
  }
}