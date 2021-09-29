import 'package:get_it/get_it.dart';

import 'repository/user_repository.dart';
import 'services/fake_auth_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/firebase_storage_sevice.dart';
import 'services/firestore_db_service.dart';

GetIt locator = GetIt.asNewInstance();

void setUpLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FireBaseStorageService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
}
