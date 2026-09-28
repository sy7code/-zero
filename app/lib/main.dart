import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('danghwangzero');
  runApp(const DanghwangZeroApp());
}

class DanghwangZeroApp extends StatelessWidget {
  const DanghwangZeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '당황Zero',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffdf4b32)),
        useMaterial3: true,
      ),
      home: const PrototypeHome(),
    );
  }
}

class PrototypeHome extends StatefulWidget {
  const PrototypeHome({super.key});

  @override
  State<PrototypeHome> createState() => _PrototypeHomeState();
}

class _PrototypeHomeState extends State<PrototypeHome> {
  final _box = Hive.box('danghwangzero');
  final _tts = FlutterTts();
  final _picker = ImagePicker();

  Map<String, dynamic>? _accident;
  int _step = 0;
  final Map<String, String> _answers = {};
  final Map<String, String> _photoSlots = {};
  final List<String> _log = [];

  List<String> get _missingSlots {
    const required = ['scene_wide', 'my_damage', 'other_plate', 'road_sign'];
    return required.where((slot) => _photoSlots[slot] != 'done').toList();
  }

  String get _situationLabel {
    if (_answers['injury'] == 'yes' || _answers['injury'] == 'unknown') {
      return '긴급 확인 필요';
    }
    if (_answers['other_vehicle'] == 'yes') return '차대차 접촉사고 가능성';
    if (_answers['facility'] == 'yes') return '시설물 파손 가능성';
    return '추가 확인 필요';
  }

