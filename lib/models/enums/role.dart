enum Role {
  owner,
  customerServices,
  warehouseStaff,
  cashier,
  developer,
  unknown;

  static Role fromString(String? role) {
    switch (role?.trim().toLowerCase()) {
      case 'owner':
        return Role.owner;
      case 'customer_service':
      case 'customer services':
      case 'customerservices':
      case 'customer service':
        return Role.customerServices;
      case 'warehouse':
      case 'warehouse_staff':
      case 'warehousestaff':
        return Role.warehouseStaff;
      case 'cashier':
        return Role.cashier;
      case 'developer':
        return Role.developer;
      default:
        return Role.unknown;
    }
  }
}
