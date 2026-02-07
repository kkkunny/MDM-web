SVR_ROOT_PATH = $(realpath ../../go/github.com/kkkunny/MDM)
WEB_ROOT_PATH = $(realpath .)

gen_idl: $(SVR_ROOT_PATH)/model/idl
	-rm -rf lib/models/vo
	mkdir -p lib/models/vo
	protoc -I=$(SVR_ROOT_PATH)/model/idl/vo --dart_out=lib/models/vo $(SVR_ROOT_PATH)/model/idl/vo/task.proto
	find lib/models/vo -type f -name "*.dart" -print0 | xargs -0 perl -pi -e 's/\$$pb\.PbList<([^>]+)>\(\)/[] as \$$pb.PbList<\1>/g'