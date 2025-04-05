import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/constants.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ticketsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  File? filePath;
  final ImagePicker picker = ImagePicker();

  String val = '';

  DateTime? _eventDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    filePath=null;
    _eventDate = null;
    _startTime = null;
    _endTime = null;
  }

  pickImage() async{
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    var imgMap = File(image.path);

    setState(() {
      filePath = imgMap;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _ticketsController.dispose();
    _priceController.dispose();
    _eventController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       height: 5,
            //       width: 80,
            //       decoration: BoxDecoration(
            //         color: Colors.grey[800],
            //           borderRadius: BorderRadius.circular(5)
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text('Cancel',style: TextStyle(color: Colors.grey),)),
                Text('Add Event',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 20),),
                TextButton(onPressed: (){}, child: Text('Add',style: TextStyle(color: orange),)),
              ],
            ),
            SizedBox(height: 15,),
            Text('Add Poster',style: GoogleFonts.poppins(fontSize:18),),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                pickImage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (filePath== null)?Image(image: AssetImage('assets/images/blank.png'),height: 256,width: 256,)
                      :Image.file(filePath!,height: 256,width: 256),
                ],
              ),
            ),
            Text('Title',style: GoogleFonts.poppins(fontSize:18),),
            SizedBox(height: 10,),
            TextField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              // style: TextStyle(color: Colors.white),
              decoration:InputDecoration(
                labelText: 'Enter your Title',
                labelStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text('Description',style: GoogleFonts.poppins(fontSize:18),),
            SizedBox(height: 10,),
            TextField(
              controller: _descController,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Write your description here..',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Text('Location',style: GoogleFonts.poppins(fontSize:18),),
                IconButton(
                    onPressed: (){

                    },
                    icon: Icon(
                      CupertinoIcons.location_solid, color: Colors.grey[800],size: 25,
                    )
                )
              ],
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _addressController,
              keyboardType: TextInputType.text,
              decoration:InputDecoration(
                prefixIcon: Icon(CupertinoIcons.building_2_fill),
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))
                ),
              ),
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2 - 22.5,
                  child: TextField(
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    decoration:InputDecoration(
                      labelText: 'State',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2 - 22.5,
                  child: TextField(
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    decoration:InputDecoration(
                      labelText: 'Country',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Text('Category',style: GoogleFonts.poppins(fontSize:18),),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 11.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  border: Border.all(color: Colors.grey)
              ),
              child: DropdownButton(
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down_outlined),
                  value: val,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem<String>(
                      value: '',
                      child: Text("Select a Category",style: TextStyle(color: Colors.grey),),
                    ),DropdownMenuItem<String>(
                      value: 'Concert',
                      child: Text("Concert"),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Show',
                      child: Text("Show"),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Party',
                      child: Text("Party"),
                    ),
                  ],
                  onChanged: (nval){
                    setState(() {
                      val = nval!;
                    });
                  }),
            ),
            SizedBox(height: 15,),
            Text('Number of Tickets',style: GoogleFonts.poppins(fontSize:18),),
            SizedBox(height: 10,),
            TextField(
              controller: _ticketsController,
              keyboardType: TextInputType.number,
              decoration:InputDecoration(
                hintText: 'Enter maximum number of tickets',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text('Price',style: GoogleFonts.poppins(fontSize:18),),
            SizedBox(height: 10,),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration:InputDecoration(
                hintText: 'Enter ticket price',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text('Event Date',style: GoogleFonts.poppins(fontSize:18),),
            SizedBox(height: 10,),
            TextField(
              controller: _eventController,
              // keyboardType: TextInputType.datetime,
              decoration:InputDecoration(
                  hintText: 'Date',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))
                  ),
                  suffixIcon: Icon(CupertinoIcons.calendar)
              ),
              readOnly: true,
              onTap: selectDate,
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Time',style: GoogleFonts.poppins(fontSize:18),),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2 - 22.5,
                      child: TextField(
                        controller: _startController,
                        // keyboardType: TextInputType.datetime,
                        decoration:InputDecoration(
                            hintText: 'Start',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(18))
                            ),
                            suffixIcon: Icon(CupertinoIcons.clock)
                        ),
                        readOnly: true,
                        onTap: selectStartTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('End Time',style: GoogleFonts.poppins(fontSize:18),),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2 - 22.5,
                      child: TextField(
                        controller: _endController,
                        // keyboardType: TextInputType.datetime,
                        decoration:InputDecoration(
                            hintText: 'End',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(18))
                            ),
                            suffixIcon: Icon(CupertinoIcons.clock)
                        ),
                        readOnly: true,
                        onTap: selectEndTime,
                      ),
                    ),
                  ],
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> selectDate() async{
    _eventDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(), lastDate: DateTime(2100)
    );

    if(_eventDate != null){
      _eventController.text = _eventDate.toString().split(" ")[0];
    }
  }

  Future<void> selectStartTime() async{
    _startTime = await showTimePicker(context: context,
      initialTime: TimeOfDay.now(),
    );
    _startController.text = '${_startTime!.hour}:${_startTime!.minute}';
  }
  Future<void> selectEndTime() async{
    _endTime = await showTimePicker(context: context,
      initialTime: TimeOfDay.now(),
    );
    _endController.text = '${_endTime!.hour}:${_endTime!.minute}';
  }
}