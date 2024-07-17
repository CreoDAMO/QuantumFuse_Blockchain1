# Install script for directory: /home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/cmake

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libprotobuf-lite" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/libprotobuf-lited.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libprotobuf" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/libprotobufd.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libprotoc" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/libprotocd.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protoc" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/protoc-3.19.4.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/protoc"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "$ORIGIN/../lib")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES
    "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/protoc-3.19.4.0"
    "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/protoc"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/protoc-3.19.4.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/protoc"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "::::::::::::::"
           NEW_RPATH "$ORIGIN/../lib")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES
    "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/protobuf.pc"
    "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/protobuf-lite.pc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "any.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/any.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "any.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/any.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "api.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/api.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "arena.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/arena.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "arena_impl.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/arena_impl.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "arenastring.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/arenastring.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "code_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/code_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "command_line_interface.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/command_line_interface.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/cpp" TYPE FILE RENAME "cpp_file.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/cpp/cpp_file.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/cpp" TYPE FILE RENAME "cpp_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/cpp/cpp_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/cpp" TYPE FILE RENAME "cpp_helpers.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/cpp/cpp_helpers.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/cpp" TYPE FILE RENAME "cpp_names.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/cpp/cpp_names.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/csharp" TYPE FILE RENAME "csharp_doc_comment.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/csharp/csharp_doc_comment.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/csharp" TYPE FILE RENAME "csharp_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/csharp/csharp_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/csharp" TYPE FILE RENAME "csharp_names.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/csharp/csharp_names.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/csharp" TYPE FILE RENAME "csharp_options.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/csharp/csharp_options.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "importer.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/importer.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/java" TYPE FILE RENAME "java_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/java/java_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/java" TYPE FILE RENAME "java_kotlin_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/java/java_kotlin_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/java" TYPE FILE RENAME "java_names.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/java/java_names.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/js" TYPE FILE RENAME "js_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/js/js_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/objectivec" TYPE FILE RENAME "objectivec_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/objectivec/objectivec_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/objectivec" TYPE FILE RENAME "objectivec_helpers.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/objectivec/objectivec_helpers.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "parser.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/parser.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/php" TYPE FILE RENAME "php_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/php/php_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "plugin.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/plugin.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "plugin.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/plugin.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/python" TYPE FILE RENAME "python_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/python/python_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler/ruby" TYPE FILE RENAME "ruby_generator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/ruby/ruby_generator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "descriptor.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/descriptor.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "descriptor.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/descriptor.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "descriptor_database.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/descriptor_database.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "duration.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/duration.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "dynamic_message.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/dynamic_message.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "empty.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/empty.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "explicitly_constructed.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/explicitly_constructed.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "extension_set.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/extension_set.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "extension_set_inl.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/extension_set_inl.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "field_access_listener.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/field_access_listener.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "field_mask.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/field_mask.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_enum_reflection.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_enum_reflection.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_enum_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_enum_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_bases.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_bases.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_reflection.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_reflection.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_table_driven.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_table_driven.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_table_driven_lite.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_table_driven_lite.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_tctable_decl.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_tctable_decl.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_tctable_impl.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_tctable_impl.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_tctable_impl.inc" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_tctable_impl.inc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "generated_message_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/generated_message_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "has_bits.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/has_bits.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "implicit_weak_message.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/implicit_weak_message.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "inlined_string_field.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/inlined_string_field.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "coded_stream.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/coded_stream.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "gzip_stream.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/gzip_stream.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "io_win32.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/io_win32.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "printer.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/printer.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "strtod.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/strtod.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "tokenizer.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/tokenizer.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "zero_copy_stream.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/zero_copy_stream.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "zero_copy_stream_impl.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/zero_copy_stream_impl.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/io" TYPE FILE RENAME "zero_copy_stream_impl_lite.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/io/zero_copy_stream_impl_lite.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "map.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/map.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "map_entry.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/map_entry.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "map_entry_lite.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/map_entry_lite.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "map_field.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/map_field.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "map_field_inl.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/map_field_inl.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "map_field_lite.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/map_field_lite.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "map_type_handler.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/map_type_handler.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "message.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/message.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "message_lite.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/message_lite.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "metadata.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/metadata.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "metadata_lite.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/metadata_lite.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "parse_context.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/parse_context.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "port.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/port.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "port_def.inc" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/port_def.inc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "port_undef.inc" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/port_undef.inc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "reflection.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/reflection.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "reflection_ops.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/reflection_ops.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "repeated_field.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/repeated_field.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "repeated_ptr_field.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/repeated_ptr_field.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "service.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/service.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "source_context.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/source_context.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "struct.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/struct.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "bytestream.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/bytestream.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "callback.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/callback.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "casts.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/casts.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "common.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/common.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "hash.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/hash.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "logging.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/logging.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "macros.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/macros.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "map_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/map_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "mutex.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/mutex.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "once.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/once.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "platform_macros.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/platform_macros.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "port.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/port.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "status.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/status.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "stl_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/stl_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "stringpiece.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/stringpiece.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "strutil.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/strutil.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/stubs" TYPE FILE RENAME "template_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/stubs/template_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "text_format.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/text_format.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "timestamp.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/timestamp.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "type.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/type.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "unknown_field_set.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/unknown_field_set.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "delimited_message_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/delimited_message_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "field_comparator.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/field_comparator.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "field_mask_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/field_mask_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "json_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/json_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "message_differencer.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/message_differencer.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "time_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/time_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "type_resolver.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/type_resolver.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/util" TYPE FILE RENAME "type_resolver_util.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/util/type_resolver_util.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "wire_format.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/wire_format.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "wire_format_lite.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/wire_format_lite.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "wrappers.pb.h" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/wrappers.pb.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "any.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/any.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "api.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/api.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "plugin.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/plugin.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "descriptor.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/descriptor.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "duration.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/duration.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "empty.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/empty.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "field_mask.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/field_mask.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "source_context.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/source_context.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "struct.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/struct.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "timestamp.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/timestamp.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "type.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/type.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "wrappers.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/wrappers.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "any.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/any.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "api.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/api.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf/compiler" TYPE FILE RENAME "plugin.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/compiler/plugin.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "descriptor.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/descriptor.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "duration.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/duration.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "empty.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/empty.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "field_mask.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/field_mask.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "source_context.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/source_context.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "struct.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/struct.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "timestamp.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/timestamp.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "type.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/type.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-protos" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/google/protobuf" TYPE FILE RENAME "wrappers.proto" FILES "/home/runner/QuantumFuseBlockchain-2/.cargo/registry/src/index.crates.io-6f17d22bba15001f/prost-build-0.10.4/third-party/protobuf/src/google/protobuf/wrappers.proto")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-export" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf/protobuf-targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf/protobuf-targets.cmake"
         "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/CMakeFiles/Export/5a0f10ea4324979995731323bb365f6f/protobuf-targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf/protobuf-targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf/protobuf-targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf" TYPE FILE FILES "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/CMakeFiles/Export/5a0f10ea4324979995731323bb365f6f/protobuf-targets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf" TYPE FILE FILES "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/CMakeFiles/Export/5a0f10ea4324979995731323bb365f6f/protobuf-targets-debug.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "protobuf-export" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf" TYPE DIRECTORY FILES "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/lib/cmake/protobuf/" REGEX "/protobuf\\-targets\\.cmake$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/runner/QuantumFuseBlockchain-2/QuantumFuse/core/target/debug/build/prost-build-2bd58281f5abf2ca/out/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
