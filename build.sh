rm -r build
rm switch-c3.elf
rm switch-c3.nro
rm switch-c3.map
rm switch-c3.nacp
c3c build
/opt/devkitpro/devkitA64/bin/aarch64-none-elf-g++ -specs=/opt/devkitpro/libnx/switch.specs -g -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE -Wl,-Map,switch-c3.map build/nswitch.a -L/opt/devkitpro/portlibs/switch/lib -L/opt/devkitpro/libnx/lib -L/opt/devkitpro/portlibs/switch/lib /opt/devkitpro/portlibs/switch/lib/libSDL2.a -fPIE -L/opt/devkitpro/libnx/lib -lEGL -lstdc++ -lglapi -ldrm_nouveau -lnx -lpthread -o /Volumes/Moon/dot/Lywx/switch-c3/switch-c3.elf
/opt/devkitpro/tools/bin/nacptool --create switch-c3 Lywx 0.1 switch-c3.nacp
/opt/devkitpro/tools/bin/elf2nro switch-c3.elf switch-c3.nro --nacp=switch-c3.nacp --romfsdir=romfs