 

part of 'di_container.dart';

class Di {
  const Di._();

  static final sl = GetIt.instance;

  static Future<void> init() async {

    final sp = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sp);

    /// CORE
    ///

    sl
          ..registerLazySingleton<Dio>(() => Dio())
          ..registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor())
          ..registerLazySingleton<DioClient>(() => DioClient(Apis.url, dio: sl(), loggingInterceptor: sl()))
          ..registerLazySingleton<NetworkService>(() => NetworkService()..startConnectionStreaming())
        // ..registerLazySingleton<FirebaseClient>(() => FirebaseClient())
        //
        ;

    /// REPOS
    ///
    sl
      ..registerLazySingleton<HomeRepo>(() => HomeRepoImpl(dioClient: sl(), local: sl()))
        //
        ;


    /// BLOCS
    sl
        ..registerFactory(() => HomeBloc(sl(), sl()))
      // add other blocs....
    ;

    sl.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSource(sl()));

    sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService(sl()));
  }
  /// ───────────────── BLOC PROVIDERS ─────────────────
  static List<SingleChildWidget> get blocProviders => [
    BlocProvider<HomeBloc>(
      create: (_) => sl<HomeBloc>()..add(LoadHomeData()),
    ),
  ];
}
