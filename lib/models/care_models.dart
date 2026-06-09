class CarePatient {
  const CarePatient({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.status,
    required this.nextVisit,
    required this.summary,
  });

  final String id;
  final String name;
  final int age;
  final String city;
  final String status;
  final String nextVisit;
  final String summary;

  String get statusLabel => status.toUpperCase();
}

class CareVisit {
  const CareVisit({
    required this.id,
    required this.title,
    required this.patientName,
    required this.time,
    required this.location,
    required this.status,
    required this.services,
  });

  final String id;
  final String title;
  final String patientName;
  final String time;
  final String location;
  final String status;
  final List<String> services;

  String get statusLabel => status.toUpperCase();
}

class CareFormItem {
  const CareFormItem({
    required this.id,
    required this.title,
    required this.progress,
    required this.description,
  });

  final String id;
  final String title;
  final double progress;
  final String description;
}

class PatientDetailArgs {
  const PatientDetailArgs({required this.patient});

  final CarePatient patient;
}

class VisitDetailArgs {
  const VisitDetailArgs({required this.visit});

  final CareVisit visit;
}

const List<CarePatient> samplePatients = <CarePatient>[
  CarePatient(
    id: 'pt-001',
    name: 'Margaret Chen',
    age: 82,
    city: 'San Francisco',
    status: 'active',
    nextVisit: 'Today, 9:00 AM',
    summary: 'Morning care visit and medication assistance.',
  ),
  CarePatient(
    id: 'pt-002',
    name: 'Robert Kim',
    age: 69,
    city: 'Oakland',
    status: 'in progress',
    nextVisit: 'In progress',
    summary: 'Assessment visit with live notes in progress.',
  ),
  CarePatient(
    id: 'pt-003',
    name: 'Sarah Johnson',
    age: 57,
    city: 'Berkeley',
    status: 'scheduled',
    nextVisit: 'Today, 2:30 PM',
    summary: 'Light housekeeping and companion care.',
  ),
];

const List<CareVisit> sampleVisits = <CareVisit>[
  CareVisit(
    id: 'visit-001',
    title: 'Morning Care Visit',
    patientName: 'Margaret Chen',
    time: 'Today, 9:00 AM',
    location: '245 Oak Street, Apt 3B',
    status: 'completed',
    services: <String>['Personal Care', 'Medication', 'Meal Prep'],
  ),
  CareVisit(
    id: 'visit-002',
    title: 'Assessment Visit',
    patientName: 'Robert Kim',
    time: 'Today, 11:30 AM',
    location: '892 Maple Drive',
    status: 'in progress',
    services: <String>['Assessment', 'Care Plan Review'],
  ),
  CareVisit(
    id: 'visit-003',
    title: 'Afternoon Check-in',
    patientName: 'Sarah Johnson',
    time: 'Today, 2:30 PM',
    location: '1247 Pine Avenue',
    status: 'upcoming',
    services: <String>['Companion Care', 'Light Housekeeping'],
  ),
];

const List<CareFormItem> sampleForms = <CareFormItem>[
  CareFormItem(
    id: 'form-001',
    title: 'Daily Care Log',
    progress: 0.85,
    description: 'Ready to review and submit.',
  ),
  CareFormItem(
    id: 'form-002',
    title: 'Assessment Intake',
    progress: 0.45,
    description: 'In progress with saved draft.',
  ),
  CareFormItem(
    id: 'form-003',
    title: 'Invoice Review',
    progress: 0.2,
    description: 'Awaiting approval for three items.',
  ),
];