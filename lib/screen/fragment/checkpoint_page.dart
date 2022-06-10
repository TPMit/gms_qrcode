// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import 'component/app_color.dart';

class CheckPointPage extends StatefulWidget {
  const CheckPointPage({Key? key}) : super(key: key);

  @override
  _CheckPointPageState createState() => _CheckPointPageState();
}

class _CheckPointPageState extends State<CheckPointPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///vertical spacing
              const SizedBox(
                height: 16,
              ),
      
              ///Container for actionables
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Daftar Checkpoint",
                      style: GoogleFonts.poppins(
                        color: AppColors.lightGreenColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: AppColors.veryLightTextColor,
                    ), onPressed: () { 
                      print('test');
                     },
                  )
                ],
              ),
      
              ///vertical spacing
              const SizedBox(
                height: 16,
              ),
      
              ///Container for places list
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              height: 150,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SvgPicture.asset('assets/img/2.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight: Radius.circular(20)),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.7),
                                                  Colors.transparent
                                                ]))),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                              child: Container(
                                                  color: Colors.green,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Icon(
                                                      LineIcons.check))),
                                          const SizedBox(width: 10),
                                          const Text('Post pertama',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              height: 150,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SvgPicture.asset('assets/img/2.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight: Radius.circular(20)),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.7),
                                                  Colors.transparent
                                                ]))),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                              child: Container(
                                                  color: Colors.grey,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Icon(
                                                      LineIcons.spinner))),
                                          const SizedBox(width: 10),
                                          const Text('Post pertama',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              height: 150,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SvgPicture.asset('assets/img/2.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight: Radius.circular(20)),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.7),
                                                  Colors.transparent
                                                ]))),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                              child: Container(
                                                  color: Colors.grey,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Text('segera isi',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30,
                                                          fontFamily:
                                                              'orilla')))),
                                          const SizedBox(width: 10),
                                          const Text('Post pertama',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              height: 150,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SvgPicture.asset('assets/img/2.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight: Radius.circular(20)),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.7),
                                                  Colors.transparent
                                                ]))),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                              child: Container(
                                                  color: Colors.grey,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Text('segera isi',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30,
                                                          fontFamily:
                                                              'orilla')))),
                                          const SizedBox(width: 10),
                                          const Text('Post pertama',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              height: 150,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SvgPicture.asset('assets/img/2.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight: Radius.circular(20)),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.7),
                                                  Colors.transparent
                                                ]))),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                              child: Container(
                                                  color: Colors.grey,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Text('segera isi',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30,
                                                          fontFamily:
                                                              'orilla')))),
                                          const SizedBox(width: 10),
                                          const Text('Post pertama',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPlaceWidget(imagePath) {
    return GestureDetector(
      onTap: () {
        ///For going on next screen
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(

        //         ///Send image path as we have setted it as tag of hero
        //         builder: (context) => DetailScreen(imagePath)));
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.lightRedColor),
          child: Stack(
            children: [
              Hero(
                ///For hero animation on route transition
                tag: imagePath,
                child: ClipRRect(
                  child: SvgPicture.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              ///For rating and title
              Positioned(
                top: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pakistan",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),

                    ///Rating
                    Chip(
                      backgroundColor: Colors.white,
                      label: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.lightGreenColor,
                            size: 15,
                          ),

                          ///For  space
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "4.0",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.veryLightTextColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
