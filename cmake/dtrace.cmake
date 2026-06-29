# Build the USDT probes from a provider definition for toolchains whose
# <sys/sdt.h> lacks SystemTap's inline DTRACE_PROBE: dtrace -h emits the probe
# header and dtrace -G turns the probe objects into a DOF object to link in.

find_program(DTRACE dtrace)

# -xnolibs skips the D library files a USDT provider build doesn't need.
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(DTRACE_FLAGS "-xnolibs -64")
else()
  set(DTRACE_FLAGS "-xnolibs -32")
endif()

function(dtrace_header provider out_header)
  add_custom_command(
    OUTPUT ${out_header}
    COMMAND ${DTRACE} -h -s ${provider} -o ${out_header}
    DEPENDS ${provider})
endfunction()

# Turn ${lib}'s probe objects into a DOF object, returning its path in ${out}.
function(dtrace_provider_object out lib provider)
  set(dof ${CMAKE_CURRENT_BINARY_DIR}/${lib}_dtrace.o)
  set(objdir ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${lib}.dir)
  set(tmp ${CMAKE_CURRENT_BINARY_DIR}/${lib}_dtrace.objs)
  # Copy first because dtrace -G rewrites the objects it reads; the shell globs
  # *.o at build time, which configure-time file(GLOB) cannot.
  add_custom_command(
    OUTPUT ${dof}
    COMMAND sh -c "rm -rf ${tmp} && mkdir ${tmp} && cp ${objdir}/*.o ${tmp}/ && ${DTRACE} ${DTRACE_FLAGS} -G -s ${provider} -o ${dof} ${tmp}/*.o"
    DEPENDS ${lib} ${provider})
  set(${out} ${dof} PARENT_SCOPE)
endfunction()
