import 'call_model.dart';

/// One item from GET /list?userId=...
class CallingListModel {
  final String id;
  final String name;
  final List<dynamic> agents;
  final String clientId;

  const CallingListModel({
    required this.id,
    required this.name,
    required this.agents,
    required this.clientId,
  });

  factory CallingListModel.fromJson(Map<String, dynamic> json) =>
      CallingListModel(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        agents: (json['agents'] as List?) ?? [],
        clientId: json['clientId']?.toString() ?? '',
      );
}

/// Response of GET /list/{id}: counts for the donut chart + the calls.
class CallingListDetails {
  final int pending;
  final int called;
  final int rescheduled;
  final List<CallModel> calls;

  const CallingListDetails({
    required this.pending,
    required this.called,
    required this.rescheduled,
    required this.calls,
  });

  factory CallingListDetails.fromJson(Map<String, dynamic> json) =>
      CallingListDetails(
        pending: (json['pending'] as num?)?.toInt() ?? 0,
        called: (json['called'] as num?)?.toInt() ?? 0,
        rescheduled: (json['rescheduled'] as num?)?.toInt() ?? 0,
        calls: ((json['calls'] as List?) ?? [])
            .map((e) => CallModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}
