// This is a generated file - do not edit.
//
// Generated from task.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// 任务阶段
class TaskPhase extends $pb.ProtobufEnum {
  static const TaskPhase TpUnknown =
      TaskPhase._(0, _omitEnumNames ? '' : 'TpUnknown');
  static const TaskPhase TpDownWaiting =
      TaskPhase._(1, _omitEnumNames ? '' : 'TpDownWaiting');
  static const TaskPhase TpDownRunning =
      TaskPhase._(2, _omitEnumNames ? '' : 'TpDownRunning');
  static const TaskPhase TpDownPaused =
      TaskPhase._(3, _omitEnumNames ? '' : 'TpDownPaused');
  static const TaskPhase TpDownFailed =
      TaskPhase._(4, _omitEnumNames ? '' : 'TpDownFailed');
  static const TaskPhase TpDownCompleted =
      TaskPhase._(5, _omitEnumNames ? '' : 'TpDownCompleted');

  static const $core.List<TaskPhase> values = <TaskPhase>[
    TpUnknown,
    TpDownWaiting,
    TpDownRunning,
    TpDownPaused,
    TpDownFailed,
    TpDownCompleted,
  ];

  static final $core.List<TaskPhase?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static TaskPhase? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskPhase._(super.value, super.name);
}

/// 操作行为
class Operate extends $pb.ProtobufEnum {
  static const Operate OpUnknown =
      Operate._(0, _omitEnumNames ? '' : 'OpUnknown');
  static const Operate OpDelete =
      Operate._(1, _omitEnumNames ? '' : 'OpDelete');
  static const Operate OpResume =
      Operate._(2, _omitEnumNames ? '' : 'OpResume');
  static const Operate OpPause = Operate._(3, _omitEnumNames ? '' : 'OpPause');

  static const $core.List<Operate> values = <Operate>[
    OpUnknown,
    OpDelete,
    OpResume,
    OpPause,
  ];

  static final $core.List<Operate?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Operate? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Operate._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
