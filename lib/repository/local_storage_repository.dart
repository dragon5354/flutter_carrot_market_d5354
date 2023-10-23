import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/**
 * 좋아요 눌렀는지를 관리(원래 API 등을 쓰겠지만, 로컬 스토리지로 구현해봄)
 */
class LocalStorageRepository {
  final _storage = FlutterSecureStorage();

  // 저장한 위치에 대한 키값을 통해서 데이터를 받아옴 (Get에 해당)
  Future<String?> getStoredValue(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      return null;
    }
  }

  // 저장
  Future<void> storeValue(String key, String value) async {
    try {
      await _storage.write(key: key, value: value.toString());
    } catch (error) {
      return null;
    }
  }
}