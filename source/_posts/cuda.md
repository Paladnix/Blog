---
title: cuda
tags:
  - GPU
  - CUDA
date: 2018-09-21 13:37:29
---


任何事情都不是突然出现的，曾经有一段时间，关注了很多公众号，突然就发现有些框架和库突然就出现了并就非常热了。
但是后来渐渐发现，其实这个东西应该很早就出现了，只是那个时候还没有公众号做推力，只是在小范围内知名。
但是这突然的大热让我非常的惶恐，深深的感觉自己跟不上时代的脚步，当然实际上，我也确实没跟上。

NVIDIA 在2006年就推出了CUDA，而我知道这个东西，是在2017年。
用于使用GPU进行并行计算。使得普通搭载Geforce显卡的笔记本也具有大规模并行处理的能力。
传统的并行计算基于大规模集群的CPU进行，成本高，而使用GPU进行并行计算的成本就小很多。
CUDA的开发并不难，其提供了一个编译器，和一些C语言的库。我们使用C语言结合库，编写代码，然后使用nvcc进行编译，得到可执行文件，然后运行就可以了。
封装了对GPU的操作。

### Ubuntu安装Nvidia

主要的安装须知都在这个文档里说明了：[Nvidia Cuda Installation for Linux](https://developer.download.nvidia.com/compute/cuda/10.0/Prod/docs/sidebar/CUDA_Installation_Guide_Linux.pdf)

1. 前期准备，下载cuda Toolkit

2. Disabling Nouveau

    1. Create a file at /etc/modprobe.d/blacklist-nouveau.conf with the following contents:
    ```
    blacklist nouveau
    options nouveau modeset=0
    ```
    2. Regenerate the kernel initramfs:
    ```
    $ sudo update-initramfs -u

    ```

3. 重启，进入命令终端启动cuda。 直接`Alt + <F3>`就进入了。然后找到cuda开始运行。按照提示一点一点装就可以了.

4. 重启。
