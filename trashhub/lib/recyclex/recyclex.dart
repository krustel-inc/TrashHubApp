import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trashhub/backend/backend.dart';
import 'package:trashhub/data/models/recyclehubmodel.dart';
import 'package:trashhub/recyclex/recentercard.dart';

class RecycleHub extends StatefulWidget {
  const RecycleHub({super.key});

  @override
  State<RecycleHub> createState() => _RecycleHubState();
}

class _RecycleHubState extends State<RecycleHub> {
  final carouselimages = [
    Image.asset(
      'assets/RecycleHub1.png',
    ),
    Image.asset(
      'assets/RecycleHub2.png',
    ),
    Image.asset(
      'assets/RecycleHub3.png',
    ),
    Image.asset(
      'assets/RecycleHub4.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  List<ReCycleHubJob> jobs = [];

  initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('loggedin_username') ?? '';
    final uid = await TrashHubBackend().getUserID(username: username);
    if (uid.result == null) {
      Toast.show('Could not find UserID');
      return;
    }
    final res = await TrashHubBackend().getAllMyJobs(uid.result!);
    if (res.result == null) {
      Toast.show('Could not get Jobs');
      return;
    }
    jobs = [...res.result!];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 241, 244),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const SizedBox(
              height: 20,
            ),
            // ElevatedButton(onPressed: () {}, child: Text('My Jobs')),
            if (jobs.isNotEmpty) ...[
              Text(
                'My Jobs',
                style: GoogleFonts.aBeeZee(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...jobs
                  .map(
                    (j) => j.status == 'completed'
                        ? const SizedBox()
                        : ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            title: Text('${j.partnerName} (${j.partnerType})'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(j.name),
                                Text(j.date),
                              ],
                            ),
                            tileColor: Colors.greenAccent.withAlpha(50),
                            trailing: Chip(
                              label: Text(j.status),
                              backgroundColor: j.status == 'pending'
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                          ),
                  )
                  .toList(),
              const SizedBox(
                height: 20,
              ),
            ],
            Text(
              'ReCycleHub Partners',
              style: GoogleFonts.aBeeZee(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            RecycleCentreCard(
              onJobBookedCallback: () async {
                await initialize();
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
            ),
            // Text(
            //   'Types',
            //   style:
            //       GoogleFonts.aBeeZee(fontSize: 15, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
