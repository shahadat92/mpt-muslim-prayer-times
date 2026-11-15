import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AdhanLength { full, short }

class AdhanAudioService {
  final AudioPlayer _player = AudioPlayer();
  AdhanLength length = AdhanLength.full;
  bool specialFajr = true;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    length = prefs.getString('adhan_length') == 'short'
        ? AdhanLength.short : AdhanLength.full;
    specialFajr = prefs.getBool('special_fajr') ?? true;
  }

  String assetFor({required bool fajr}) {
    final prefix = fajr && specialFajr ? 'fajr' : 'regular';
    final suffix = length == AdhanLength.full ? 'full' : 'short';
    return 'audio/${prefix}_$suffix.mp3';
  }

  Future<void> preview({required bool fajr}) async {
    await _player.stop();
    await _player.play(AssetSource(assetFor(fajr: fajr)));
  }

  Future<void> stop() => _player.stop();

  Future<void> setLength(AdhanLength value) async {
    length = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhan_length', value == AdhanLength.full ? 'full' : 'short');
  }

  Future<void> setSpecialFajr(bool value) async {
    specialFajr = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('special_fajr', value);
  }

  Future<void> dispose() => _player.dispose();
}
