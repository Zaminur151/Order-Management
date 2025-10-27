import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:order_manager/screen/home/order_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<DropdownMenuEntry<String>> dropDownItems = [
    DropdownMenuEntry(value: 'Mojo', label: 'Mojo'),
    DropdownMenuEntry(value: 'Water', label: 'Water'),
    DropdownMenuEntry(value: 'Pran Up', label: 'Pran Up')
  ];

  final List<Map<String, dynamic>> items = [
    {'dish': 'Rice', 'softDr':'Mojo', 'spice':200},
    {'dish': 'Fride Rice', 'softDr':'Mojo Can', 'spice':100},
    {'dish': 'Biriyani', 'softDr':'Mojo Small', 'spice':300},
    {'dish': 'Mutton', 'softDr':'Mojo King', 'spice':200},
    {'dish': 'Rice', 'softDr':'Mojo', 'spice':100},
  ];

  TextEditingController dishContoller = TextEditingController(text: 'hey');
  TextEditingController dringsContoller = TextEditingController();
  TextEditingController spicyContoller = TextEditingController();

  String dish = '';
  String softDrings = '';
  double spice = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print('Add');
        },
        child: Icon(Icons.add),
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (contex, index){
            final orderList = items[index];
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [ 
                  Column(
                    children: [
                      Text(orderList['dish']),
                      SizedBox(height: 20,),
                      Text(orderList['softDr']),
                      SizedBox(height: 20,),
                      Text(orderList['spice'].toString()),
                     
                    
                    ],
                  ),
                  
                  Column(
                   
                    children: [
                      GestureDetector(
                                onTap: (){
                                  showModalBottomSheet(
                                    context: context, builder: (contex){
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          
                                          children: [
                                            TextField(
                                              controller: dishContoller,
                                              decoration: InputDecoration(
                                                hintText: orderList['dish']??'Input Dish',
                                               // label: Text(),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                                )
                                              ),
                                              onChanged: (value) => setState(() {
                                                dish = value;
                                              }),
                                            ),
                                            SizedBox(height: 20,),
                                            DropdownMenu(
                                              hintText: orderList['softDr']??'Select Soft Drings',
                                              //label: Text(orderList['softDr']),
                                              width: double.maxFinite,
                                              initialSelection: orderList['softDr']?? 'Select one',
                                              dropdownMenuEntries: dropDownItems,
                                              controller: dringsContoller,
                                            ),
                                            SizedBox(height: 20,),
                                            Slider(
                                              
                                              value: (orderList['spice'] as num?)?.toDouble()?? 100.0, 
                                              divisions: 2,
                                              min: 100,
                                              max: 300,
                                              onChanged: (val){
                                                setState(() {
                                                  spice = val;
                                                });
                                              }
                                              )
                                          ],
                                        ),
                                      );
                                    }
                                    );
                                },
                                child: Icon(Icons.edit)
                                ),
                              SizedBox(height: 30,),
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context, 
                                    builder: (contex){
                                      return AlertDialog(
                                        title: Text('Confirm Delete'),
                                        content: Text('Are you sure you want to delete this manu?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            }, child: Text('Cancel')
                                          ),
                                          ElevatedButton(
                                            onPressed: (){
                                              setState(() {
                                                orderList.remove(index);
                                              });
                                              Navigator.pop(context);
                                            }, child: Text('Delete')
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                },
                                child: Icon(Icons.delete))
                    ],
                  ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                              
                  //           ],
                  //         ),
                  // ),
                ],
              ),
            );
          }
          ),
      ),
    );
  }
}