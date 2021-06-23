// Flutter imports:
import 'package:flutter/material.dart';

const kBgLightColor = Color(0xFF303030);
const kBgDarkColor = Color(0xFF181818);
const kDefaultPadding = 20.0;

List<String> settingsList = [
  'outputformat',
  'outputfilename',
  'autoprogram',
  'append'
];

/// Input formats
List<String> inputFormats = [
  'ts   -> For Transport Streams.',
  'ps   -> For Program Streams.',
  'es   -> For Elementary Streams.',
  'asf  -> ASF container (such as DVR-MS).',
  'wtv  -> Windows Television (WTV)',
  'bin  -> CCExtractor\'s own binary format.',
  'raw  -> For McPoodle\'s raw files.',
  'mp4  -> MP4/MOV/M4V and similar.'
];

List<String> quantMode = [
  'Don\'t quantize at all.',
  'Use CCExtractor\'s internal function (default).',
  'Reduce distinct color count in image for faster results.',
];

List<String> oem = [
  '',
  'OEM_TESSERACT_ONLY - the fastest mode.',
  'OEM_LSTM_ONLY - use LSTM algorithm for recognition.',
  'OEM_TESSERACT_LSTM_COMBINED - both algorithms.',
];

/// Output formats
List<String> outputFormats = [
  'srt',
  'ssa',
  'webvtt',
  'sami',
  'bin',
  'raw',
  'dvdraw',
  'txt',
  'ttxt',
  'smptett',
  'spupng',
  'null',
];
