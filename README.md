# cv32e40p-teardown

Simple verification environment for CV32E40P using Verilator.

## Quick-start

1. Clone the repo
```
git clone https://github.com/aedalzotto/cv32e40p-teardown.git --recurse-submodules && cd cv32e40p-teardown
```
2. Run it
```
make
```
3. To create another test, make a folder in software/programs with its source files. Pass the desired program to make:
```
make TEST=fibonacci
```

## Dependencies

### CentOS 7

1. Enable centos-release-scl
```
# yum install centos-release-scl
```
2. Install latest GCC
```
# yum install devtoolset-11
```
3. Enable it for all you user sessions in `.bashrc`
```
echo "source /opt/rh/devtoolset-11/enable\n" >> ~/.bashrc
```
4. Get Verilator source code
```
git clone https://github.com/verilator/verilator && cd verilator
```
5. Checkout to latest version
```
git checkout v4.220
```
6. Configure to install locally
```
./configure --prefix=~/.local/verilator
```
7. Build
```
make -j`nproc`
```
8. Install
```
make install
```
9. Enable it for all you user sessions in `.bashrc`
```
echo "export VERILATOR_ROOT=~/.local/verilator\nexport PATH=$VERILATOR_ROOT/bin:$PATH\nexport MANPATH=$VERILATOR_ROOT/share/man:$MANPATH\nexport PKG_CONFIG_PATH=$VERILATOR_ROOT/share/pkgconfig:$PKG_CONFIG_PATH\n" >> ~/.bashrc
```
10. Download RISC-V toolchain
```
wget https://buildbot.embecosm.com/job/corev-gcc-centos7/3/artifact/corev-openhw-gcc-centos7-20211104.tar.gz
```
11. Extract it
```
tar xvf corev-openhw-gcc-centos7-20211104.tar.gz ~/.local/corev-openhw-gcc
```
12. Enable it for all you user sessions in `.bashrc`
```
echo "export CV_SW_TOOLCHAIN=~/.local/corev-openhw-gcc\nexport CV_SW_PREFIX=riscv32-corev-elf-\nexport PATH=$CV_SW_TOOLCHAIN/bin:$PATH\nn" >> ~/.bashrc
```

### Arch Linux
1. Install the packages
```
# pacman -S verilator riscv-elf-gcc
```
