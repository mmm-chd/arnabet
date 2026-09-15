import 'package:flutter/material.dart';

void openNavDrawer(BuildContext context) {
  context.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer();
}
