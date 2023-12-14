
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trashhub/backend/backend.dart';
import 'package:trashhub/data/models/recyclehubmodel.dart';

import '../utils.dart';

class RecycleCentreCard extends StatefulWidget {
  final Function onJobBookedCallback;
  const RecycleCentreCard({super.key, required this.onJobBookedCallback});

  @override
  State<RecycleCentreCard> createState() => _RecycleCentreCardState();
}

class _RecycleCentreCardState extends State<RecycleCentreCard> {
  List<RCHPartner> centres = [];

  bool centreLoading = false;

  Future<int> getUserUID() async {
    final prefs = await SharedPreferences.getInstance();
    final saveduname = prefs.getString('loggedin_username');
    if (saveduname == null || saveduname.isEmpty) {
      // ignore: use_build_context_synchronously
      Utils.showUserDialog(
        context: context,
        title: 'Login Required',
        content: 'Please Login to perform this action',
      );
      return -1;
    }
    final uid = await TrashHubBackend().getIDFromUsername(saveduname);
    if (uid.result == null) {
      // ignore: use_build_context_synchronously
      Utils.showUserDialog(
        context: context,
        title: 'Could not find user',
        content: uid.message,
      );
      return -1;
    }
    return uid.result!;
  }

  getAllPartners({
    String filter = 'all',
  }) async {
    centreLoading = true;
    setState(() {});
    final partners = await TrashHubBackend().getRCHPartners(filter: filter);
    if (partners.result == null) {
      print('ERROR => ${partners.message}');
      return;
    }
    for (final partner in partners.result!) {
      centres = [
        ...centres,
        RCHPartner(
          id: partner['id'],
          name: partner['name'],
          type: partner['type'],
          contact: '9449320808',
          imagePath:
              partner['id'] > 5 ? centerimages[0] : centerimages[partner['id']],
        ),
      ];
    }
    centreLoading = false;
    setState(() {});
  }

  bookJob({
    required String name,
    required int partnerId,
  }) async {
    ToastContext().init(context);
    final uid = await getUserUID();
    if (uid == -1) {
      print('UID NOT FOUND!');
      return;
    }

    LatLng loc = const LatLng(12.9198, 77.5777);
    final res = await TrashHubBackend().requestJob(
      name: name,
      status: 'requested',
      loc: loc,
      userId: uid,
      partnerId: partnerId,
    );
    if (res.result == null) {
      Toast.show(res.message);
      return;
    }
    Toast.show('Job Booked!');
  }

  @override
  void initState() {
    super.initState();
    getAllPartners();
  }

  final centerimages = [
    "assets/RecycleHubpt3.webp",
    "assets/RecycleHubpt3.webp",
    "assets/RecycleHubpt.jpeg",
    "assets/RecycleHubpt.jpeg",
    "assets/RecycleHubpt2.jpeg",
    "assets/RecycleHubpt1.jpg",
  ];

  void _openCentreDetails(BuildContext context, RCHPartner centre) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Image.asset(
                centre.imagePath,
                height: 250,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Name : ${centre.name}',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Type : ${centre.type}',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.call,
                  color: Colors.blue,
                ),
                label: Text(
                  centre.contact,
                  style: const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  print('Booking Job');
                  await bookJob(
                    partnerId: centre.id,
                    name: 'RecycleJob Request',
                  );
                  print('Job Booked');
                  widget.onJobBookedCallback();
                },
                icon: const Icon(Icons.call_merge),
                label: const Text('Book'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: centreLoading
          ? const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: centres.length,
              itemBuilder: (BuildContext context, int index) {
                final centre = centres[index];
                return GestureDetector(
                  onTap: () {
                    _openCentreDetails(context, centre);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            centre.imagePath,
                            fit: BoxFit.cover,
                            height: 120,
                            width: 270, // Adjust the image height as needed
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Name : ${centre.name}',
                              style: GoogleFonts.aBeeZee(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Type : ${centre.type}',
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              print(centre.id);
                              print('Booking Job');
                              await bookJob(
                                partnerId: centre.id,
                                name: 'RecycleJob Request',
                              );
                              print('Job Booked');
                              widget.onJobBookedCallback();
                            },
                            icon: const Icon(Icons.call_merge),
                            label: const Text('Book'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
