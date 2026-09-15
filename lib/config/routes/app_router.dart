import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/routes/app_name_route.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/order/add_order_model.dart';
import 'package:arena/models/tire_model.dart';
import 'package:arena/models/dot_model.dart';
import 'package:arena/models/user/user_list_model.dart';
import 'package:arena/pages/checkout_cart/checkout_cart_page.dart';
import 'package:arena/pages/checkout_cart/checkout_cart_preview_page.dart';
import 'package:arena/pages/add_stock/add_stock_page.dart';
import 'package:arena/pages/add_stock/add_stock_form_page.dart';
import 'package:arena/pages/add_stock/add_dot_page.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_bloc.dart';
import 'package:arena/pages/add_stock/stock_preview_page.dart';
import 'package:arena/pages/add_stock/edit_stock_page.dart';
import 'package:arena/pages/add_user/bloc/add_user_bloc.dart';
import 'package:arena/pages/auth/register/code_registration_page.dart';
import 'package:arena/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:arena/pages/auth/forgot_password/forgot_password_email_page.dart';
import 'package:arena/pages/auth/forgot_password/forgot_password_reset_page.dart';
import 'package:arena/pages/auth/forgot_password/forgot_password_verification_page.dart';
import 'package:arena/pages/auth/login/login_page.dart';
import 'package:arena/pages/auth/register/bloc/register_state.dart';
import 'package:arena/pages/auth/register/register_page.dart';
import 'package:arena/pages/brand/bloc/brand_event.dart';
import 'package:arena/pages/customer/bloc/customer_bloc.dart';
import 'package:arena/pages/customer/bloc/customer_event.dart';
import 'package:arena/pages/customer/customer_list_page.dart';
import 'package:arena/pages/customer_detail/customer_detail_page.dart';
import 'package:arena/pages/dashboard/owner/dashboard_page.dart';
import 'package:arena/pages/dashboard/owner/bloc/dashboard_bloc.dart';
import 'package:arena/pages/dashboard/owner/bloc/dashboard_event.dart';
import 'package:arena/pages/payment/bloc/payment_bloc.dart';
import 'package:arena/pages/payment/bloc/payment_timer_bloc.dart';
import 'package:arena/pages/payment/payment_cash_page.dart';
import 'package:arena/pages/payment/payment_cash_change_page.dart';
import 'package:arena/pages/payment/payment_online_page.dart';
import 'package:arena/pages/payment/payment_receipt_page.dart';
import 'package:arena/repositories/dashboard/dashboard_repository.dart';
import 'package:arena/pages/dashboard/warehouse_staff/dashboard_warehouse_page.dart';
import 'package:arena/pages/dashboard/warehouse_staff/bloc/warehouse_dashboard_bloc.dart';
import 'package:arena/pages/dashboard/warehouse_staff/bloc/warehouse_dashboard_event.dart';
import 'package:arena/pages/history/history_page.dart';
import 'package:arena/pages/history/bloc/history_bloc.dart';
import 'package:arena/pages/history/bloc/history_event.dart';
import 'package:arena/pages/inbox/inbox_page.dart';
import 'package:arena/pages/cart/cart_page.dart';
import 'package:arena/pages/navigation/nav_page.dart';
import 'package:arena/pages/order_detail/cashier_order_detail_page.dart';
import 'package:arena/pages/order_detail/cs_order_detail_page.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_bloc.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_event.dart';
import 'package:arena/pages/order_detail/warehouse_order_detail_page.dart';
import 'package:arena/pages/order_list/cashier/cashier_order_list.dart';
import 'package:arena/pages/order_list/customer_services/cs_order_list_page.dart';
import 'package:arena/pages/order_list/warehouse_staff/warehouse_order_list_page.dart';
import 'package:arena/pages/product/bloc/product_list_bloc.dart';
import 'package:arena/pages/product/product_list_page.dart';
import 'package:arena/pages/profile/profile_page.dart';
import 'package:arena/pages/profile/change_password/bloc/change_password_bloc.dart';
import 'package:arena/pages/profile/change_password/change_password_page.dart';
import 'package:arena/pages/profile/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:arena/pages/profile/edit_profile/edit_profile_page.dart';
import 'package:arena/pages/profile/settings/notification_settings_page.dart';
import 'package:arena/pages/profile/settings/stock_inventory_page.dart';
import 'package:arena/pages/report/bloc/report_bloc.dart';
import 'package:arena/pages/report/report_page.dart';
import 'package:arena/pages/splash/bloc/splash_bloc.dart';
import 'package:arena/pages/splash/splash_page.dart';
import 'package:arena/pages/stock_detail/stock_detail_page.dart';
import 'package:arena/pages/stock_list/stock_list_page.dart';
import 'package:arena/pages/add_user/add_user_page.dart';
import 'package:arena/pages/user_list/bloc/user_bloc.dart';
import 'package:arena/pages/user_list/bloc/user_event.dart';
import 'package:arena/pages/add_user/invite_send_page.dart';
import 'package:arena/pages/user_list/user_list_page.dart';
import 'package:arena/pages/user_detail/user_detail_page.dart';
import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:arena/repositories/customer/customer_repository.dart';
import 'package:arena/repositories/product/product_repository.dart';
import 'package:arena/repositories/stock/stock_repository.dart';
import 'package:arena/repositories/user/user_repository.dart';
import 'package:arena/repositories/brand/brand_repository.dart';
import 'package:arena/repositories/report/report_repository.dart';
import 'package:arena/pages/brand/bloc/brand_bloc.dart';
import 'package:arena/pages/brand/brand_list_page.dart';
import 'package:arena/usecases/stock/filter_history_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/config/routes/nav_routes.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/services/auth/user_session.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static CustomTransitionPage _slideTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 200),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
    );
  }

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final path = state.uri.path;

      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.codeRegistration,
        AppRoutes.forgotPasswordEmail,
        AppRoutes.forgotPasswordVerification,
        AppRoutes.forgotPasswordReset,
      ];
      if (publicRoutes.any((r) => path.startsWith(r))) return null;

      final role = await UserSession.getOrFetchRole();

      if (role == Role.unknown) return AppRoutes.login;

      if (path.startsWith('/owner') &&
          role != Role.owner &&
          role != Role.developer) {
        return NavRoutes.getHomeRoute(role);
      }
      if (path.startsWith('/warehouse') && role != Role.warehouseStaff) {
        return NavRoutes.getHomeRoute(role);
      }
      if (path.startsWith('/cs') && role != Role.customerServices) {
        return NavRoutes.getHomeRoute(role);
      }
      if (path.startsWith('/cashier') && role != Role.cashier) {
        return NavRoutes.getHomeRoute(role);
      }

      if ((path.startsWith('/add-user') || path.startsWith('/invite-send')) &&
          role != Role.owner &&
          role != Role.developer) {
        return NavRoutes.getHomeRoute(role);
      }

      final stockWritePaths = [
        '/add-stock',
        '/add-stock-form',
        '/add-dot',
        '/stock-preview',
        '/edit-stock',
        '/settings/stock-inventory',
      ];
      if (stockWritePaths.any((p) => path.startsWith(p)) &&
          role != Role.warehouseStaff &&
          role != Role.owner &&
          role != Role.developer) {
        return NavRoutes.getHomeRoute(role);
      }

      final checkoutPaths = ['/cart-list', '/checkout-cart'];
      if (checkoutPaths.any((p) => path.startsWith(p)) &&
          role != Role.customerServices &&
          role != Role.cashier &&
          role != Role.owner &&
          role != Role.developer) {
        return NavRoutes.getHomeRoute(role);
      }

      final customerPaths = [
        '/customer-list',
        '/customer-list-detail',
        '/customer-detail',
      ];
      if (customerPaths.any((p) => path.startsWith(p)) &&
          role != Role.customerServices &&
          role != Role.cashier &&
          role != Role.owner &&
          role != Role.developer) {
        return NavRoutes.getHomeRoute(role);
      }

      return null;
    },
    routes: [
      // SPLASH
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => SplashBloc(),
          child: const SplashPage(),
        ),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),

      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.codeRegistration,
        builder: (context, state) {
          final data = state.extra as RegisterFormData;
          return CodeRegistrationPage(name: data.name, password: data.password);
        },
      ),

      // FORGOT PASSWORD
      ShellRoute(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: BlocProvider(
              create: (_) => ForgotPasswordBloc(repository: AuthRepository()),
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.forgotPasswordEmail,
            builder: (_, __) => const ForgotPasswordEmailPage(),
          ),
          GoRoute(
            path: AppRoutes.forgotPasswordVerification,
            builder: (_, __) => const ForgotPasswordVerificationPage(),
          ),
          GoRoute(
            path: AppRoutes.forgotPasswordReset,
            builder: (context, state) {
              final code = state.extra as String;
              return ForgotPasswordResetPage(code: code);
            },
          ),
        ],
      ),

      // CHANGE PASSWORD
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) {
          final email = state.extra as String;
          return BlocProvider(
            create: (_) =>
                ChangePasswordBloc(repository: AuthRepository(), email: email),
            child: const ChangePasswordPage(),
          );
        },
      ),

      /// OWNER
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      HistoryBloc(repository: StockRepository()),
                ),
              ],
              child: NavPage(role: Role.owner, child: child),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboardOwner,
                builder: (_, __) => BlocProvider(
                  create: (_) =>
                      DashboardBloc(repository: DashboardRepository())
                        ..add(const LoadDashboard()),
                  child: const DashboardPage(),
                ),
              ),

              GoRoute(
                path: AppRoutes.userListOwner,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      UserBloc(repository: UserRepository())
                        ..add(LoadUserList()),
                  child: const UserListPage(),
                ),
              ),

              GoRoute(
                name: AppNameRoute.userDetail,
                path: AppRoutes.userDetailOwner,
                builder: (context, state) {
                  final user = state.extra as UserListDatum;
                  return UserDetailPage(user: user);
                },
              ),

              GoRoute(
                path: AppRoutes.customerList,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      CustomerBloc(repository: CustomerRepository())
                        ..add(LoadCustomer()),
                  child: const CustomerListPage(),
                ),
              ),

              GoRoute(
                path: AppRoutes.historyOwner,
                builder: (context, state) => BlocProvider(
                  create: (context) => HistoryBloc(
                    repository: StockRepository(),
                    filterHistoryUseCase: FilterHistoryUseCase(),
                  )..add(LoadHistory()),
                  child: const HistoryPage(),
                ),
              ),

              GoRoute(
                path: AppRoutes.stockListOwner,
                builder: (_, __) => const StockListPage(filterBan: null),
              ),
              GoRoute(
                name: AppNameRoute.stockListByBrandOwner,
                path: AppRoutes.stockListByBrandOwner,
                builder: (_, state) {
                  final brandName = state.pathParameters['brandName'];
                  return StockListPage(filterBan: brandName);
                },
              ),
              GoRoute(
                path: AppRoutes.inboxOwner,
                builder: (_, __) => const InboxPage(),
              ),

              GoRoute(
                path: AppRoutes.reportOwner,
                builder: (_, __) => BlocProvider(
                  create: (_) => ReportBloc(repository: ReportRepository()),
                  child: const ReportPage(role: Role.owner),
                ),
              ),
              GoRoute(
                path: AppRoutes.productListOwner,
                builder: (_, __) => BlocProvider(
                  create: (context) =>
                      ProductListBloc(repository: ProductRepository()),
                  child: const ProductListPage(),
                ),
              ),
              GoRoute(
                path: AppRoutes.brandListOwner,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      BrandBloc(repository: BrandRepository())
                        ..add(const LoadBrands()),
                  child: const BrandListPage(),
                ),
              ),
            ],
          ),
        ],
      ),

      /// CUSTOMER SERVICE
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: NavPage(role: Role.customerServices, child: child),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orderListCs,
                builder: (_, __) => const CsOrderListPage(),
              ),
              GoRoute(
                name: AppNameRoute.orderDetailCs,
                path: AppRoutes.orderDetailCs,
                builder: (_, state) {
                  final orderId = state.pathParameters['id']!;
                  return CsOrderDetailPage(orderId: orderId);
                },
              ),
              GoRoute(
                path: AppRoutes.stockListCs,
                builder: (_, __) => const StockListPage(filterBan: null),
              ),
              GoRoute(
                name: AppNameRoute.stockListByBrandCs,
                path: AppRoutes.stockListByBrandCs,
                builder: (_, state) {
                  final brandName = state.pathParameters['brandName'];
                  return StockListPage(filterBan: brandName);
                },
              ),
              GoRoute(
                path: AppRoutes.inboxCs,
                builder: (_, __) => const InboxPage(),
              ),
            ],
          ),
        ],
      ),

      /// CASHIER
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: NavPage(role: Role.cashier, child: child),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orderListCashier,
                builder: (_, __) => const CashierOrderList(),
              ),
              GoRoute(
                name: AppNameRoute.orderDetailCashier,
                path: AppRoutes.orderDetailCashier,
                builder: (context, state) {
                  final orderId = state.pathParameters['id']!;
                  return CashierOrderDetailPage(orderId: orderId);
                },
              ),
              GoRoute(
                path: AppRoutes.stockListCashier,
                builder: (_, __) => const StockListPage(filterBan: null),
              ),
              GoRoute(
                name: AppNameRoute.stockListByBrandCashier,
                path: AppRoutes.stockListByBrandCashier,
                builder: (_, state) {
                  final brandName = state.pathParameters['brandName'];
                  return StockListPage(filterBan: brandName);
                },
              ),
              GoRoute(
                path: AppRoutes.inboxCashier,
                builder: (_, __) => const InboxPage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(path: AppRoutes.cartList, builder: (_, _) => const CartPage()),

      /// WAREHOUSE
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      HistoryBloc(repository: StockRepository()),
                ),
              ],
              child: NavPage(role: Role.warehouseStaff, child: child),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboardWarehouse,
                builder: (_, __) => BlocProvider(
                  create: (_) =>
                      WarehouseDashboardBloc(repository: DashboardRepository())
                        ..add(const LoadWarehouseDashboard()),
                  child: const DashboardWarehousePage(),
                ),
              ),
              GoRoute(
                path: AppRoutes.orderListWarehouse,
                builder: (_, __) => const WarehouseOrderListPage(),
              ),
              GoRoute(
                name: AppNameRoute.orderDetailWarehouse,
                path: AppRoutes.orderDetailWarehouse,
                builder: (_, state) {
                  final orderId = state.pathParameters['id']!;
                  return WarehouseOrderDetailPage(
                    orderId: orderId,
                    invoiceNumber: '',
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.stockListWarehouse,
                builder: (_, __) => const StockListPage(),
              ),
              GoRoute(
                name: AppNameRoute.stockListByBrandWarehouse,
                path: AppRoutes.stockListByBrandWarehouse,
                builder: (_, state) {
                  final brandName = state.pathParameters['brandName'];
                  return StockListPage(filterBan: brandName);
                },
              ),
              GoRoute(
                path: AppRoutes.inboxWarehouse,
                builder: (_, __) => const InboxPage(),
              ),
              GoRoute(
                path: AppRoutes.historyWarehouse,
                builder: (context, state) => BlocProvider(
                  create: (context) => HistoryBloc(
                    repository: StockRepository(),
                    filterHistoryUseCase: FilterHistoryUseCase(),
                  )..add(LoadHistory()),
                  child: const HistoryPage(),
                ),
              ),
              GoRoute(
                path: AppRoutes.reportWarehouse,
                builder: (_, __) => BlocProvider(
                  create: (_) => ReportBloc(repository: ReportRepository()),
                  child: const ReportPage(role: Role.warehouseStaff),
                ),
              ),
              GoRoute(
                path: AppRoutes.productListWarehouse,
                builder: (_, __) => BlocProvider(
                  create: (context) =>
                      ProductListBloc(repository: ProductRepository()),
                  child: const ProductListPage(),
                ),
              ),
              GoRoute(
                path: AppRoutes.brandListWarehouse,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      BrandBloc(repository: BrandRepository())
                        ..add(const LoadBrands()),
                  child: const BrandListPage(),
                ),
              ),
            ],
          ),
        ],
      ),

      /// UNIVERSAL
      GoRoute(
        name: AppNameRoute.stockDetail,
        path: AppRoutes.stockDetail,
        builder: (_, state) {
          final productId = state.pathParameters['id']!;
          return StockDetailPage(productId: productId);
        },
      ),

      ShellRoute(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: BlocProvider(
              create: (_) => AddStockBloc(
                productRepository: ProductRepository(),
                stockRepository: StockRepository(),
              ),
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.addStock,
            builder: (context, state) {
              final tire = state.extra is TireModel
                  ? state.extra as TireModel
                  : null;

              return AddStockPage(
                tire:
                    tire ??
                    TireModel(
                      id: null,
                      nama: '',
                      ukuran: '',
                      ring: '',
                      catatan: '',
                    ),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.addStockForm,
            builder: (context, state) {
              if (state.extra is Map<String, dynamic>) {
                final extra = state.extra as Map<String, dynamic>;
                final tire =
                    extra['tire'] as TireModel? ??
                    TireModel(
                      id: null,
                      nama: '',
                      ukuran: '',
                      ring: '',
                      catatan: '',
                    );
                final existingData =
                    extra['existingData'] as Map<String, dynamic>?;

                return AddStockFormPage(tire: tire, existingData: existingData);
              }

              final tire = state.extra is TireModel
                  ? state.extra as TireModel
                  : TireModel(
                      id: null,
                      nama: '',
                      ukuran: '',
                      ring: '',
                      catatan: '',
                    );

              return AddStockFormPage(tire: tire);
            },
          ),
          GoRoute(
            path: AppRoutes.addDot,
            builder: (_, __) => const AddDotPage(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.stockPreview,
        builder: (_, state) {
          final extra = state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : null;

          return StockPreviewPage(
            dots: extra?['dots'] as List<DotModel>? ?? [],
            nama: extra?['nama'] ?? '',
            ukuran: extra?['ukuran'] ?? '',
            ring: extra?['ring'] ?? '',
            catatan: extra?['catatan'],
          );
        },
      ),

      GoRoute(
        path: AppRoutes.editStock,
        builder: (_, state) {
          if (state.extra is! List<DotModel>) {
            return const Scaffold(
              body: Center(child: CustomText(text: "Data DOT Tidak Valid")),
            );
          }
          return EditStockPage(dots: state.extra as List<DotModel>);
        },
      ),

      GoRoute(
        path: AppRoutes.checkoutCart,
        builder: (_, state) => const CheckoutCartPage(),
      ),

      GoRoute(
        path: AppRoutes.checkoutPreview,
        builder: (_, state) {
          if (state.extra is! Map<String, dynamic>) {
            return const Scaffold(
              body: Center(child: CustomText(text: "Data Order Tidak Valid")),
            );
          }

          final extra = state.extra as Map<String, dynamic>;

          return CheckoutCartPreviewPage(
            nama: extra["nama"] as String? ?? '',
            hp: extra["hp"] as String? ?? '',
            kendaraan: extra["kendaraan"] as String? ?? '',
            plat: extra["plat"] as String? ?? '',
          );
        },
      ),

      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const ProfilePage()),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) {
          final name = state.extra as String? ?? "";
          return BlocProvider(
            create: (_) =>
                EditProfileBloc(repository: AuthRepository(), name: name),
            child: const EditProfilePage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (_, __) => const NotificationSettingsPage(),
      ),

      GoRoute(
        path: AppRoutes.stockInventorySettings,
        builder: (_, __) => const StockInventoryPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (context) => AddUserBloc(repository: UserRepository()),
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.addUser,
            builder: (context, state) => const AddUserPage(),
          ),
          GoRoute(
            path: AppRoutes.inviteSend,
            builder: (_, state) {
              if (state.extra is! Map) {
                return const Scaffold(
                  body: Center(
                    child: CustomText(text: "Data User Tidak Valid"),
                  ),
                );
              }

              final extra = state.extra as Map<String, dynamic>;
              final email = extra['email']?.toString() ?? '';
              final role = extra['role']?.toString() ?? '';
              return InviteSendPage(email: email, role: role);
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.customerDetail,
        builder: (_, state) {
          if (state.extra is! AddOrderModel) {
            return const Scaffold(
              body: Center(
                child: CustomText(text: "Data Customer Tidak Valid"),
              ),
            );
          }

          return CustomerDetailPage(order: state.extra as AddOrderModel);
        },
      ),

      GoRoute(
        path: AppRoutes.paymentCash,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (_) => PaymentBloc(),
            child: PaymentCashPage(
              orderId: extra['orderId'] as String,
              totalInvoice: extra['totalInvoice'] as int,
              invoiceId: extra['invoiceId'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.paymentCashChange,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          final orderId = extra['orderId'] as String;
          return BlocProvider(
            create: (_) =>
                OrderDetailBloc()..add(OrderDetailFetched(orderId: orderId)),
            child: PaymentCashChangePage(
              orderId: orderId,
              totalInvoice: extra['totalInvoice'] as int,
              cashReceived: (extra['cashReceived'] as num).toDouble(),
              change: (extra['change'] as num).toDouble(),
              invoiceId: extra['invoiceId'] as String,
            ),
          );
        },
      ),
      GoRoute(
        name: AppNameRoute.paymentOnline,
        path: AppRoutes.paymentOnline,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PaymentTimerBloc()),
              BlocProvider(create: (_) => PaymentBloc()),
            ],
            child: PaymentOnlinePage(
              orderId: extra['orderId'] as String,
              paymentType: extra['paymentType'] as PaymentMethod,
              totalAmount: extra['totalAmount'] as num,
              invoiceId: extra['invoiceId'] as String,
              customerName: extra['customerName'] as String?,
              vehicleModel: extra['vehicleModel'] as String?,
              vehiclePlate: extra['vehiclePlate'] as String?,
              paidAt: extra['paidAt'] as String?,
              bankCode: extra['bankCode'] as String?,
              hideName: extra['hideName'] as bool? ?? false,
              hideDoneButton: extra['hideDoneButton'] as bool? ?? true,
            ),
          );
        },
      ),
      GoRoute(
        name: AppNameRoute.paymentReceipt,
        path: AppRoutes.paymentReceipt,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final isSuccess = extra['isSuccess'] as bool? ?? true;
          final retryable = extra['retryable'] as bool? ?? false;
          final retryPaymentType = extra['retryPaymentType'] as PaymentMethod?;

          VoidCallback? onRetry;
          if (!isSuccess && retryable && retryPaymentType != null) {
            onRetry = () => context.pushReplacement(
              AppRoutes.paymentOnline,
              extra: {
                'orderId': extra['orderId'] as String?,
                'paymentType': retryPaymentType,
                'totalAmount': extra['totalAmount'] as num,
                'invoiceId': extra['invoiceId'] as String,
                'customerName': extra['customerName'] as String?,
                'vehicleModel': extra['vehicleModel'] as String?,
                'vehiclePlate': extra['vehiclePlate'] as String?,
                'bankCode': extra['retryBankCode'] as String?,
                'hideName': extra['hideName'] as bool? ?? false,
                'hideDoneButton': true,
              },
            );
          }

          return PaymentReceiptPage(
            orderId: extra['orderId'] as String?,
            hideName: extra['hideName'] as bool? ?? false,
            invoiceId: extra['invoiceId'] as String,
            totalAmount: extra['totalAmount'] as num,
            customerName: extra['customerName'] as String?,
            vehicleModel: extra['vehicleModel'] as String?,
            vehiclePlate: extra['vehiclePlate'] as String?,
            paymentMethod: extra['paymentMethod'] as String?,
            transactionTime: extra['transactionTime'] as String?,
            hideDoneButton: extra['hideDoneButton'] as bool? ?? true,
            isSuccess: isSuccess,
            failureReason: extra['failureReason'] as String?,
            onRetry: onRetry,
          );
        },
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const CustomText(
              text: "Page not found",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const CustomSpacing(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                borderRadius: 12,
                text: "Back",
                onPressed: () => context.go(AppRoutes.splash),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
