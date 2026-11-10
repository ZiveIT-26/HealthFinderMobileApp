/// Mock data for the home screen until the backend is ready.
/// Once the API exists, these classes move to models/ and data comes from a repository.
library;

class MedicationDose {
  const MedicationDose({
    required this.name,
    required this.dose,
    required this.time,
    required this.amount,
  });

  final String name; // Vitamin D
  final String dose; // 1000 IU
  final String time; // 12:00
  final String amount; // 1 tablet
}

class MedicationsSummary {
  const MedicationsSummary({
    required this.taken,
    required this.total,
    required this.next,
    required this.moreCount,
  });

  final int taken;
  final int total;
  final MedicationDose next;
  final int moreCount;
}

enum Mood {
  veryBad('Very bad', 'very_bad'),
  bad('Bad', 'bad'),
  okay('Okay', 'okay'),
  good('Good', 'good'),
  great('Great', 'great');

  const Mood(this.label, this._file);

  final String label;
  final String _file;

  String get asset => 'assets/mood/$_file.png';
  String get selectedAsset => 'assets/mood/${_file}_selected.png';
}

/// The tone decides the metric value color.
enum MetricTone { neutral, low, good, moderate }

class WeatherMetric {
  const WeatherMetric(this.label, this.value, this.tone);

  final String label;
  final String value;
  final MetricTone tone;
}

class WeatherSummary {
  const WeatherSummary({
    required this.temperature,
    required this.condition,
    required this.city,
    required this.metrics,
  });

  final String temperature;
  final String condition;
  final String city;
  final List<WeatherMetric> metrics;
}

abstract final class HomeMockData {
  static const medications = MedicationsSummary(
    taken: 4,
    total: 8,
    moreCount: 3,
    next: MedicationDose(
      name: 'Vitamin D',
      dose: '1000 IU',
      time: '12:00',
      amount: '1 tablet',
    ),
  );

  static const weather = WeatherSummary(
    temperature: '15°C',
    condition: 'Partly cloudy',
    city: 'Košice',
    metrics: [
      WeatherMetric('UV Index', '2 · Low', MetricTone.low),
      WeatherMetric('Air Pressure', '1015 hPa', MetricTone.neutral),
      WeatherMetric('Air Quality', 'Good', MetricTone.good),
      WeatherMetric('Pollen', 'Moderate', MetricTone.moderate),
      WeatherMetric('Heatwave Risk', 'Low', MetricTone.low),
      WeatherMetric('Humidity', '62%', MetricTone.neutral),
    ],
  );
}
