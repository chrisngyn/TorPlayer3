ANDROID_OUT=../android/src/main/jniLibs
ANDROID_SDK := $(if $(ANDROID_SDK_ROOT),$(ANDROID_SDK_ROOT),$(HOME)/Android/Sdk)
NDK := $(if $(ANDROID_NDK_ROOT),$(ANDROID_NDK_ROOT),$(ANDROID_SDK)/ndk/23.1.7779620)
NDK_BIN=$(NDK)/toolchains/llvm/prebuilt/linux-x86_64/bin
NDK_SYSROOT=$(NDK)/toolchains/llvm/prebuilt/linux-x86_64/sysroot
LIB_NAME=libtorrent

android-armv7a:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=arm \
	GOARM=7 \
	CC=$(NDK_BIN)/armv7a-linux-androideabi21-clang \
	CXX=$(NDK_BIN)/armv7a-linux-androideabi21-clang++ \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/armeabi-v7a/${LIB_NAME}.so main.go
	cp $(NDK_SYSROOT)/usr/lib/arm-linux-androideabi/libc++_shared.so $(ANDROID_OUT)/armeabi-v7a/

android-arm64:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=arm64 \
	CC=$(NDK_BIN)/aarch64-linux-android21-clang \
	CXX=$(NDK_BIN)/aarch64-linux-android21-clang++ \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/arm64-v8a/${LIB_NAME}.so main.go
	cp $(NDK_SYSROOT)/usr/lib/aarch64-linux-android/libc++_shared.so $(ANDROID_OUT)/arm64-v8a/

android-x86:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=386 \
	CC=$(NDK_BIN)/i686-linux-android21-clang \
	CXX=$(NDK_BIN)/i686-linux-android21-clang++ \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/x86/${LIB_NAME}.so main.go
	cp $(NDK_SYSROOT)/usr/lib/i686-linux-android/libc++_shared.so $(ANDROID_OUT)/x86/

android-x86_64:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=amd64 \
	CC=$(NDK_BIN)/x86_64-linux-android21-clang \
	CXX=$(NDK_BIN)/x86_64-linux-android21-clang++ \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/x86_64/${LIB_NAME}.so main.go
	cp $(NDK_SYSROOT)/usr/lib/x86_64-linux-android/libc++_shared.so $(ANDROID_OUT)/x86_64/

android: android-armv7a android-arm64 android-x86 android-x86_64

macos:
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=arm64 \
	SDK=macos \
	go build -trimpath -buildmode=c-shared -o ${LIB_NAME}_arm64.dylib main.go
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=amd64 \
	SDK=macos \
	go build -trimpath -buildmode=c-shared -o ${LIB_NAME}_amd64.dylib main.go
	lipo \
		-create \
		${LIB_NAME}_arm64.dylib \
		${LIB_NAME}_amd64.dylib \
		-output ${LIB_NAME}.dylib
	install_name_tool -id "@rpath/libtorrent.dylib" libtorrent.dylib
	mv ${LIB_NAME}.dylib ../macos/${LIB_NAME}.dylib
	rm ${LIB_NAME}_*.h
	rm ${LIB_NAME}_*.dylib