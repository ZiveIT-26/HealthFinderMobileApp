import 'package:material_ui/material_ui.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Dictation into a [TextEditingController] using the phone's built-in speech
/// recognition. No backend involved.
///
/// The UI (see ChatComposer) only needs [isListening] and [toggle]. If you
/// later switch to a cloud speech API, replace the internals of this class and
/// the UI stays untouched.
class VoiceInputController extends ChangeNotifier {
  VoiceInputController({
    this.localeId,
    this.onDeviceOnly = false,
    this.pauseFor = const Duration(seconds: 3),
    this.listenFor = const Duration(minutes: 1),
  });

  /// For example 'en_US'. Null uses the device's default language.
  final String? localeId;

  /// If true, speech is recognized locally and never leaves the device.
  /// Listening fails when the device can't do that (language pack missing,
  /// older OS), so test it on real devices before turning it on.
  final bool onDeviceOnly;

  /// Stop automatically after this much silence.
  final Duration pauseFor;

  /// Hard limit of one recording.
  final Duration listenFor;

  final SpeechToText _speech = SpeechToText();

  bool _initialized = false;
  bool _listening = false;
  String? _lastError;

  TextEditingController? _target;
  String _textBeforeListening = '';

  bool get isListening => _listening;

  /// Last error message from the recognizer, if any. Useful for debugging.
  String? get lastError => _lastError;

  /// Starts or stops dictation into [target].
  ///
  /// Returns false when speech recognition can't be used: the user denied
  /// permission, or the device has no recognizer. Show a message in that case.
  Future<bool> toggle(TextEditingController target) async {
    if (_listening) {
      await stop();
      return true;
    }
    return start(target);
  }

  Future<bool> start(TextEditingController target) async {
    // Initialized on the first tap, so the permission dialog appears when the
    // user actually asks for voice input and not when the screen opens.
    if (!_initialized) {
      _initialized = await _speech.initialize(
        onStatus: _handleStatus,
        onError: _handleError,
      );
    }
    if (!_initialized) return false;

    _target = target;
    // Keep what the user already typed and append the spoken words to it.
    _textBeforeListening = target.text.trim();
    _lastError = null;

    _setListening(true);
    try {
      await _speech.listen(
        onResult: _handleResult,
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          pauseFor: pauseFor,
          listenFor: listenFor,
          partialResults: true,
          cancelOnError: true,
          onDevice: onDeviceOnly,
          listenMode: ListenMode.dictation,
        ),
      );
    } catch (e) {
      _lastError = e.toString();
      _setListening(false);
      return false;
    }
    return true;
  }

  Future<void> stop() async {
    await _speech.stop();
    _setListening(false);
  }

  void _handleResult(SpeechRecognitionResult result) {
    final target = _target;
    if (target == null) return;

    final spoken = result.recognizedWords;
    final text = _textBeforeListening.isEmpty
        ? spoken
        : '$_textBeforeListening $spoken';

    target.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _handleStatus(String status) {
    // Recognition can end by itself (silence timeout, OS limit).
    if (status == 'done' || status == 'notListening') {
      _setListening(false);
    }
  }

  void _handleError(SpeechRecognitionError error) {
    _lastError = error.errorMsg;
    _setListening(false);
  }

  void _setListening(bool value) {
    if (_listening == value) return;
    _listening = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}