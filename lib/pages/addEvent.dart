import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../models/event.dart';
import '../utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';


class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _ticketsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  File? filePath;
  final ImagePicker picker = ImagePicker();
  final Uuid uuid = Uuid();


  String val = '';

  DateTime? _eventDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  DateTime? startDateTime;
  DateTime? endDateTime;
  int? startTimestamp;
  int? endTimestamp;

  bool isLoading = false;
  final Dio _dio = Dio();

  Future<String?> fileToBase64(File? file) async {
    if (file == null) return null;

    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error converting file to base64: $e');
      return null;
    }
  }

  Future<void> _addResult() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _countryController.text.isEmpty ||
        _ticketsController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _eventDate == null ||
        _startTime == null ||
        _endTime == null ||
        val.isEmpty ||
        filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 500),
          backgroundColor: Colors.red,
          content: Container(

            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline,color: Colors.white,),
                Text(" All fields are required"),
              ],
            ),
          )));
      return;
    }
    try {
      if (_eventDate != null && _startTime != null && _endTime != null) {
        startDateTime = DateTime(
          _eventDate!.year,
          _eventDate!.month,
          _eventDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );

        endDateTime = DateTime(
          _eventDate!.year,
          _eventDate!.month,
          _eventDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );

        startTimestamp = startDateTime?.millisecondsSinceEpoch;
        endTimestamp = endDateTime?.millisecondsSinceEpoch;
        setState(() {
          isLoading = true;
        });

        Future.delayed(Duration(milliseconds: 300), () async {
          final response = await _dio.post(
            'http://10.100.59.55:4000/api/events',
            data: jsonEncode(
              Event(
                // poster: base64Encode(await filePath!.readAsBytes()),
                poster: 'jbjn.',
                title: _titleController.text,
                description: _descController.text,
                address: _addressController.text,
                state: _stateController.text,
                country: _countryController.text,
                category: val,
                tickets: _ticketsController.value.text == ''
                    ? 0
                    : int.parse(_priceController.value.text),
                timestamp: DateTime.now().toString(),
                start: startTimestamp.toString(),
                end: endTimestamp.toString(),
                price: _priceController.value.text == '' ? 0 : double.parse(_priceController.value.text),
                id: uuid.v4(),
              ).toMap(),
            ),
            options: Options(
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
            ),
          );

          print(response);
          _showShareDialog();
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error uploading image: $e');
    }
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Event Added"),
          content: Text("Your event has been successfully added. Do you want to share it on social media?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _shareEvent();
                Navigator.of(context).pop();
              },
              child: Text("Share"),
            ),
          ],
        );
      },
    );
  }

  void _shareEvent() {
    final eventDetails = "Check out this event!\n\n"
        "Title: ${_titleController.text}\n"
        "Description: ${_descController.text}\n"
        "Location: ${_addressController.text}, ${_stateController.text}, ${_countryController.text}\n"
        "Tickets: ${_ticketsController.text} available\n"
        "Price: \$${_priceController.text}\n"
        "Date: ${_eventController.text}\n"
        "Start Time: ${_startController.text}\n"
        "End Time: ${_endController.text}";

    Share.share(eventDetails);
  }

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
    return SafeArea(
      child: Scaffold(
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
                  TextButton(
                      onPressed: _addResult,
                      child: Text('Add',style: TextStyle(color: orange),)),
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
                      controller: _stateController,
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
                      controller: _countryController,
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
                keyboardType: TextInputType.datetime,
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