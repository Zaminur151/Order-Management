import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text('Rice'),
          SizedBox(height: 20,),
          Text('Mojo'),
          SizedBox(height: 20,),
          Text('Spicy'),
        
        ],
      ),
    );
  }
}