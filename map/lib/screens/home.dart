import 'package:flutter/material.dart';

import '../widgets/scaffold_map.dart';

class Pwcmap extends StatefulWidget {
  const Pwcmap({super.key});

  @override
  State<Pwcmap> createState() => _PwcmapState();
}

class _PwcmapState extends State<Pwcmap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold_pwcmap(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 120,
            child: const Image(
              image: NetworkImage(
                  'https://th.bing.com/th/id/R.682aa81619f08a3e70882caabc02bf1a?rik=66qZRlxw%2fUF4uQ&riu=http%3a%2f%2fwww.pixelstalk.net%2fwp-content%2fuploads%2f2016%2f05%2fBlack-Wallpapers.jpg&ehk=LNjUriMFdpN63FITBbYU1YwLtThAvtDX1iKQOd7KfoY%3d&risl=&pid=ImgRaw&r=0'),
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  SizedBox(
                    height: 35,
                    width: 220,
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        //add prefix icon
                        prefixIcon: const Icon(
                          Icons.map,
                          color: Colors.grey,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        fillColor: Colors.grey,

                        //make hint text
                        hintStyle: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),

                        //create lable
                        labelText: 'City Name',
                        //lable style
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
