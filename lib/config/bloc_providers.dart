import 'package:arena/pages/auth/login/bloc/login_bloc.dart';
import 'package:arena/pages/auth/register/bloc/register_bloc.dart';
import 'package:arena/pages/cart/bloc/cart_event.dart';
import 'package:arena/pages/inbox/bloc/inbox_event.dart';
import 'package:arena/pages/navigation/bloc/nav_bloc.dart';
import 'package:arena/pages/inbox/bloc/inbox_bloc.dart';
import 'package:arena/pages/notification/bloc/notification_bloc.dart';
import 'package:arena/pages/notification/bloc/notification_event.dart';
import 'package:arena/pages/notification/bloc/notification_settings_bloc.dart';
import 'package:arena/pages/notification/bloc/notification_settings_event.dart';
import 'package:arena/pages/order_list/bloc/order_event.dart';
import 'package:arena/pages/profile/bloc/profile_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_event.dart';
import 'package:arena/pages/stock_list/bloc/stock_bloc.dart';
import 'package:arena/pages/order_list/bloc/order_bloc.dart';
import 'package:arena/pages/cart/bloc/cart_bloc.dart';
import 'package:arena/pages/stock_list/bloc/stock_event.dart';
import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:arena/repositories/cart/cart_repository.dart';
import 'package:arena/repositories/notification/notification_repository.dart';
import 'package:arena/repositories/order/order_repository.dart';
import 'package:arena/repositories/stock/stock_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviders {
  static final providers = [
    BlocProvider<NotificationBloc>(
      create: (context) =>
          NotificationBloc(notificationRepository: NotificationRepository())
            ..add(ConnectUnreadCount()),
    ),
    BlocProvider<NotificationSettingsBloc>(
      create: (context) =>
          NotificationSettingsBloc(repository: NotificationRepository())
            ..add(LoadNotificationSettings()),
    ),
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(authRepository: AuthRepository()),
    ),
    BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(authRepository: AuthRepository()),
    ),
    BlocProvider<NavBloc>(create: (context) => NavBloc()),
    BlocProvider<InboxBloc>(create: (context) => InboxBloc()..add(LoadInbox())),
    BlocProvider<StockBloc>(
      create: (context) =>
          StockBloc(repository: StockRepository())..add(LoadStock()),
    ),
    BlocProvider<ProfileBloc>(
      create: (context) =>
          ProfileBloc(authRepository: AuthRepository())..add(LoadProfile()),
    ),
    BlocProvider<OrderBloc>(
      create: (context) =>
          OrderBloc(repository: OrderRepository())..add(LoadOrders()),
    ),
    BlocProvider<CartBloc>(
      create: (context) =>
          CartBloc(repository: CartRepository())..add(LoadCart()),
    ),
  ];
}
