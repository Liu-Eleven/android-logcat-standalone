
## workflow
### logd
**logd/main.cpp**

1. system calls such as sched_setscheduler need root authority, so must use "sudo" to run "./logd" or it finished with return -1;
2. init LogBuffer that holds the log entries and inited with LastLogTimes;
3. call LogReader inited with LogBuffer and create socket_local_server(PREFIX"logdr", ...), and then if new log entries come to LogBuffer, it will be notified and send data from LogBuffer to the socket, a client(logcat) can read from the socket after connects and send signal message;(logd/LogReader.cpp)
4. call LogListener inited with LogBuffer and LogReader and creates socket_local_server(PREFIX"logdw", ...), and then if recvmsg() from socket, it add log entries to the LogBuffer and notify LogReader; (logd/LogListener.cpp)
5. call CommandListener inited with LogBuffer & LogReader & LogListener and creates socket_local_server(PREFIX"logd", ...), and then if new command come from socket, it returns the result or error of the command;(logd/CommandListener.cpp)
6. after get times and start listeners, call chmod to change the socket files authorities(rwx) because without this step, log and logcat can't read or write the socket created by root;
7. call pause() to make logd process stay at the background(intend to be a service in android);

### log
**test/log/log.c**

1. use __android_log_print();(liblog/logd_write.c)
2. call __android_log_buf_write();
3. call write_to_log() = __write_to_log_init;
4. call __write_to_log_initialize() and create socket named "/tmp/logdw" and get log_fd;
5. __write_to_log_null/kernel();
6. if direct to kernel, call writev();(liblog/uio.c)
7. system call write() and write data to log_fd that means the socket;

### logcat
**logcat/logcat.cpp**

1. the read device:init the basic device(system, main e.t.c) if it matches, and then add the appointed device;
2. open the device and get prepared for read, call android_logger_clear() e.t.c, means call socket_local_client("logd", ...) get a socket connected, and send commands buffer to socket;(liblog/log_read.c)
3. loop(all devices contains a logger_list in order to know who is reading)
  call android_logger_list_read():
  if logger_list->sock isn't inited, call socket_local_client("logdr", ...) get a socket connected, and send signal   message to notify server;
  using recv() read log entries from socket to get the log_msg;(liblog/log_read.c)
  call android::processBuffer() to read log buffer from log_msg, and then write buffer data to fd(fd is appointed or default to file cmdline);
  call android_log_printLogLine();(liblog/logprint.c)
  system call write() write data to fd;
end

## worklist

### libcutils
**socket_local.h**

1. redirect macro from /dev/socket/ to /tmp/;

### liblog
**log_read.c**

1. add _GNU_SOURCE macro in order to use TEMP_FAILURE_RETRY(redo the system call that get EINTR error                    until it success); 
2. redirect macro from /dev/socket/ to /tmp/;
3. using getpagesize() to get page size(in unistd.h), don't use PAGE_SIZE macro;

**logd_write.c**

1. redirect macro from /dev/socket/logdw to /tmp/logdw;
2. include \<sys/syscall.h\> to use syscall(SYS_gettid) instead of gettid() to get the true thread id;

### libsysutils/src
**SocketClient.cpp**

1. include \<cstdlib\> in order to use malloc() and free();

### logd
**LogStatistics.cpp**

1. include \<cstdlib\> and \<signal.h\> in order to use free() and kill();

**LogWhiteBlackList.cpp**

1. include \<cstdlib\> in order to use free();

**LogBuffer.cpp**

1. include \<limits.h\>, delete \<cutils/properties.h\>;
2. delete property_get_size()(no any properties);
3. delete properties related codes in LogBuffer constructed function, onlu use setSize() to set log buffer size;

**main.cpp**

1. delete two useless head files;
2. delete process capability related codes in drop_privs()(no use of android capability on linux);
3. delete property_get_bool(), no any properties;
4. delete process capability related codes in main;
5. add chmod() for logd & logdr & logdw in main to make them can be read and writed for all users;

### toolbox
**log.c**

1. add method to count time;
2. change usage() for new options;
3. change log_main() to main() to build a command;
4. change main() for new options and show count time result;

## references
**android source code**
### /bionic/libc/string/
### /system/core/
- include/
- libcutils/
- liblog/
- libsysutils/
- libutils/
- logcat/
- logd/
- toolbox/ 
