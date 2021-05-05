import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:password_manager_r1/models/hash_length.dart';
import 'package:password_manager_r1/models/password_data.dart';
import 'package:password_manager_r1/models/user.dart';
import 'package:password_manager_r1/services/encryption.dart';
import 'package:password_manager_r1/services/flask_rest_api.dart';

class PasswordDataProvider extends ChangeNotifier {
  List<PasswordData> passwordDataList = [];

  List<PasswordData> passwordDataListFiltered(String value) => passwordDataList
      .where((e) => e.title.toLowerCase().contains(value.toLowerCase()))
      .toList();

  PasswordData _current;
  PasswordData get current => _current;
  set current(PasswordData value) {
    _current = value;
    notifyListeners();
  }

  void fetchPasswordData(User user) async {
    // Testing:
    // passwordDataList = List.generate(
    //   10,
    //   (index) => PasswordData(
    //     id: 'id $index',
    //     title: 'title $index',
    //     salt: 'salt $index',
    //     count: 16,
    //     length: HashLength.fromInt(16),
    //     created: DateTime.now(),
    //     lastUsed: DateTime.now(),
    //   ),
    // );
    var json = await FlaskRestApi.readPasswordData(user.key);
    passwordDataList = List.generate(json.length,
        (index) => PasswordData.fromJson(json['$index']['$index']));
    notifyListeners();
  }

  Future<void> add(
      {@required User user,
      @required String title,
      @required String salt,
      @required int count,
      @required int length}) async {
    PasswordData passwordData = PasswordData(
        title: title,
        salt: salt ?? Encryption.defaultSaltGen(),
        count: count ?? Encryption.DEFAULT_COUNT,
        length: HashLength.fromInt(length),
        created: DateTime.now(),
        lastUsed: DateTime.now());

    // Post to server & Update local id of passwordData to response id
    passwordData.id = await FlaskRestApi.createPasswordData(
      user.key,
      passwordData.toJson(noId: true),
    );

    passwordDataList.add(passwordData);
    current = passwordData;
    notifyListeners();
  }

  void remove({@required User user, @required PasswordData passwordData}) {
    // Delete on server
    FlaskRestApi.deletePasswordData(user.key, passwordData.id).then((value) {
      // Delete in state
      passwordDataList.remove(passwordData);
      notifyListeners();
    });
  }

  void update({@required User user, @required PasswordData passwordData}) {
    passwordData.salt = passwordData.salt ?? Encryption.defaultSaltGen();
    passwordData.count = passwordData.count ?? Encryption.DEFAULT_COUNT;
    print('Fisk');

    // Update on server
    FlaskRestApi.updatePasswordData(
      user.key,
      passwordData.id,
      passwordData.toJson(),
    ).then((value) {
      // Update in state
      passwordDataList.remove(passwordData);
      passwordDataList.add(passwordData);
    });

    current = passwordData;
    notifyListeners();
  }

  void generatePassword(
      {String masterPassword,
      PasswordData passwordData,
      bool copyToClipboard = true}) {
    Clipboard.setData(ClipboardData(
        text: Encryption.encryptSHA3FromData(masterPassword, passwordData)));
  }

  void trigger() => notifyListeners();
}
