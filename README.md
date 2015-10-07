# android-logcat-standalone
## target
**To migrate logcat system from android to linux.**
## workflow
### logd
logd/main.cpp
1. system calls such as sched_setscheduler need root authority, so must use "sudo" to run "./logd" or it finished with return -1;
2. init LogBuffer that holds the log entries and inited with LastLogTimes;
3. call LogReader inited with LogBuffer and create socket_local_server(PREFIX"logdr", ...), and then if new log entries come to LogBuffer, it will be notified and send data from LogBuffer to the socket, a client(logcat) can read from the socket after connects and send signal message;(logd/LogReader.cpp)
4. call LogListener inited with LogBuffer and LogReader and connects socket_local_server(PREFIX"logdw", ...),
    and then if recvmsg() from socket, it add log entries to the LogBuffer and notify LogReader; (logd/LogListener.cpp)
5. call CommandListener inited with LogBuffer & LogReader & LogListener and creates socket_local_server(PREFIX"logd", ...),
    and then if new command come from socket, it returns the result or error of the command; (logd/CommandListener.cpp)
6. after get times and start listeners, call chmod to change the socket files authorities(rwx);
7. call pause() to make logd process stay at the background(intend to be a service in android);
### log
log:(log.c)
1. use __android_log_print();(liblog/logd_write.c)
2. call __android_log_buf_write();
3. call write_to_log() = __write_to_log_init;
4. call __write_to_log_initialize() and create socket named "/tmp/logdw" and get log_fd;
5. __write_to_log_null/kernel();
6. if direct to kernel, call writev();(liblog/uio.c)
7. system call write() and write data to log_fd that means the socket;
### logcat
logcat:(logcat.cpp)
1. the read device:init the basic device(system, main e.t.c) if it matches,
    and then add the appointed device;
2. open the device and get prepared for read,
    call android_logger_clear() e.t.c, means call socket_local_client("logd", ...) get a socket connected,
	and send commands buffer to socket;(liblog/log_read.c)
loop(all devices contains a logger_list in order to know who is reading)
3. call android_logger_list_read():
    if logger_list->sock isn't inited, call socket_local_client("logdr", ...) get a socket connected,
	and send signal message to notify server;
    using recv() read log entries from socket to get the log_msg;(liblog/log_read.c)
4. call android::processBuffer() to read log buffer from log_msg,
    and then write buffer data to fd(fd is appointed or default to file cmdline);
5. call android_log_printLogLine();(liblog/logprint.c)
6. system call write() write data to fd;
end
## worklist
1.libcutils：
    socket_local.h：修改原本指向/dev/socket/的宏定义指向/tmp/；
2.liblog：
    log_read.c：增加_GNU_SOURCE宏定义，引入TEMP_FAILURE_RETRY（重做产生EINTR错误的系统调用直到成功为止）（不添加该宏定义则缺少相关定义）；
	修改原本指向/dev/socket/的宏定义指向/tmp/；
	通过getpagesize()获得系统分页大小（在unistd.h中），不使用PAGE_SIZE宏定义；
    logd_write.c：修改原本指向/dev/socket/logdw的宏定义指向/tmp/logdw；
	#include <sys/syscall.h>头文件调用syscall(SYS_gettid)取代gettid()获得线程真实线程号；
3.libsysutils/src：
    SocketClient.cpp：引入头文件<cstdlib>，需要使用malloc()和free()；
3.logd：
    LogStatistics.cpp：引入头文件<cstdlib>和<signal.h>，需要使用free()和kill()；
    LogWhiteBlackList.cpp：引入头文件<cstdlib>，需要使用free()；
    LogBuffer.cpp：#include <limits.h>，删除<cutils/properties.h>头文件；
	注销property_get_size方法（不存在property）；
	注销LogBuffer构造函数property相关部分代码，仅保留setSize()设置缓冲区大小的代码；
    main.cpp：注销两个无用头文件；
	注销drop_privs方法关于设置进程能力的代码（弃用android的capability机制，不设置权限）；
	注销property_get_bool方法，不需要判断权限属性（不存在property）；
	注销main方法中关于权限属性的代码；
	在main中新增修改套接字文件读写权限的代码，logd/logdr所有人可读可写，logdw所有人可读可写可执行；
4.toolbox：
    log.c：增加计时方法；
	修改usage方法；
	变log_main为main生成命令；
	在main中针对新增参数做相应修改，并且进行计时和显示结果操作；
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
