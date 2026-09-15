import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_state.dart';
import 'package:arena/components/custom_avatar.dart';

class CurrentUserAvatar extends StatelessWidget {
  final double radius;
  const CurrentUserAvatar({super.key, this.radius = 26});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String name = "";
        String? imageUrl;
        if (state is ProfileLoaded) {
          name = state.name;
          imageUrl = state.imageUrl;
        }
        return CustomAvatar(radius: radius, name: name, imageUrl: imageUrl);
      },
    );
  }
}
