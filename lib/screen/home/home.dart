import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                        crossAxisAlignment: CrossAxisAlignment.start,         
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
                            label: spice.round() == 100 ? 'Low' : spice.round() == 200 ? 'Medium' : 'High',
                            onChanged: (val){
                              setModalState(() {
                                spice = val;
                              });
                            }
                          ),
                          SizedBox(height: 20,),
                          Center(
                            child: ElevatedButton(
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
                            ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (contex, index){
                final orderList = docs[index].data() as Map<String,dynamic>;
                return Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        Column(
                          
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Food : ${orderList['dish']}"),
                            SizedBox(height: 8,),
                            Text("Soft Drings : ${orderList['softDr']}"),
                            SizedBox(height: 8,),
                            Text("Spice : ${orderList['spice'] == 100? 'Low' : orderList['spice'] == 200? 'Medium' : 'High'}"),                      
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  border: BoxBorder.all(width: 1,color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(child: Icon(Icons.edit_note_outlined,color: Colors.white,))),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,                       
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
                                            label: spiceUpdate.round() == 100 ? 'Low' : spiceUpdate.round() == 200 ? 'Medium' : 'High',
                                            onChanged: (val){
                                              setModalState(() {
                                                spiceUpdate = val;
                                              });
                                            }
                                          ),
                                          SizedBox(height: 20,),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: ()async{
                                                String uid = orderList['uid'];
                                                String newDish = dishUpdateCtr.text.trim();
                                                String newSoftDrings = softDringsCtr.text.trim();
                                                print('uid: $uid, dish: $newDish, softDr: $newSoftDrings, spice: $spiceUpdate');
                                                await database.updateData(uid, newDish, newSoftDrings, spiceUpdate);
                                                Navigator.pop(context);
                                              }, 
                                              child: Text('Update Order')
                                            ),
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
                                      actionsAlignment: MainAxisAlignment.center,
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
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  border: BoxBorder.all(width: 1,color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(child: Icon(Icons.delete_outline, color: Colors.white,))
                              )
                            )
                          ],
                        ),
                      ],
                    ),
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