import 'package:careconnect661/models/care_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sample data exposes the planned screen inventory', () {
    expect(samplePatients.length, 3);
    expect(sampleVisits.length, 3);
    expect(sampleForms.length, 3);
  });

  test('status labels are normalized for display', () {
    expect(samplePatients.first.statusLabel, 'ACTIVE');
    expect(sampleVisits.first.statusLabel, 'COMPLETED');
  });
}