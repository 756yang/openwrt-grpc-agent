# Copyright 2018 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# cmake build file for C++ grpc_exec example.
# Assumes protobuf and gRPC have been installed using cmake.
# See cmake_externalproject/CMakeLists.txt for all-in-one cmake build
# that automatically builds all the dependencies before building grpc_exec.

cmake_minimum_required(VERSION 3.5.1)

project(grpc_exec C CXX)

include(cmake/common.cmake)

# Proto file
get_filename_component(ge_proto "./grpc_exec.proto" ABSOLUTE)
get_filename_component(ge_proto_path "${ge_proto}" PATH)

# Generated sources
set(ge_proto_srcs "${CMAKE_CURRENT_BINARY_DIR}/grpc_exec.pb.cc")
set(ge_proto_hdrs "${CMAKE_CURRENT_BINARY_DIR}/grpc_exec.pb.h")
set(ge_grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/grpc_exec.grpc.pb.cc")
set(ge_grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/grpc_exec.grpc.pb.h")
add_custom_command(
      OUTPUT "${ge_proto_srcs}" "${ge_proto_hdrs}" "${ge_grpc_srcs}" "${ge_grpc_hdrs}"
      COMMAND ${_PROTOBUF_PROTOC}
      ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
        --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
        -I "${ge_proto_path}"
        --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
        "${ge_proto}"
      DEPENDS "${ge_proto}")

# Include generated *.pb.h files
include_directories("${CMAKE_CURRENT_BINARY_DIR}")

# ge_grpc_proto
add_library(ge_grpc_proto
  ${ge_grpc_srcs}
  ${ge_grpc_hdrs}
  ${ge_proto_srcs}
  ${ge_proto_hdrs})
target_link_libraries(ge_grpc_proto
  ${_REFLECTION}
  ${_GRPC_GRPCPP}
  ${_PROTOBUF_LIBPROTOBUF})

# Targets greeter_[async_](client|server)
foreach(_target
  grpc_exec)
  add_executable(${_target} "${_target}.cc")
  target_link_libraries(${_target}
    ge_grpc_proto
    ${_REFLECTION}
    ${_GRPC_GRPCPP}
    ${_PROTOBUF_LIBPROTOBUF})
endforeach()
