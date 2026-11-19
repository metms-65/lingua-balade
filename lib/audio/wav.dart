import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const _sampleRate = 22050;

/// Écrit un fichier WAV mono 16 bits à partir d'échantillons dans [-1, 1].
Future<File> _writeWav(String path, Float64List samples) async {
  final data = ByteData(44 + samples.length * 2);
  void ascii(int offset, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  data.setUint32(4, 36 + samples.length * 2, Endian.little);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little); // PCM
  data.setUint16(22, 1, Endian.little); // mono
  data.setUint32(24, _sampleRate, Endian.little);
  data.setUint32(28, _sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  ascii(36, 'data');
  data.setUint32(40, samples.length * 2, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    data.setInt16(44 + i * 2, (samples[i].clamp(-1.0, 1.0) * 32767).round(), Endian.little);
  }
  final file = File(path);
  await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
  return file;
}

/// Silence de [ms] millisecondes (réutilisé s'il existe déjà).
Future<File> silenceFile(Directory dir, int ms) async {
  final file = File('${dir.path}/silence_$ms.wav');
  if (await file.exists()) return file;
  return _writeWav(file.path, Float64List(_sampleRate * ms ~/ 1000));
}

/// Bip court, avec fondu pour éviter les claquements.
Future<File> beepFile(Directory dir, {required String name, required double hz, int ms = 140}) async {
  final file = File('${dir.path}/$name.wav');
  if (await file.exists()) return file;
  final n = _sampleRate * ms ~/ 1000;
  final samples = Float64List(n);
  final fade = n ~/ 6;
  for (var i = 0; i < n; i++) {
    final env = min(1.0, min(i, n - i) / fade);
    samples[i] = 0.35 * env * sin(2 * pi * hz * i / _sampleRate);
  }
  return _writeWav(file.path, samples);
}
