#!/bin/bash
# consider just downloading from releases

choco install nasm webp

windows_bin_root='bin/windows-x86_64'
mkdir -p $windows_bin_root

sdl_flags_common='-DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RELEASE'
sdl_flags='-DSDL_INSTALL=ON -DSDL_TEST_LIBRARY=OFF -DSDL_TESTS=OFF -DSDL_INSTALL_TESTS=OFF -DSDL_TESTS_LINK_SHARED=OFF -DSDL_EXAMPLES=OFF -DSDL_EXAMPLES_LINK_SHARED=OFF'
# only support jpg, png, svg(?), webp
sdl_image_flags='-DSDLIMAGE_STRICT=ON -DSDLIMAGE_INSTALL=OFF -DSDLIMAGE_INSTALL_CPACK=OFF -DSDLIMAGE_INSTALL_MAN=OFF -DSDLIMAGE_DEPS_SHARED=OFF -DSDLIMAGE_VENDORED=ON -DSDLIMAGE_SAMPLES_INSTALL=OFF -DSDLIMAGE_ANI=OFF -DSDLIMAGE_AVIF=OFF -DSDLIMAGE_BMP=OFF -DSDLIMAGE_GIF=OFF -DSDLIMAGE_JXL=OFF -DSDLIMAGE_LBM=OFF -DSDLIMAGE_PCX=OFF -DSDLIMAGE_PNM=OFF -DSDLIMAGE_QOI=OFF -DSDLIMAGE_TGA=OFF -DSDLIMAGE_TIF=OFF -DSDLIMAGE_XCF=OFF -DSDLIMAGE_XPM=OFF -DSDLIMAGE_XV=OFF'
sdl_mixer_flags='-DSDLMIXER_STRICT=ON -DSDLMIXER_INSTALL=OFF -DSDLMIXER_INSTALL_CPACK=OFF -DSDLMIXER_INSTALL_MAN=OFF -DSDLMIXER_DEPS_SHARED=OFF -DSDLMIXER_VENDORED=ON -DSDLMIXER_SAMPLES_INSTALL=OFF -DSDLMIXER_FLAC=ON -DSDLMIXER_MOD=OFF -DSDLMIXER_MP3=ON -DSDLMIXER_MIDI=ON -DSDLMIXER_OPUS=ON -DSDLMIXER_WAVPACK=OFF'
sdl_ttf_flags='-DSDLTTF_STRICT=ON -DSDLTTF_INSTALL=OFF -DSDLTTF_INSTALL_CPACK=OFF -DSDLTTF_INSTALL_MAN=OFF -DSDLTTF_VENDORED=ON -DSDLTTF_SAMPLES_INSTALL=OFF'
# BUILD_SHARED_LIBS is set to OFF when using vendored dependencies with DXC enabled
sdl_shadercross_flags='-DSDLSHADERCROSS_DXC=ON -DSDLSHADERCROSS_SHARED=ON -DSDLSHADERCROSS_STATIC=OFF -DSDLSHADERCROSS_SPIRVCROSS_SHARED=OFF -DSDLSHADERCROSS_VENDORED=ON -DSDLSHADERCROSS_CLI=OFF -DSDLSHADERCROSS_INSTALL=OFF -DSDLSHADERCROSS_INSTALL_CPACK=OFF -DSDLSHADERCROSS_INSTALL_MAN=OFF'

# SDL
cmake -S SDL -B sdl-build-release "$sdl_flags_common" "$sdl_flags"
cmake --build sdl-build-release --target install --config Release
strip -S sdl-build-release/Release/SDL3.dll
cp sdl-build-release/Release/SDL3.dll $windows_bin_root/

# SDL_image
cmake -S SDL_image sdl_image-build-release "$sdl_flags_common" "$sdl_image_flags"
cmake --build sdl_image-build-release --config Release
strip -S sdl_image-build-release/Release/SDL3_image.dll
cp sdl_image-build-release/Release/SDL3_image.dll $windows_bin_root/

# SDL_mixer
cmake -S SDL_mixer sdl_mixer-build-release "$sdl_flags_common" "$sdl_mixer_flags"
cmake --build sdl_mixer-build-release --config Release
strip -S sdl_mixer-build-release/Release/SDL3_mixer.dll
cp sdl_mixer-build-release/Release/SDL3_mixer.dll $windows_bin_root/

# SDL_ttf
cmake -S SDL_ttf sdl_ttf-build-release "$sdl_flags_common" "$sdl_ttf_flags"
cmake --build sdl_ttf-build-release --config Release
strip -S sdl_ttf-build-release/Release/SDL3_ttf.dll
cp sdl_ttf-build-release/Release/SDL3_ttf.dll $windows_bin_root/

# SDL_shadercross
cmake -S SDL_shadercross SDL_shadercross-build-release $sdl_flags_common $sdl_shadercross_flags
cmake --build SDL_shadercross-build-release --config Release
strip -S SDL_shadercross-build-release/Release/SDL3_shadercross.dll
cp SDL_shadercross-build-release/Release/SDL3_shadercross.dll $linux_bin_root/