import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_survey_platform_interface.dart';

/// An implementation of [FlutterSurveyPlatform] that uses method channels.
class MethodChannelFlutterSurvey extends FlutterSurveyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_survey');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
