class AppRoutes {
  // Auth
  static const splash = "/splash";
  static const login = "/login";
  static const register = "/register";
  static const codeRegistration = '/code-registration';
  static const forgotPasswordEmail = "/forgot-password/email";
  static const forgotPasswordVerification = "/forgot-password/verification";
  static const forgotPasswordReset = "/forgot-password/reset";
  static const changePassword = "/profile/change-password";
  static const editProfile = "/profile/edit";

  // User Management
  static const addUser = "/add-user";
  static const inviteSend = "/invite-send";

  // Stock Management
  static const stockDetail = "/stock/:id";
  static const addStock = "/add-stock";
  static const addStockForm = "/add-stock-form";
  static const addDot = "/add-dot";
  static const stockPreview = "/stock-preview";
  static const editStock = "/edit-stock";

  // Order
  static const checkoutCart = "/checkout-cart";
  static const checkoutPreview = "/checkout-cart/preview";

  // Owner
  static const dashboardOwner = "/owner/dashboard";
  static const stockListOwner = "/owner/stock-list";
  static const userListOwner = "/owner/user-list";
  static const userDetailOwner = "/owner/user-detail";
  static const productListOwner = "/owner/product-list";
  static const brandListOwner = "/owner/brand-list";
  static const historyOwner = "/owner/history";
  static const inboxOwner = "/owner/inbox";
  static const reportOwner = "/owner/report";
  static const stockListByBrandOwner = "/owner/stock-list/brand/:brandName";

  static String stockListByBrandOwnerPath(String brandName) =>
      "/owner/stock-list/brand/${Uri.encodeComponent(brandName)}";

  //Warehouse Staff
  static const dashboardWarehouse = "/warehouse/dashboard";
  static const orderListWarehouse = "/warehouse/order-list";
  static const orderDetailWarehouse = "/warehouse/order-detail/:id";
  static const stockListWarehouse = "/warehouse/stock-list";
  static const productListWarehouse = "/warehouse/product-list";
  static const brandListWarehouse = "/warehouse/brand-list";
  static const historyWarehouse = "/warehouse/history";
  static const inboxWarehouse = "/warehouse/inbox";
  static const reportWarehouse = "/warehouse/report";
  static const stockListByBrandWarehouse =
      "/warehouse/stock-list/brand/:brandName";

  static String stockListByBrandWarehousePath(String brandName) =>
      "/warehouse/stock-list/brand/${Uri.encodeComponent(brandName)}";

  // Cashier
  static const orderListCashier = "/cashier/order-list";
  static const orderDetailCashier = "/cashier/order/:id";
  static const stockListCashier = "/cashier/stock-list";
  static const inboxCashier = "/cashier/inbox";
  static const stockListByBrandCashier = "/cashier/stock-list/brand/:brandName";

  static String stockListByBrandCashierPath(String brandName) =>
      "/cashier/stock-list/brand/${Uri.encodeComponent(brandName)}";

  // Customer Service
  static const stockListCs = "/cs/stock-list";
  static const orderListCs = "/cs/order-list";
  static const orderDetailCs = "/cs/order/:id";
  static const inboxCs = "/cs/inbox";
  static const stockListByBrandCs = "/cs/stock-list/brand/:brandName";

  static String stockListByBrandCsPath(String brandName) =>
      "/cs/stock-list/brand/${Uri.encodeComponent(brandName)}";

  // UNIVERSAL
  // Profile & Settings
  static const profile = "/profile";
  static const notificationSettings = "/settings/notification";
  static const stockInventorySettings = "/settings/stock-inventory";

  static const navOwnerPage = dashboardOwner;
  static const navWarehousePage = dashboardWarehouse;
  static const navCashierPage = orderListCashier;
  static const navCsPage = orderListCs;

  // Customer Detail
  static const customerDetail = "/customer-detail";
  static const customerList = "/customer-list";

  // CART
  static const cartList = "/cart-list";

  // Payment
  static const paymentCash = "/payment/cash";
  static const paymentOnline = "/payment/online";
  static const paymentCashChange = "/payment/cash-change";
  static const paymentReceipt = "/payment/receipt";
}
