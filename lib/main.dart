import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'app.dart';
import 'state/app_state.dart';
import 'state/app_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await FlutterNaverMap().init(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID'],
    onAuthFailed: (ex) {
      switch (ex) {
        case NQuotaExceededException(:final message):
          debugPrint("사용량 초과 (message: $message)");
          break;
        case NUnauthorizedClientException() ||
        NClientUnspecifiedException() ||
        NAnotherAuthFailedException():
          debugPrint("인증 실패: $ex");
          break;
      }
    },
  );

  runApp(AppScope(state: AppState(), child: const App()));
}
