import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:trashhub/data/models/recyclehubmodel.dart';

class ResponseType<T> {
  T result;
  String message;

  ResponseType({
    required this.result,
    required this.message,
  });
}

Future<String> getServerLink() async {
  final prefs = await SharedPreferences.getInstance();
  return 'https://trash-hub-backend-git-main-synapsecode.vercel.app';
}

Future<void> setServerLink(String link) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('server_root_link', link);
}

class TrashHubBackend {
  Future<ResponseType<bool>> register(
      {required String name,
      required String username,
      required String password}) async {
    final root = await getServerLink();
    final uri = Uri.parse("$root/user/register");
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {'name': name, 'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      return ResponseType(result: true, message: 'success');
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: true, message: res.body.toString());
  }

  Future<ResponseType<bool>> login(
      {required String username, required String password}) async {
    final root = await getServerLink();
    final uri = Uri.parse("$root/user/login");
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {'username': username, 'password': password},
      ),
    );
    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      final succ = resdata['success'] ?? false;
      if (succ) {
        return ResponseType(result: true, message: 'success');
      } else {
        print("ERROR ===> ${resdata['message']}");
        return ResponseType(result: false, message: resdata['message']);
      }
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: false, message: res.body);
  }

  Future<ResponseType<int?>> getIDFromUsername(String uname) async {
    final root = await getServerLink();
    final uri = Uri.parse("$root/user/get_id_by_username/$uname");
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      return ResponseType(
        result: resdata['id'],
        message: 'success',
      );
    }
    return ResponseType(
      result: null,
      message: 'Server Side Error (${res.statusCode})',
    );
  }

  Future<ResponseType<int?>> getUserID({required String username}) async {
    final root = await getServerLink();
    final uri = Uri.parse("$root/user/get_id_by_username/$username");
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final resbody = jsonDecode(res.body);
      final id = int.parse(resbody['id'].toString());
      return ResponseType(result: id, message: 'success');
    }
    return ResponseType(result: null, message: res.body);
  }

  Future<ResponseType<double?>> getUserPoints({required int userID}) async {
    final root = await getServerLink();
    final uri = Uri.parse("$root/user/get_user_points/$userID");
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final resbody = jsonDecode(res.body);
      final id = double.parse(resbody['points'].toString());
      return ResponseType(result: id, message: 'success');
    }
    return ResponseType(result: null, message: res.body);
  }

  Future<ResponseType<List<Map>?>> getRCHPartners(
      {String filter = 'all'}) async {
    final root = await getServerLink();

    List<Map> partners = [];
    final uri = Uri.parse("$root/recyclehub/getpartners/$filter");
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      for (final x in resdata) {
        partners.add(x);
      }
    } else {
      return ResponseType(
        result: null,
        message: 'Server Side Error (${res.statusCode}) => ${res.body}',
      );
    }
    return ResponseType(result: partners, message: 'success');
  }

  Future<ResponseType<List<ReCycleHubJob>?>> getAllMyJobs(int userId) async {
    final root = await getServerLink();

    List<ReCycleHubJob> jobs = [];
    final uri = Uri.parse("$root/recyclehub/myjobs/$userId");
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      for (final x in resdata) {
        final rcxj = ReCycleHubJob.fromMap(x);
        jobs.add(rcxj);
      }
    } else {
      return ResponseType(
        result: null,
        message: 'Server Side Error (${res.statusCode}) => ${res.body}',
      );
    }
    return ResponseType(result: jobs, message: 'success');
  }

  Future<ResponseType<int?>> requestJob({
    required String name,
    required String status,
    required LatLng loc,
    required int userId,
    required int partnerId,
  }) async {
    final root = await getServerLink();
    final uri = Uri.parse("$root/recyclehub/book_job");
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'name': name,
          'status': status,
          'destination': {
            'lat': loc.latitude,
            'lng': loc.longitude,
          },
          'user_id': userId,
          'partner_id': partnerId
        },
      ),
    );
    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      final succ = resdata['success'] ?? false;
      if (succ) {
        return ResponseType(result: resdata['id'], message: 'success');
      } else {
        print("ERROR ===> ${resdata['message']}");
        return ResponseType(result: null, message: resdata['message']);
      }
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: null, message: res.body);
  }

  // =================== EcoPerks ====================

  Future<ResponseType<bool>> add2dustbin({
    required int userId,
    required String qrCodeValue,
  }) async {
    final root = await getServerLink();
    final uri = Uri.parse("$root/ecoperks/userscan");
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {'uid': userId, 'qrcode': qrCodeValue},
      ),
    );
    if (res.statusCode == 200) {
      return ResponseType(result: true, message: res.body);
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: false, message: res.body);
  }
}
