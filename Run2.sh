sudo apt-get update -y
sudo apt install qemu-utils -y
sudo apt-get install -y qemu-system-x86-64
qemu-img create -f raw XP.img 64G
wget -O MyPal.iso 'https://drive.google.com/uc?&id=1S9TlVioj_AWcHbfaYoPd2B9GvACiIHvK&export=download'
wget -O XP.iso 'https://dl.bobpony.com/windows/xp/home/en_winxp_home_with_sp2.iso'

curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
sudo qemu-system-x86_64 \
  -m 8G \
  -cpu EPYC \
  -boot order=d \
  -drive file=XP.img \
  -drive file=XP.iso,media=cdrom \
  -drive file=MyPal.iso,media=cdrom \
  -device usb-ehci,id=usb,bus=pci.0,addr=0x4 \
  -device usb-tablet \
  -vnc :0 \
  -cpu coreduo \
  -smp sockets=1,cores=4,threads=1 \
  -vga std \
  -device rtl8139,netdev=n0 -netdev user,id=n0 \
  -accel tcg,thread=multi \
