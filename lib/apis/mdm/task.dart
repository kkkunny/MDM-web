import 'package:mdm/configs/api.dart';
import 'package:mdm/apis/mdm/client.dart';
import 'package:mdm/models/vo/task.pb.dart';

Future<ListTasksResponse> listTasks({int page = 1, int count = 20}) async {
  final data = await request(
    'GET',
    '${getApiBaseUrl()}/api/task/list',
    queries: {'page': page, 'count': count},
  );
  return ListTasksResponse.create()..mergeFromProto3Json(data);
}

Future<void> operateTasks(OperateTasksRequest req) async {
  await request(
    'POST',
    '${getApiBaseUrl()}/api/task/operate',
    contentType: 'application/json',
    data: req.toProto3Json(),
  );
}

Future<CreateTaskResponse> createTask(CreateTaskRequest req) async {
  final data = await request(
    'POST',
    '${getApiBaseUrl()}/api/task/create',
    contentType: 'application/json',
    data: req.toProto3Json(),
  );
  return CreateTaskResponse.create()..mergeFromProto3Json(data);
}
