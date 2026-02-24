import 'package:cake_it_app/src/app_router.dart';
import 'package:cake_it_app/src/data/cake_repository.dart';
import 'package:cake_it_app/src/features/cake_list/bloc/cake_list_bloc.dart';
import 'package:cake_it_app/src/localization/app_localizations.dart';
import 'package:cake_it_app/src/settings/settings_cubit.dart';
import 'package:cake_it_app/src/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.cakeRepository,
  });

  final CakeRepository cakeRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CakeListBloc(cakeRepository: cakeRepository)
            ..add(const CakeListFetched()),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(SettingsService())..loadSettings(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            routerConfig: AppRouter.router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.deepPurple,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.deepPurple,
            ),
            themeMode: themeMode,
          );
        },
      ),
    );
  }
}
