import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:write_only_twitter/src/models/UserProfile.dart';

final UserProfileProvider =
    StateNotifierProvider<_UserProfile, UserProfile?>((_) => _UserProfile());

class _UserProfile extends StateNotifier<UserProfile?> {
  _UserProfile() : super(null);

  void set(UserProfile userProfile) => {state = userProfile};
}
