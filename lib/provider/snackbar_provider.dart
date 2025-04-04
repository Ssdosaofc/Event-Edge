import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snackbarData.dart';

final snackbarProvider = StateProvider<SnackbarData?>((ref) => null);