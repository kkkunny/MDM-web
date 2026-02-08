import 'package:mdm/configs/api.dart';
import 'package:mdm/apis/mdm/client.dart';
import 'package:mdm/models/vo/task.pb.dart';


Future<List<Task>> listTasks() async {
  final data = await request(
    'GET',
    '${getApiBaseUrl()}/api/task/list',
    queries: {'page': 1, 'count': 20},
  );
  final resp = ListTasksResponse.create()..mergeFromProto3Json(data);
  return resp.tasks;
}

Future<void> operateTasks(OperateTasksRequest req) async {
  await request(
    'POST',
    '${getApiBaseUrl()}/api/task/operate',
    contentType: 'application/json',
    data: req.toProto3Json(),
  );
}
