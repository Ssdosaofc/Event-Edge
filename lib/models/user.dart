class User {
  int age;
  String state;
  String country;
  int pincode;
  String buyTime;
  String category;
  int amount;
  String payMethod;
  int eventID;
  int prevHistory;

  User({
    required this.age,
    required this.state,
    required this.country,
    required this.pincode,
    required this.buyTime,
    required this.category,
    required this.amount,
    required this.payMethod,
    required this.eventID,
    required this.prevHistory,
  });

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'state': state,
      'country': country,
      'pincode': pincode,
      'buying_time': buyTime,
      'category': category,
      'amount': amount,
      'payMethod': payMethod,
      'eventID': eventID,
      'repeat': prevHistory,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      age: map['age'],
      state: map['state'],
      country: map['country'],
      pincode: map['pincode'],
      buyTime: map['buyTime'],
      category: map['category'],
      amount: map['amount'],
      payMethod: map['payMethod'],
      eventID: map['eventID'],
      prevHistory: map['prevHistory'],
    );
  }
}
