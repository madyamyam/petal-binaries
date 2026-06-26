# consider just downloading from releases

choco install nasm webp # webp lib needed?

$windows_install_root='install/windows-x86_64'
$windows_install_lib="$windows_install_root/lib" # /Release/lib dear msvc i beseech you let this be the right directory
$windows_bin_root='bin/windows-x86_64'
mkdir -p $windows_bin_root

$sdl_flags_common=@('-DBUILD_SHARED_LIBS=ON','-DCMAKE_BUILD_TYPE=RELEASE')
$sdl_flags=('-DSDL_TEST_LIBRARY=OFF','-DSDL_TESTS=OFF','-DSDL_INSTALL_TESTS=OFF','-DSDL_TESTS_LINK_SHARED=OFF','-DSDL_EXAMPLES=OFF','-DSDL_EXAMPLES_LINK_SHARED=OFF','-DSDL_INSTALL=ON')
# only support jpg, png, svg(?), webp
$sdl_image_flags=@('-DSDLIMAGE_STRICT=ON','-DSDLIMAGE_INSTALL_CPACK=OFF','-DSDLIMAGE_INSTALL_MAN=OFF','-DSDLIMAGE_DEPS_SHARED=OFF','-DSDLIMAGE_VENDORED=ON','-DSDLIMAGE_SAMPLES=OFF','-DSDLIMAGE_ANI=OFF','-DSDLIMAGE_AVIF=OFF','-DSDLIMAGE_BMP=OFF','-DSDLIMAGE_GIF=OFF','-DSDLIMAGE_JXL=OFF','-DSDLIMAGE_LBM=OFF','-DSDLIMAGE_PCX=OFF','-DSDLIMAGE_PNM=OFF','-DSDLIMAGE_QOI=OFF','-DSDLIMAGE_TGA=OFF','-DSDLIMAGE_TIF=OFF','-DSDLIMAGE_XCF=OFF','-DSDLIMAGE_XPM=OFF','-DSDLIMAGE_XV=OFF','-DSDLIMAGE_INSTALL=ON')
$sdl_mixer_flags=@('-DSDLMIXER_STRICT=ON','-DSDLMIXER_INSTALL_CPACK=OFF','-DSDLMIXER_INSTALL_MAN=OFF','-DSDLMIXER_DEPS_SHARED=OFF','-DSDLMIXER_VENDORED=ON','-DSDLMIXER_SAMPLES=OFF','-DSDLMIXER_FLAC=ON','-DSDLMIXER_MOD=OFF','-DSDLMIXER_MP3=ON','-DSDLMIXER_MIDI=ON','-DSDLMIXER_OPUS=ON','-DSDLMIXER_WAVPACK=OFF','-DSDLMIXER_INSTALL=OFF')
$sdl_ttf_flags=@('-DSDLTTF_STRICT=ON','-DSDLTTF_INSTALL_CPACK=OFF','-DSDLTTF_INSTALL_MAN=OFF','-DSDLTTF_VENDORED=ON','-DSDLTTF_SAMPLES=OFF','-DSDLTTF_INSTALL=OFF')
# BUILD_SHARED_LIBS is set to OFF when using vendored dependencies with DXC enabled
$sdl_shadercross_flags=@('-DSDLSHADERCROSS_DXC=ON','-DSDLSHADERCROSS_SHARED=ON','-DSDLSHADERCROSS_STATIC=OFF','-DSDLSHADERCROSS_SPIRVCROSS_SHARED=OFF','-DSDLSHADERCROSS_VENDORED=ON','-DSDLSHADERCROSS_CLI=OFF','-DSDLSHADERCROSS_INSTALL_CPACK=OFF','-DSDLSHADERCROSS_INSTALL_MAN=OFF','-DSDLSHADERCROSS_INSTALL=ON','-DSDLSHADERCROSS_INSTALL_RUNTIME=ON')

$sdl_flags = $($sdl_flags; $sdl_flags_common)
$sdl_image_flags = $($sdl_image_flags; $sdl_flags_common)
$sdl_mixer_flags = $($sdl_mixer_flags; $sdl_flags_common)
$sdl_ttf_flags = $($sdl_ttf_flags; $sdl_flags_common)
$sdl_shadercross_flags = $($sdl_shadercross_flags; $sdl_flags_common)

# SDL
cmake -S SDL -B sdl-build-release $sdl_flags[0..$sdl_flags.Count]
cmake --build sdl-build-release  --target install --config Release
cmake --install sdl-build-release --prefix $windows_install_root

strip -S "$windows_install_lib/SDL3.dll"
cp "$windows_install_lib/SDL3.dll" $windows_bin_root/

# SDL_image
cmake -S SDL_image sdl_image-build-release $sdl_image_flags[0..$sdl_image_flags.Count]
cmake --build sdl_image-build-release --config Release
cmake --install sdl_image-build-release --prefix $windows_install_root

strip "$windows_install_lib/SDL3_image.dll"
cp "$windows_install_lib/SDL3_image.dll" $windows_bin_root/

# SDL_mixer
cmake -S SDL_mixer sdl_mixer-build-release $sdl_mixer_flags[0..$sdl_mixer_flags.Count]
cmake --build sdl_mixer-build-release --config Release
cmake --install sdl_mixer-build-release --prefix $windows_install_root

strip "$windows_install_lib/SDL3_mixer.dll"
cp "$windows_install_lib/SDL3_mixer.dll" $windows_bin_root/

# SDL_ttf
cmake -S SDL_ttf sdl_ttf-build-release $sdl_ttf_flags[0..$sdl_ttf_flags.Count]
cmake --build sdl_ttf-build-release --config Release
cmake --install sdl_ttf-build-release --prefix $windows_install_root

strip "$windows_install_lib/SDL3_ttf.dll"
cp "$windows_install_lib/SDL3_ttf.dll" $windows_bin_root/

# SDL_shadercross
# we won't be using DXBC
cmake -S SDL_shadercross sdl_shadercross-build-release $sdl_shadercross_flags[0..$sdl_shadercross_flags.Count]
cmake --build sdl_shadercross-build-release --config Release
cmake --install sdl_shadercross-build-release --prefix $windows_install_root

strip "$windows_install_lib/SDL3_shadercross.dll"
cp "$windows_install_lib/SDL3_shadercross.dll" $windows_bin_root/

strip "$windows_install_lib/dxcompiler.dll"
cp "$windows_install_lib/dxcompiler" $windows_bin_root/

strip "$windows_install_lib/dxil.dll"
cp "$windows_install_lib/dxil.dll" $windows_bin_root/
