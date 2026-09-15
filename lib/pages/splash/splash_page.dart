import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/splash/bloc/splash_bloc.dart';
import 'package:arena/pages/splash/bloc/splash_event.dart';
import 'package:arena/pages/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashLoaded) {
          switch (state.role) {
            case Role.owner:
              context.go(AppRoutes.navOwnerPage);
              break;
            case Role.warehouseStaff:
              context.go(AppRoutes.navWarehousePage);
              break;
            case Role.cashier:
              context.go(AppRoutes.navCashierPage);
              break;
            case Role.customerServices:
              context.go(AppRoutes.navCsPage);
              break;
            case Role.developer:
              context.go(AppRoutes.navOwnerPage);
              break;
            case Role.unknown:
              context.go(AppRoutes.login);
              break;
          }
        } else if (state is SplashFailure) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SvgPicture.asset(
            isDark ? CustomIcons.logoTextDark : CustomIcons.logoTextLight,
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
