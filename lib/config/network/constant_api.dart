class ConstantApi {
  static const String baseUrl = String.fromEnvironment('API_URL');
  static const String apiUrl = "/api";
  static const String version = "/v1";

  static const String fullUrl = "$baseUrl$apiUrl$version";

  // AUTH
  static const String auth = "/auth";
  static const String login = "$auth/login";
  static const String register = "$auth/register";
  static const String logout = "$auth/logout";
  static const String profile = "$auth/me";
  static const String requestReset = "$auth/password/request-reset";
  static const String resetPassword = "$auth/password/reset";

  // ORDER
  static const String orders = "/orders";
  static const String orderDetail = "/orders/{id}";
  static const String updateOrderStatus = "/orders";
  static const String invoice = "/orders/{id}/invoice";
  static const String markAsPickedUp = "/orders/{id}/pickup";
  static const String cancelOrder = "/orders/{id}/cancel";

  // PAYMENT
  static const String payOrder = "/orders/{id}/pay";
  static const String confirmPayment = "/orders/{id}/confirm";
  static const String qrisPaymentStatus = "/orders/{id}/payment/qris";
  static const String vaPaymentStatus = "/orders/{id}/payment/va";
  static const String paymentDetail = "/payments/{id}";
  static const String payments = "/payments";
  static const String refundPayment = "/payments/{id}/refund";

  // STOCK
  static const String stocks = "/stocks";
  static const String stockDetail = "/stocks/{id}";
  static const String updateStock = "/stocks/{id}";
  static const String addStock = "/inventory/add-stock";
  static const String adjustStock = "/inventory/adjust";

  // PRODUCT
  static const String products = "/products";
  static const String addProducts = products;
  static const String addVariant = "$products/{id}/variants";
  static const String updateProducts = "$products/{id}";
  static const String deleteProducts = "$products/{id}";

  // BRAND
  static const String brands = "/brands";
  static const String addBrand = "/brands";
  static const String updateBrandName = "$brands/{id}";
  static const String deleteBrand = "$brands/{id}";

  // CUSTOMER
  static const String customers = "/customers";

  // JASA
  static const String services = "/services";
  static const String addService = "/services";
  static const String updateService = "/services/{id}";
  static const String deleteService = "/services/{id}";

  // HISTORY
  static const String history = "/stocks/history";

  /// CART
  static const String carts = "/cart";
  static const String addCart = "/cart/add";
  static const String addCartService = "/cart/service";
  static const String checkoutCart = "/cart/checkout";
  static const String updateCartItem = "/cart/item/{id}";
  static const String discountCart = "/cart/discount";
  static const String deleteCartItem = "/cart/item/{id}";
  static const String clearCart = "/cart";

  // USER
  static const String users = "/users";
  static const String invite = "$auth/invite";
  static const String updateUserActivation = "$users/{id}/status";
  static const String updateUserRole = "$users/{id}/role";

  // NOTIFICATION
  static const String notifications = "/notifications";
  static const String notificationsSse = "/notifications/unread-count/stream";
  static const String notificationSettings = "$notifications/settings";

  // DOT STATUS RULES
  static const String dotStatusRules = "/dot-status-rules";
  static const String updateDotStatusRules = "/dot-status-rules/{id}";

  // STOCK STATUS RULES
  static const String stockStatusRules = "/stock-status-rules";
  static const String updateStockStatusRule = "/stock-status-rules/{id}";

  // REPORT
  static const String reports = "/reports";
  static const String reportsSummary = "$reports/summary";
  static const String reportsTopProducts = "$reports/top-products";
  static const String reportsStockMovement = "$reports/stock-movement";
  static const String reportsStockHealth = "$reports/stock-health";

  // DASHBOARD
  static const String dashboard = "/dashboard";
  static const String dashboardWarehouse = "/dashboard/warehouse";
}
