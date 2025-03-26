class OrderedItem {
  final String name;
  final int quantity;

  OrderedItem({required this.name, required this.quantity});
}

class Order {
  final String id;
  final String customerName;
  final String delivery;
  final DateTime orderDate;
  final List<OrderedItem> orderedItems;
  final double subTotal;
  final double deliveryCost;
  final double totalCost;
  String status;
  final String paymentMethod;
  final String deliveryLocation;
  final double distance;

  Order({
    required this.id,
    required this.customerName,
    required this.delivery,
    required this.orderDate,
    required this.orderedItems,
    required this.subTotal,
    required this.deliveryCost,
    required this.totalCost,
    required this.status,
    required this.paymentMethod,
    required this.deliveryLocation,
    required this.distance,
  });
}

final List<Order> dummyOrders = [
  Order(
    id: 'ORD001',
    customerName: 'John Doe',
    delivery: 'Home Delivery',
    orderDate: DateTime.parse('2025-03-19'),
    orderedItems: [
      OrderedItem(name: 'Pizza', quantity: 1),
      OrderedItem(name: 'Coke', quantity: 2),
      OrderedItem(name: 'Fries', quantity: 1),
    ],
    subTotal: 25.50,
    deliveryCost: 3.00,
    totalCost: 28.50,
    status: 'pickup',
    paymentMethod: 'Credit Card',
    deliveryLocation: '123 Main St, Cityville',
    distance: 5.2,
  ),
  Order(
    id: 'ORD002',
    customerName: 'Alice Smith',
    delivery: 'Pickup',
    orderDate: DateTime.parse('2025-03-18'),
    orderedItems: [
      OrderedItem(name: 'Burger', quantity: 1),
      OrderedItem(name: 'Milkshake', quantity: 1),
    ],
    subTotal: 15.75,
    deliveryCost: 0.00,
    totalCost: 15.75,
    status: 'Pickup',
    paymentMethod: 'Cash',
    deliveryLocation: 'Downtown Restaurant',
    distance: 0.0,
  ),
  Order(
    id: 'ORD003',
    customerName: 'Michael Johnson',
    delivery: 'Home Delivery',
    orderDate: DateTime.parse('2025-03-17'),
    orderedItems: [
      OrderedItem(name: 'Pasta', quantity: 1),
      OrderedItem(name: 'Garlic Bread', quantity: 2),
    ],
    subTotal: 22.00,
    deliveryCost: 2.50,
    totalCost: 24.50,
    status: 'Pickup',
    paymentMethod: 'UPI',
    deliveryLocation: '456 Elm St, Metropolis',
    distance: 8.3,
  ),
  Order(
    id: 'ORD004',
    customerName: 'Emma Wilson',
    delivery: 'Home Delivery',
    orderDate: DateTime.parse('2025-03-16'),
    orderedItems: [
      OrderedItem(name: 'Sushi', quantity: 3),
      OrderedItem(name: 'Miso Soup', quantity: 1),
      OrderedItem(name: 'Green Tea', quantity: 1),
    ],
    subTotal: 35.20,
    deliveryCost: 4.00,
    totalCost: 39.20,
    status: 'Pickup',
    paymentMethod: 'Debit Card',
    deliveryLocation: '789 Pine St, Springfield',
    distance: 10.1,
  ),
  Order(
    id: 'ORD005',
    customerName: 'David Brown',
    delivery: 'Pickup',
    orderDate: DateTime.parse('2025-03-15'),
    orderedItems: [
      OrderedItem(name: 'Taco', quantity: 2),
      OrderedItem(name: 'Nachos', quantity: 1),
      OrderedItem(name: 'Lemonade', quantity: 1),
    ],
    subTotal: 18.50,
    deliveryCost: 0.00,
    totalCost: 18.50,
    status: 'Pickup',
    paymentMethod: 'PayPal',
    deliveryLocation: 'Mexican Grill',
    distance: 0.0,
  ),
  Order(
    id: 'ORD006',
    customerName: 'Sophia Martinez',
    delivery: 'Home Delivery',
    orderDate: DateTime.parse('2025-03-14'),
    orderedItems: [
      OrderedItem(name: 'Grilled Chicken', quantity: 1),
      OrderedItem(name: 'Mashed Potatoes', quantity: 1),
      OrderedItem(name: 'Iced Tea', quantity: 1),
    ],
    subTotal: 28.00,
    deliveryCost: 3.50,
    totalCost: 31.50,
    status: 'Pickup',
    paymentMethod: 'Credit Card',
    deliveryLocation: '321 Oak St, Riverdale',
    distance: 7.4,
  ),
  Order(
    id: 'ORD007',
    customerName: 'James Anderson',
    delivery: 'Pickup',
    orderDate: DateTime.parse('2025-03-13'),
    orderedItems: [
      OrderedItem(name: 'Pancakes', quantity: 3),
      OrderedItem(name: 'Orange Juice', quantity: 1),
    ],
    subTotal: 12.25,
    deliveryCost: 0.00,
    totalCost: 12.25,
    status: 'Pickup',
    paymentMethod: 'Cash',
    deliveryLocation: 'Sunny Café',
    distance: 0.0,
  ),
];
