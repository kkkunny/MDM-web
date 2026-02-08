// This is a generated file - do not edit.
//
// Generated from task.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use taskPhaseDescriptor instead')
const TaskPhase$json = {
  '1': 'TaskPhase',
  '2': [
    {'1': 'TpUnknown', '2': 0},
    {'1': 'TpDownWaiting', '2': 1},
    {'1': 'TpDownRunning', '2': 2},
    {'1': 'TpDownPaused', '2': 3},
    {'1': 'TpDownFailed', '2': 4},
    {'1': 'TpDownCompleted', '2': 5},
  ],
};

/// Descriptor for `TaskPhase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskPhaseDescriptor = $convert.base64Decode(
    'CglUYXNrUGhhc2USDQoJVHBVbmtub3duEAASEQoNVHBEb3duV2FpdGluZxABEhEKDVRwRG93bl'
    'J1bm5pbmcQAhIQCgxUcERvd25QYXVzZWQQAxIQCgxUcERvd25GYWlsZWQQBBITCg9UcERvd25D'
    'b21wbGV0ZWQQBQ==');

@$core.Deprecated('Use operateDescriptor instead')
const Operate$json = {
  '1': 'Operate',
  '2': [
    {'1': 'OpUnknown', '2': 0},
    {'1': 'OpDelete', '2': 1},
    {'1': 'OpResume', '2': 2},
    {'1': 'OpPause', '2': 3},
  ],
};

/// Descriptor for `Operate`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List operateDescriptor = $convert.base64Decode(
    'CgdPcGVyYXRlEg0KCU9wVW5rbm93bhAAEgwKCE9wRGVsZXRlEAESDAoIT3BSZXN1bWUQAhILCg'
    'dPcFBhdXNlEAM=');

@$core.Deprecated('Use taskDescriptor instead')
const Task$json = {
  '1': 'Task',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'phase',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.task.TaskPhase',
      '10': 'phase'
    },
    {'1': 'size', '3': 4, '4': 1, '5': 4, '10': 'size'},
    {
      '1': 'category',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.task.Category',
      '9': 0,
      '10': 'category',
      '17': true
    },
    {'1': 'created_at', '3': 6, '4': 1, '5': 4, '10': 'createdAt'},
    {
      '1': 'download_stats',
      '3': 50,
      '4': 1,
      '5': 11,
      '6': '.task.DownloadStats',
      '9': 1,
      '10': 'downloadStats',
      '17': true
    },
  ],
  '8': [
    {'1': '_category'},
    {'1': '_download_stats'},
  ],
};

/// Descriptor for `Task`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskDescriptor = $convert.base64Decode(
    'CgRUYXNrEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiUKBXBoYXNlGAMgAS'
    'gOMg8udGFzay5UYXNrUGhhc2VSBXBoYXNlEhIKBHNpemUYBCABKARSBHNpemUSLwoIY2F0ZWdv'
    'cnkYBSABKAsyDi50YXNrLkNhdGVnb3J5SABSCGNhdGVnb3J5iAEBEh0KCmNyZWF0ZWRfYXQYBi'
    'ABKARSCWNyZWF0ZWRBdBI/Cg5kb3dubG9hZF9zdGF0cxgyIAEoCzITLnRhc2suRG93bmxvYWRT'
    'dGF0c0gBUg1kb3dubG9hZFN0YXRziAEBQgsKCV9jYXRlZ29yeUIRCg9fZG93bmxvYWRfc3RhdH'
    'M=');

@$core.Deprecated('Use categoryDescriptor instead')
const Category$json = {
  '1': 'Category',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
  ],
};

/// Descriptor for `Category`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryDescriptor = $convert.base64Decode(
    'CghDYXRlZ29yeRISCgRuYW1lGAEgASgJUgRuYW1lEhIKBGljb24YAiABKAlSBGljb24=');

@$core.Deprecated('Use downloadStatsDescriptor instead')
const DownloadStats$json = {
  '1': 'DownloadStats',
  '2': [
    {'1': 'speed', '3': 1, '4': 1, '5': 4, '10': 'speed'},
    {'1': 'progress', '3': 2, '4': 1, '5': 4, '10': 'progress'},
  ],
};

/// Descriptor for `DownloadStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadStatsDescriptor = $convert.base64Decode(
    'Cg1Eb3dubG9hZFN0YXRzEhQKBXNwZWVkGAEgASgEUgVzcGVlZBIaCghwcm9ncmVzcxgCIAEoBF'
    'IIcHJvZ3Jlc3M=');

@$core.Deprecated('Use listTasksRequestDescriptor instead')
const ListTasksRequest$json = {
  '1': 'ListTasksRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 13, '10': 'page'},
    {'1': 'count', '3': 2, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `ListTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VGFza3NSZXF1ZXN0EhIKBHBhZ2UYASABKA1SBHBhZ2USFAoFY291bnQYAiABKA1SBW'
    'NvdW50');

@$core.Deprecated('Use listTasksResponseDescriptor instead')
const ListTasksResponse$json = {
  '1': 'ListTasksResponse',
  '2': [
    {'1': 'tasks', '3': 1, '4': 3, '5': 11, '6': '.task.Task', '10': 'tasks'},
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VGFza3NSZXNwb25zZRIgCgV0YXNrcxgBIAMoCzIKLnRhc2suVGFza1IFdGFza3MSGQ'
    'oIaGFzX21vcmUYAiABKAhSB2hhc01vcmU=');

@$core.Deprecated('Use createTaskRequestDescriptor instead')
const CreateTaskRequest$json = {
  '1': 'CreateTaskRequest',
  '2': [
    {'1': 'link', '3': 1, '4': 1, '5': 9, '10': 'link'},
    {'1': 'name', '3': 10, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'category',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'category',
      '17': true
    },
  ],
  '8': [
    {'1': '_category'},
  ],
};

/// Descriptor for `CreateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVUYXNrUmVxdWVzdBISCgRsaW5rGAEgASgJUgRsaW5rEhIKBG5hbWUYCiABKAlSBG'
    '5hbWUSHwoIY2F0ZWdvcnkYCyABKAlIAFIIY2F0ZWdvcnmIAQFCCwoJX2NhdGVnb3J5');

@$core.Deprecated('Use createTaskResponseDescriptor instead')
const CreateTaskResponse$json = {
  '1': 'CreateTaskResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CreateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskResponseDescriptor =
    $convert.base64Decode('ChJDcmVhdGVUYXNrUmVzcG9uc2USDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use operateTasksRequestDescriptor instead')
const OperateTasksRequest$json = {
  '1': 'OperateTasksRequest',
  '2': [
    {'1': 'ids', '3': 1, '4': 3, '5': 9, '10': 'ids'},
    {
      '1': 'operate',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.task.Operate',
      '10': 'operate'
    },
  ],
};

/// Descriptor for `OperateTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operateTasksRequestDescriptor = $convert.base64Decode(
    'ChNPcGVyYXRlVGFza3NSZXF1ZXN0EhAKA2lkcxgBIAMoCVIDaWRzEicKB29wZXJhdGUYAiABKA'
    '4yDS50YXNrLk9wZXJhdGVSB29wZXJhdGU=');