  Future<void> _startAccident() async {
    final now = DateTime.now();
    Position? position;
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        position = await Geolocator.getCurrentPosition();
      }
    } catch (_) {
      position = null;
    }

    final accident = {
      'id': _uuid.v4(),
      'occurred_at': now.toIso8601String(),
      'location_source': position == null ? 'manual' : 'gps',
      'latitude': position?.latitude,
      'longitude': position?.longitude,
      'answers': _answers,
      'photo_slots': _photoSlots,
      'log': _log,
    };
    await _box.put('active_accident', accident);
    setState(() {
      _accident = accident;
      _step = 1;
      _log.add('사고 대응 시작: ${now.toLocal()}');
    });
  }

  Future<void> _saveState() async {
    if (_accident == null) return;
    _accident = {
      ..._accident!,
      'answers': Map<String, String>.from(_answers),
      'photo_slots': Map<String, String>.from(_photoSlots),
      'log': List<String>.from(_log),
      'situation_label': _situationLabel,
    };
    await _box.put('active_accident', _accident);
    await _box.put('latest_summary', _accident);
  }

  Future<void> _answer(String key, String value) async {
    setState(() {
      _answers[key] = value;
      _log.add('$key=$value');
      if (_step < 4) _step += 1;
    });
    await _saveState();
  }

  Future<void> _capture(String slot) async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final target = File('${dir.path}/${_uuid.v4()}_$slot.jpg');
    await File(picked.path).copy(target.path);

    setState(() {
      _photoSlots[slot] = 'done';
      _log.add('photo:$slot saved');
      if (_missingSlots.isEmpty) _step = 5;
    });
    await _saveState();
  }

  Future<void> _speakCurrentAction() async {
    await _tts.setLanguage('ko-KR');
    await _tts.speak(_nextActionText());
  }

  Future<void> _shareSummary() async {
    await _saveState();
    final text = [
      '당황Zero 사고 기록',
      '상황 후보: $_situationLabel',
      '시간: ${_accident?['occurred_at'] ?? '-'}',
      '위치 출처: ${_accident?['location_source'] ?? '-'}',
      '사진 완료: ${_photoSlots.entries.where((e) => e.value == 'done').length}',
      '누락 사진: ${_missingSlots.join(', ')}',
    ].join('\n');
    await Share.share(text);
  }

  String _nextActionText() {
    if (_step == 1) return '다친 사람이 있나요?';
    if (_step == 2) return '다른 차량이 관련되어 있나요?';
    if (_step == 3) return '시설물이 파손되었나요?';
    if (_step == 4 && _missingSlots.isNotEmpty) {
      return _slotLabel(_missingSlots.first);
    }
    return '사고 기록 카드를 확인하세요.';
  }

  String _slotLabel(String slot) {
    return switch (slot) {
      'scene_wide' => '전체 현장 사진을 찍어 주세요.',
      'my_damage' => '내 차량 파손 부위를 찍어 주세요.',
      'other_plate' => '상대 차량 번호판을 찍어 주세요.',
      'road_sign' => '표지판이나 신호등을 찍어 주세요.',
      _ => '필요한 사진을 찍어 주세요.',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('당황Zero'),
        actions: [
          IconButton(
            tooltip: '음성 안내',
            onPressed: _accident == null ? null : _speakCurrentAction,
            icon: const Icon(Icons.volume_up),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _accident == null ? _buildStart() : _buildFlow(),
        ),
      ),
    );
  }

  Widget _buildStart() {
    final latest = _box.get('latest_summary') as Map?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '교통사고 직후, 다음 행동을 하나씩 안내합니다.',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const Text('기록은 이 기기에 저장되고, AI는 판단이 아니라 관찰 후보만 돕습니다.'),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _startAccident,
          icon: const Icon(Icons.play_arrow),
          label: const Text('사고 대응 시작'),
        ),
        const SizedBox(height: 24),
        if (latest != null)
          _InfoPanel(
            title: '최근 기록',
            child: Text('${latest['situation_label'] ?? '기록 있음'}'),
          ),
      ],
    );
  }

  Widget _buildFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: (_step.clamp(1, 5)) / 5),
        const SizedBox(height: 16),
        Text(
          _nextActionText(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildStep()),
      ],
    );
  }

  Widget _buildStep() {
    if (_step == 1) {
      return _ChoiceStep(
        options: const {'yes': '있음', 'no': '없음', 'unknown': '모름'},
        onSelected: (value) => _answer('injury', value),
      );
    }
    if (_step == 2) {
      return _ChoiceStep(
        options: const {'yes': '있음', 'no': '없음', 'unknown': '모름'},
        onSelected: (value) => _answer('other_vehicle', value),
      );
    }
    if (_step == 3) {
      return _ChoiceStep(
        options: const {'yes': '있음', 'no': '없음', 'unknown': '모름'},
        onSelected: (value) => _answer('facility', value),
      );
    }
    if (_step == 4) {
      final slot = _missingSlots.isEmpty ? null : _missingSlots.first;
      if (slot == null) {
        return Center(
          child: FilledButton(
            onPressed: () => setState(() => _step = 5),
            child: const Text('기록 카드 보기'),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoPanel(
            title: '상황 후보',
            child: Text(_situationLabel),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _capture(slot),
            icon: const Icon(Icons.camera_alt),
            label: Text(_slotLabel(slot)),
          ),
          TextButton(
            onPressed: () => _answer('skip_$slot', 'yes'),
            child: const Text('지금은 건너뛰기'),
          ),
          const SizedBox(height: 12),
          Text('남은 사진: ${_missingSlots.map(_slotLabel).join(' / ')}'),
        ],
      );
    }
    return _SummaryCard(
      situation: _situationLabel,
      missing: _missingSlots,
      log: _log,
      onShare: _shareSummary,
      onReset: () async {
        await _box.delete('active_accident');
        setState(() {
          _accident = null;
          _step = 0;
          _answers.clear();
          _photoSlots.clear();
          _log.clear();
        });
      },
    );
  }
}

class _ChoiceStep extends StatelessWidget {
  const _ChoiceStep({required this.options, required this.onSelected});

  final Map<String, String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.entries
          .map(
            (entry) => FilledButton(
              onPressed: () => onSelected(entry.key),
              child: Text(entry.value),
            ),
          )
          .toList(),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.situation,
    required this.missing,
    required this.log,
    required this.onShare,
    required this.onReset,
  });

  final String situation;
  final List<String> missing;
  final List<String> log;
  final VoidCallback onShare;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _InfoPanel(
          title: '사고 기록 카드',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('상황 후보: $situation'),
              Text('누락 사진: ${missing.isEmpty ? '없음' : missing.join(', ')}'),
              const SizedBox(height: 12),
              const Text('주의: 과실, 법적 책임, 신고 필요 여부는 확정하지 않습니다.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.share),
          label: const Text('기록 공유'),
        ),
        TextButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt),
          label: const Text('데모 초기화'),
        ),
        const SizedBox(height: 16),
        const Text('진행 로그', style: TextStyle(fontWeight: FontWeight.w700)),
        ...log.map((item) => ListTile(dense: true, title: Text(item))),
      ],
    );
  }
}
