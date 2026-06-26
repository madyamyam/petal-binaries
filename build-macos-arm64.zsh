#!/bin/bash

# perl is needed for json when compiling vkd3d, hopefully it includes the json part...
yes | brew install nasm bash perl # plutosvg webp libvorbis opus opusfile flac

macos_install_root='install/macos-arm64'
macos_install_lib="$macos_install_root/lib"
macos_bin_root='bin/macos-arm64'
mkdir -p $macos_bin_root

sdl_flags_common=('-DBUILD_SHARED_LIBS=ON' '-DCMAKE_BUILD_TYPE=RELEASE')
sdl_flags=('-DSDL_TEST_LIBRARY=OFF' '-DSDL_TESTS=OFF' '-DSDL_INSTALL_TESTS=OFF' '-DSDL_TESTS_LINK_SHARED=OFF' '-DSDL_EXAMPLES=OFF' '-DSDL_EXAMPLES_LINK_SHARED=OFF' '-DSDL_INSTALL=ON')
# only support jpg, png, svg(?), webp
# seemingly only on macos are the format options being ignored
sdl_image_flags=('-DSDLIMAGE_STRICT=ON' '-DSDLIMAGE_INSTALL_CPACK=OFF' '-DSDLIMAGE_INSTALL_MAN=OFF' '-DSDLIMAGE_DEPS_SHARED=OFF' '-DSDLIMAGE_VENDORED=ON' '-DSDLIMAGE_SAMPLES_INSTALL=OFF' '-DSDLIMAGE_ANI=OFF' '-DSDLIMAGE_AVIF=OFF' '-DSDLIMAGE_BMP=OFF' '-DSDLIMAGE_GIF=OFF' '-DSDLIMAGE_JXL=OFF' '-DSDLIMAGE_LBM=OFF' '-DSDLIMAGE_PCX=OFF' '-DSDLIMAGE_PNM=OFF' '-DSDLIMAGE_QOI=OFF' '-DSDLIMAGE_TGA=OFF' '-DSDLIMAGE_TIF=OFF' '-DSDLIMAGE_XCF=OFF' '-DSDLIMAGE_XPM=OFF' '-DSDLIMAGE_XV=OFF' '-DSDLIMAGE_INSTALL=ON')
sdl_mixer_flags=('-DSDLMIXER_STRICT=ON' '-DSDLMIXER_INSTALL_CPACK=OFF' '-DSDLMIXER_INSTALL_MAN=OFF' '-DSDLMIXER_DEPS_SHARED=OFF' '-DSDLMIXER_VENDORED=ON' '-DSDLMIXER_SAMPLES_INSTALL=OFF' '-DSDLMIXER_FLAC=ON' '-DSDLMIXER_MOD=OFF' '-DSDLMIXER_MP3=ON' '-DSDLMIXER_MIDI=ON' '-DSDLMIXER_OPUS=ON' '-DSDLMIXER_WAVPACK=OFF' '-DSDLMIXER_INSTALL=ON')
sdl_ttf_flags=('-DSDLTTF_STRICT=ON' '-DSDLTTF_INSTALL_CPACK=OFF' '-DSDLTTF_INSTALL_MAN=OFF' '-DSDLTTF_VENDORED=ON' '-DSDLTTF_SAMPLES_INSTALL=OFF' '-DSDLTTF_INSTALL=ON')
# BUILD_SHARED_LIBS is set to OFF when using vendored dependencies with DXC enabled
sdl_shadercross_flags=('-DSDLSHADERCROSS_DXC=ON' '-DSDLSHADERCROSS_SHARED=ON' '-DSDLSHADERCROSS_STATIC=OFF' '-DSDLSHADERCROSS_SPIRVCROSS_SHARED=OFF' '-DSDLSHADERCROSS_VENDORED=ON' '-DSDLSHADERCROSS_CLI=OFF''-DSDLSHADERCROSS_INSTALL_CPACK=OFF' '-DSDLSHADERCROSS_INSTALL_MAN=OFF' '-DSDLSHADERCROSS_INSTALL_RUNTIME=ON' '-DSDLSHADERCROSS_INSTALL=ON' '-DSDLSHADERCROSS_INSTALL_RUNTIME=ON')

sdl_flags+=("${sdl_flags_common[@]}")
sdl_image_flags+=("${sdl_flags_common[@]}")
sdl_mixer_flags+=("${sdl_flags_common[@]}")
sdl_ttf_flags+=("${sdl_flags_common[@]}")
sdl_shadercross_flags+=("${sdl_flags_common[@]}")

# SDL
cmake -S SDL -B sdl-build-release "${sdl_flags[@]}"
echo $GH_PASSWD | sudo cmake --build sdl-build-release --target install --config Release # bypasses installation privilege issue
cmake --install sdl-build-release --prefix $macos_install_root

strip -S "$macos_install_lib/libSDL3.dylib"
cp "$macos_install_lib/libSDL3.dylib" $macos_bin_root/

# SDL_image
cmake -S SDL_image sdl_image-build-release "${sdl_image_flags[@]}"
cmake --build sdl_image-build-release --config Release
cmake --install sdl_image-build-release --prefix $macos_install_root

strip -S "$macos_install_root/libSDL3_image.dylib"
cp "$macos_install_lib/libSDL3_image.dylib" $macos_bin_root/

# SDL_mixer
cmake -S SDL_mixer sdl_mixer-build-release "${sdl_mixer_flags[@]}"
cmake --build sdl_mixer-build-release --config Release
cmake --install sdl_mixer-build-release --prefix $macos_install_root

strip -S "$macos_install_lib/libSDL3_mixer.dylib"
cp "$macos_install_lib/libSDL3_mixer.dylib" $macos_bin_root/

# SDL_ttf
cmake -S SDL_ttf sdl_ttf-build-release "${sdl_ttf_flags[@]}"
cmake --build sdl_ttf-build-release --config Release
cmake --install sdl_ttf-build-release --prefix $macos_install_root

strip -S "$macos_install_lib/libSDL3_ttf.dylib"
cp "$macos_install_lib/libSDL3_ttf.dylib" $macos_bin_root/

# SDL_shadercross
# we won't be using DXBC, don't include libvkd3d-utils
cmake -S SDL_shadercross sdl_shadercross-build-release "${sdl_shadercross_flags[@]}"
cmake --build sdl_shadercross-build-release --config Release
cmake --install sdl_shadercross-build-release --prefix $macos_install_root

strip -S "$macos_install_lib/libSDL3_shadercross.dylib"
cp $macos_install_lib"/libSDL3_shadercross.dylib" $macos_bin_root/

strip -S "$macos_install_lib/libdxcompiler.dylib"
cp "$macos_install_lib/libdxcompiler.dylib" $macos_bin_root/

strip -S "$macos_install_lib/libdxcompiler.dylib"
cp "$macos_install_lib"/libdxcompiler.dylib $macos_bin_root/

strip -S "$macos_install_lib/libdxil.dylib"
cp "$macos_install_lib"/libdxil.dylib $macos_bin_root/
