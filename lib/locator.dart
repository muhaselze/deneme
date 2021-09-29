import 'package:deneme/repository/user_repository.dart';
import 'package:deneme/services/firebase_storage_sevice.dart';
import 'package:deneme/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

import 'services/fake_auth_service.dart';
import 'services/firebase_auth_service.dart';

GetIt locator = GetIt.asNewInstance();

void setUpLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FireBaseStorageService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
}
