import 'package:mdm/apis/mdm/client.dart';
import 'package:mdm/models/vo/task.pb.dart';

Future<List<Task>> listTasks() async {
  final data = await request(
    'GET',
    'http://localhost:8080/api/task/list',
    queries: {'page': 1, 'count': 20},
  );
  final resp = ListTasksResponse.create()..mergeFromProto3Json(data);
  return resp.tasks;
}
