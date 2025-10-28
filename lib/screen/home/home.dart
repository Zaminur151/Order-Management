import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_manager/screen/home/order_list.dart';
import 'package:order_manager/service/database.dart';
import 'package:random_string/random_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseService database = DatabaseService();

  final List<DropdownMenuEntry<String>> dropDownItems = [
    DropdownMenuEntry(value: 'Mojo', label: 'Mojo'),
    DropdownMenuEntry(value: 'Water', label: 'Water'),
    DropdownMenuEntry(value: 'Pran Up', label: 'Pran Up')
  ];

  TextEditingController dishContoller = TextEditingController();
  TextEditingController dringsContoller = TextEditingController();
  double spice = 100.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: database.getData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        return Scaffold(
          appBar: AppBar(
            title: Text('Order List'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showModalBottomSheet(
                context: context, builder: (contex){
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(                        
                        children: [
                          Text('Enter dish name:',),
                          SizedBox(height: 10,),
                          TextField(
                            controller: dishContoller,  
                            decoration: InputDecoration(
                              
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              )
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text('Select soft drings:'),
                          SizedBox(height: 10,),
                          DropdownMenu(
                            width: double.maxFinite,
                            dropdownMenuEntries: dropDownItems,
                            controller: dringsContoller,
                          ),
                          SizedBox(height: 20,),
                          Text('Select spice:'),
                          SizedBox(height: 10,),
                          Slider(
                            value: spice,
                            divisions: 2,
                            min: 100,
                            max: 300,
                            label: spice.round().toString(),
                            onChanged: (val){
                              setModalState(() {
                                spice = val;
                              });
                            }
                          ),
                          SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: ()async{
                              String uid = randomString(10);
                              String dish = dishContoller.text.trim();
                              String softDrings = dringsContoller.text.trim();

                              print('uid: $uid, dish: $dish, softDr: $softDrings, spice: $spice');
                              await database.addToDatabase(uid, dish, softDrings, spice);
                              setState(() {
                                dishContoller.text= '';
                                dringsContoller.text = '';
                                spice = 100.0;
                              });
                              Navigator.pop(context);
                            }, 
                            child: Text('Confirm Order')
                          )
                        ],
                      ),
                    );}
                  );
                }
              );
            },
            child: Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (contex, index){
                final orderList = docs[index].data() as Map<String,dynamic>;
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
                            child: Icon(Icons.edit),
                            onTap: (){
          
                              double spiceUpdate= orderList['spice'];
                              final dishUpdateCtr = TextEditingController(text: orderList['dish']);
                              final softDringsCtr = TextEditingController(text:orderList['softDr']);
          
                              showModalBottomSheet(
                              context: context, builder: (contex){
                                return StatefulBuilder(
                                  builder: (context, setModalState) {
                                    return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(                        
                                      children: [
                                        Text('Enter dish name:',),
                                        SizedBox(height: 10,),
                                        TextField(
                                          controller: dishUpdateCtr,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                            )
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text('Select soft drings:'),
                                        SizedBox(height: 10,),
                                        DropdownMenu(                                         
                                          width: double.maxFinite,
                                          dropdownMenuEntries: dropDownItems,
                                          controller: softDringsCtr,
                                        ),
                                        SizedBox(height: 20,),
                                        Text('Select spice:'),
                                        SizedBox(height: 10,),
                                        Slider(
                                          value: spiceUpdate,
                                          divisions: 2,
                                          min: 100,
                                          max: 300,
                                          label: spiceUpdate.round().toString(),
                                          onChanged: (val){
                                            setModalState(() {
                                              spiceUpdate = val;
                                            });
                                          }
                                        ),
                                        SizedBox(height: 20,),
                                        ElevatedButton(
                                          onPressed: ()async{
                                            String uid = orderList['uid'];
                                            String newDish = dishUpdateCtr.text.trim();
                                            String newSoftDrings = softDringsCtr.text.trim();
                                            print('uid: $uid, dish: $newDish, softDr: $newSoftDrings, spice: $spiceUpdate');
                                            await database.updateData(uid, newDish, newSoftDrings, spiceUpdate);
                                            Navigator.pop(context);
                                          }, 
                                          child: Text('Update Order')
                                        )
                                      ],
                                    ),
                                  );}
                                );
                              }
                            );
                            },
                            
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
                                                onPressed: ()async{
                                                  await database.deleteData(orderList['uid']);
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
                    ],
                  ),
                );
              }
              ),
          ),
        );
      }
    );
  }
}