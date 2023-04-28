# Потрошим флешку mjsxj03hl
1. [Введение](#1-введение)
2. [Образ флешки](#2-образ-флешки)
   1. [Разбиение](#21-разбиение)
   2. [Разделы](#22-разделы-boot)
       - [boot](#22-разделы-boot)
       - [kernel](#22-разделы-kernel)
       - [rootfs, app, kback, aback](#22-разделы-rootfs-app-kback-aback)
       - [cfg](#22-разделы-cfg)
       - [para](#22-разделы-para)
3. [Получение шелла на стоке](#3-получение-шелла-на-стоке)
4. [Использованный софт](#4-использованный-софт)

## 1. Введение
Как обычно всё что делаете на ваш страх и риск. Никто ни к чему не принуждает. Есть риск кирпича и внеземного вторжения.

Инструкция только под linux системы (так же подходит wsl).

## 2. Образ флешки
### 2.1. Разбиение
Инструкция по снятию дапа есть в [мануале по прошивке](./Manual_ru.md#сохранение-заводской-прошивки) так что будем считать что он уже есть.

Таблицу разделов можно подсмотреть при загрузке ядра:
```
[    0.403332] 8 cmdlinepart partitions found on MTD device jz_sfc
[    0.409482] Creating 8 MTD partitions on "jz_sfc":
[    0.414477] 0x000000000000-0x000000040000 : "boot"
[    0.419946] 0x000000040000-0x000000230000 : "kernel"
[    0.425609] 0x000000230000-0x000000600000 : "rootfs"
[    0.431198] 0x000000600000-0x0000009d0000 : "app"
[    0.436586] 0x0000009d0000-0x000000bc0000 : "kback"
[    0.442075] 0x000000bc0000-0x000000f90000 : "aback"
[    0.447632] 0x000000f90000-0x000000ff0000 : "cfg"
[    0.452947] 0x000000ff0000-0x000001000000 : "para"
[    0.458409] SPI NOR MTD LOAD OK
```
Далее нужно распотрошить дамп на куски согласно разметке. Для разборки, выравнивания, сборки дампа для себя написал небольшую тулзу [BinTools](https://github.com/mixa3607/BinTools) (описание всего софта снизу мануала). Вы можете использовать как её так и любую другую, цель именно в разбитии оригинального бинарника по адресам.
```shell
$ cat parts.json
{
  "Partitions": [
    {
      "BeginAddress": 0x000000000000, "EndAddress": 0x000000040000,
      "Name": "boot", "Extension": "bin"
    },
    {
      "BeginAddress": 0x000000040000, "EndAddress": 0x000000230000,
      "Name": "kernel", "Extension": "uimg"
    },
    {
      "BeginAddress": 0x000000230000, "EndAddress": 0x000000600000,
      "Name": "rootfs", "Extension": "squashfs"
    },
    {
      "BeginAddress": 0x000000600000, "EndAddress": 0x0000009d0000,
      "Name": "app", "Extension": "squashfs"
    },
    {
      "BeginAddress": 0x0000009d0000, "EndAddress": 0x000000bc0000,
      "Name": "kback", "Extension": "squashfs"
    },
    {
      "BeginAddress": 0x000000bc0000, "EndAddress": 0x000000f90000,
      "Name": "aback", "Extension": "squashfs"
    },
    {
      "BeginAddress": 0x000000f90000, "EndAddress": 0x000000ff0000,
      "Name": "cfg", "Extension": "jffs2"
    },
    {
      "BeginAddress": 0x000000ff0000, "EndAddress": 0x000001000000,
      "Name": "para", "Extension": "bin"
    }
  ]
}

$ ./bintools split -p ./parts.json -i ./fulldump.4.3.2_0193.bin -o ./split
[01:36:08 DBG] Part names not specified, export all
[01:36:08 INF] Process part boot. Range 00000000 - 00040000, len 262144
[01:36:08 INF] Write 262144 bytes to split/boot.bin
[01:36:08 INF] Process part kernel. Range 00040000 - 00230000, len 2031616
[01:36:08 INF] Write 2031616 bytes to split/kernel.uimg
[01:36:08 INF] Process part rootfs. Range 00230000 - 00600000, len 3997696
[01:36:08 INF] Write 3997696 bytes to split/rootfs.squashfs
[01:36:08 INF] Process part app. Range 00600000 - 009D0000, len 3997696
[01:36:08 INF] Write 3997696 bytes to split/app.squashfs
[01:36:08 INF] Process part kback. Range 009D0000 - 00BC0000, len 2031616
[01:36:08 INF] Write 2031616 bytes to split/kback.squashfs
[01:36:08 INF] Process part aback. Range 00BC0000 - 00F90000, len 3997696
[01:36:08 INF] Write 3997696 bytes to split/aback.squashfs
[01:36:08 INF] Process part cfg. Range 00F90000 - 00FF0000, len 393216
[01:36:08 INF] Write 393216 bytes to split/cfg.jffs2
[01:36:08 INF] Process part para. Range 00FF0000 - 01000000, len 65536
[01:36:08 INF] Write 65536 bytes to split/para.bin

$ cd split; ls
aback.squashfs
app.squashfs
boot.bin
cfg.jffs2
kback.squashfs
kernel.uimg
para.bin
rootfs.squashfs
```

### 2.2. Разделы (boot)
Ничего особо интересного. Пока что только binwalk
```shell
$ binwalk boot.bin
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
208236        0x32D6C         CRC32 polynomial table, little endian
212616        0x33E88         LZO compressed data
216084        0x34C14         Android bootimg, kernel size: 0 bytes, kernel addr: 0x70657250, ramdisk size: 543519329 bytes, ramdisk addr: 0x6E72656B, product name: "mem boot start"
```

### 2.2. Разделы (kernel)
Ничего особо интересного. Через `mkimage` не распознаётся
```shell
$ binwalk kernel.uimg
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             uImage header, header size: 64 bytes, header CRC: 0x58AB0988, created: 2021-07-11 18:42:35, image size: 1590203 bytes, Data Address: 0x80010000, Entry Point: 0x80367840, data CRC: 0xB7D95A14, OS: Linux, CPU: MIPS, image type: OS Kernel Image, compression type: lzma, image name: "Linux-3.10.14__isvp_swan_1.0__"
64            0x40            LZMA compressed data, properties: 0x5D, dictionary size: 67108864 bytes, uncompressed size: -1 bytes
```

### 2.2. Разделы (rootfs, app, kback, aback)
Это блоки squashfs которые можно распаковать, замодить, собрать обратно, главное не выйти за размер партишена.
```shell
$ unsquashfs -s ./rootfs.squashfs # информация о сжатии
Found a valid SQUASHFS 4:0 superblock on ./rootfs.squashfs.
Creation or last append time Wed Nov  3 15:37:54 2021
Filesystem size 3976360 bytes (3883.16 Kbytes / 3.79 Mbytes)
Compression xz
Block size 131072
Filesystem is exportable via NFS
Inodes are compressed
Data is compressed
Uids/Gids (Id table) are compressed
Fragments are compressed
Always-use-fragments option is not specified
Xattrs are compressed
Duplicates are removed
Number of fragments 13
Number of inodes 433
Number of ids 1
Number of xattr ids 0

$ unsquashfs ./rootfs.squashfs # распаковка
Parallel unsquashfs: Using 72 processors
389 inodes (456 blocks) to write
[==================/] 456/456 100%
created 89 files
created 44 directories
created 300 symlinks
created 0 devices
created 0 fifos
created 0 sockets

$ mksquashfs squashfs-root ./rootfs.repacked.squashfs -comp xz # упаковка
Parallel mksquashfs: Using 72 processors
Creating 4.0 filesystem on ./rootfs.repacked.squashfs, block size 131072.
[==================|] 156/156 100%
Exportable Squashfs 4.0 filesystem, xz compressed, data block size 131072
        compressed data, compressed metadata, compressed fragments,
        compressed xattrs, compressed ids
        duplicates are removed
Filesystem size 3883.12 Kbytes (3.79 Mbytes)
        36.00% of uncompressed filesystem size (10785.64 Kbytes)
Inode table size 2504 bytes (2.45 Kbytes)
        15.88% of uncompressed inode table size (15773 bytes)
Directory table size 3502 bytes (3.42 Kbytes)
        51.40% of uncompressed directory table size (6813 bytes)
Number of duplicate files found 0
Number of inodes 433
Number of files 89
Number of fragments 13
Number of symbolic links 300
Number of device nodes 0
Number of fifo nodes 0
Number of socket nodes 0
Number of directories 44
Number of ids (unique uids + gids) 1
Number of uids 1
        mixa3607 (1000)
Number of gids 1
        mixa3607 (1000)
```

### 2.2. Разделы (cfg)
Блок формата `jffs2`. На данный момент не маунтил но изветно что хранит изменяемые конфиги.

### 2.2. Разделы (para)
Назначение не понятно, просто блок забитый `0xFF`


## 3. Получение шелла на стоке
Цель заключается в том что достать `rootfs`, разобрать, раскоментировать строку в файле `/etc/inittab`, собрать и зашить патченый партишен обратно.
Репак:
```shell
$ # разбивка дампа
$ ./bintools split -p ./parts.json -i ./fulldump.4.3.2_0193.bin -o ./split
[01:36:08 DBG] Part names not specified, export all
[01:36:08 INF] Process part boot. Range 00000000 - 00040000, len 262144
[01:36:08 INF] Write 262144 bytes to split/boot.bin
[01:36:08 INF] Process part kernel. Range 00040000 - 00230000, len 2031616
[01:36:08 INF] Write 2031616 bytes to split/kernel.uimg
[01:36:08 INF] Process part rootfs. Range 00230000 - 00600000, len 3997696
[01:36:08 INF] Write 3997696 bytes to split/rootfs.squashfs
[01:36:08 INF] Process part app. Range 00600000 - 009D0000, len 3997696
[01:36:08 INF] Write 3997696 bytes to split/app.squashfs
[01:36:08 INF] Process part kback. Range 009D0000 - 00BC0000, len 2031616
[01:36:08 INF] Write 2031616 bytes to split/kback.squashfs
[01:36:08 INF] Process part aback. Range 00BC0000 - 00F90000, len 3997696
[01:36:08 INF] Write 3997696 bytes to split/aback.squashfs
[01:36:08 INF] Process part cfg. Range 00F90000 - 00FF0000, len 393216
[01:36:08 INF] Write 393216 bytes to split/cfg.jffs2
[01:36:08 INF] Process part para. Range 00FF0000 - 01000000, len 65536
[01:36:08 INF] Write 65536 bytes to split/para.bin

$ cd split
$ unsquashfs ./rootfs.squashfs # распаковка
Parallel unsquashfs: Using 72 processors
389 inodes (456 blocks) to write
[==================/] 456/456 100%
created 89 files
created 44 directories
created 300 symlinks
created 0 devices
created 0 fifos
created 0 sockets

$ sed -i 's|^#console::|console::|1' squashfs-root/etc/inittab # редактирование

$ mksquashfs squashfs-root ./rootfs.patched.squashfs -comp xz # упаковка
Parallel mksquashfs: Using 72 processors
Creating 4.0 filesystem on ./rootfs.patched.squashfs, block size 131072.
[================|] 156/156 100%
Exportable Squashfs 4.0 filesystem, xz compressed, data block size 131072
        compressed data, compressed metadata, compressed fragments,
        compressed xattrs, compressed ids
        duplicates are removed
Filesystem size 3883.12 Kbytes (3.79 Mbytes)
        36.00% of uncompressed filesystem size (10785.64 Kbytes)
Inode table size 2512 bytes (2.45 Kbytes)
        15.93% of uncompressed inode table size (15773 bytes)
Directory table size 3502 bytes (3.42 Kbytes)
        51.40% of uncompressed directory table size (6813 bytes)
Number of duplicate files found 0
Number of inodes 433
Number of files 89
Number of fragments 13
Number of symbolic links 300
Number of device nodes 0
Number of fifo nodes 0
Number of socket nodes 0
Number of directories 44
Number of ids (unique uids + gids) 1
Number of uids 1
        mixa3607 (1000)
Number of gids 1
        mixa3607 (1000)

$ ../bintools adjust -i ./rootfs.patched.squashfs -o ./rootfs.patched.bin -s 0x00000000003d0000 # выравнивание под размер раздела
[14:27:04 INF] Target size 3997696 more than source. Pad 20480 with 0xFF bytes

```
Копируем итоговый `rootfs.patched.bin` на флешку, попадаем в бутлоадер через замыкание флеша ([кусок из мана по прошивке](./Manual_ru.md#получение-доступа-к-консоли-загрузчика)) и прошиваем:
```shell
$ # начальный адрес в памяти и размер флеша
$ setenv baseaddr 0x80600000; setenv flashsize 0x1000000

$ # очистка памяти под разммер rootfs
$ mw.b ${baseaddr} 0xff 0x00000000003d0000

$ # подготовка сд карточки и вычитывание в рам
$ mmc rescan; fatls mmc 0:1
            system volume information/
  3997696   rootfs.patched.bin
1 file(s), 1 dir(s)
$ fatload mmc 0:1 ${baseaddr} rootfs.patched.bin
reading rootfs.patched.bin
3997696 bytes read in 665 ms (5.7 MiB/s)

$ # затирание rootfs на флеше
$ sf probe 0; sf erase 0x000000230000 0x00000000003d0000
the manufacturer 1c
SF: Detected EN25QH128A
--->probe spend 4 ms
SF: 3997696 bytes @ 0x230000 Erased: OK
--->erase spend 10836 ms

$ # копирование из рамы в флеш
$ sf write ${baseaddr} 0x000000230000 ${filesize}
SF: 3997696 bytes @ 0x230000 Written: OK
--->write spend 6862 ms

$ # сброс
$ reset
```

После загрузки должно выйти предложение залогиниться, если не видно то нажмите несколько раз ввод. Логин/хэш извлечены из `/etc/passwd` и `/etc/shadows` после гугления найден пароль. Итоговые кредсы `root:ismart12`
```
login: root
Password:
Apr 27 01:44:07 login[148]: root login on 'console'
[root@Ingenic-uc1_1:~]# ls
aback     dev       lib       mnt       root      sys       tmp
bin       etc       linuxrc   opt       run       system    usr
configs   kback     media     proc      sbin      thirdlib  var
```

## 4. Использованный софт
- `bintools` [github](https://github.com/mixa3607/BinTools)
- `binwalk` [github](https://github.com/ReFirmLabs/binwalk)
- `mksquashfs`/`unsquashfs` пакет `squashfs-tools`
