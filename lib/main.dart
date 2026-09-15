import 'package:arena/config/bloc_providers.dart';
import 'package:arena/config/routes/app_router.dart';
import 'package:arena/config/theme/app_themes.dart';
import 'package:arena/models/notification/notification_banner_model.dart';
import 'package:arena/pages/notification/bloc/notification_bloc.dart';
import 'package:arena/pages/notification/bloc/notification_state.dart';
import 'package:arena/utils/notification_banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  await initializeDateFormatting(Intl.systemLocale);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: BlocListener<NotificationBloc, NotificationState>(
        listenWhen: (previous, current) =>
            current.latestNotification != null &&
            current.latestNotification != previous.latestNotification,
        listener: (context, state) {
          final item = state.latestNotification!;
          NotificationBannerController.instance.show(
            NotificationBannerModel.fromNotification(
              title: item.title,
              message: item.body,
              onTap: () {},
            ),
          );
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          themeMode: ThemeMode.light,
          title: 'Arena Ban',
          routerConfig: AppRouter.router,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            final clampedTextScaler = mediaQuery.textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.3,
            );

            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: clampedTextScaler),
              child: Overlay(
                key: NotificationBannerController.instance.overlayKey,
                initialEntries: [
                  OverlayEntry(
                    builder: (_) => child ?? const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
