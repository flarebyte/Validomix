import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

expectMetricError(
    {required metricStoreHolder, required List<String> expectations}) {
  expect(metricStoreHolder.store.length, 1);
  final count = ExMetricAggregations.count();
  final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);
  final values = aggregatedMetrics.first.key.dimensions.values;
  for (var expectation in expectations) {
    expect(values, contains(expectation));
  }
}
