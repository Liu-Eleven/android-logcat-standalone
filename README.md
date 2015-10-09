android-logcat-standalone
=========================

standalone logcat from android that could run on pure Linux.

### How to build:

```
mkdir out
cd out
source  ../build/envs/envsetup_local.sh
cmake ..
make
```

### Code From:

The source code of logcat are copied from AOSP

https://android.googlesource.com/android-5.1.0_r1

### Why logcat
The main purpose of logcat is performance. 

printf costs about 3ms each time on some platforms. So we have to disable most logs. But without them, debug will be very difficult especially when the issue is difficult to repeat.

High performance logcat helps us  enable all logs.

