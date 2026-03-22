---
name: ksu-common
description: Shared utilities and detection functions for KSU kernel patching workflows
license: MIT
compatibility: opencode
metadata:
  audience: kernel-developers
  workflow: android-rooting
---

## Mục đích

Cung cấp các hàm utility và detection logic dùng chung cho KSU patching workflows.

## Kernel Detection

### Get Kernel Version

```bash
make kernelversion
```

### Detect Architecture

```bash
# Check arm64
if [ -d "arch/arm64" ]; then
    echo "arm64"
fi

# Check arm32
if [ -d "arch/arm" ]; then
    echo "arm"
fi
```

### Kernel Version Categories

```bash
KV=$(make kernelversion | head -1)
KV_MAJOR=$(echo $KV | cut -d'.' -f1)
KV_MINOR=$(echo $KV | cut -d'.' -f2)

# 4.4 - 4.9
if [ "$KV_MAJOR" -eq 4 ] && [ "$KV_MINOR" -le 9 ]; then
    echo "kernel-4.4_4.9"
# 4.14
elif [ "$KV_MAJOR" -eq 4 ] && [ "$KV_MINOR" -eq 14 ]; then
    echo "kernel-4.14"
# 4.19 - 5.4
elif [ "$KV_MAJOR" -eq 4 ] && [ "$KV_MINOR" -ge 19 ] || \
     [ "$KV_MAJOR" -eq 5 ] && [ "$KV_MINOR" -le 4 ]; then
    echo "kernel-4.19_5.4"
fi
```

## KSU Detection

### Check Existing KSU Installation

```bash
# Check KernelSU driver directory
if [ -d "drivers/kernelsu" ]; then
    echo "KSU found: drivers/kernelsu/"
elif [ -d "drivers/misc/ksu" ]; then
    echo "KSU found: drivers/misc/ksu/"
fi

# Check KSU headers
if [ -f "include/linux/ksu.h" ]; then
    echo "KSU header found"
fi

# Check KSU config
if grep -q "CONFIG_KSU=y" "*/defconfig" 2>/dev/null || \
   grep -q "CONFIG_KSU=y" ".config" 2>/dev/null; then
    echo "CONFIG_KSU enabled"
fi
```

### Detect Existing KSU Hooks

Search for KSU-related patterns:
```bash
# Function calls
grep -r "ksu_" --include="*.c" .

# Config blocks
grep -r "#ifdef CONFIG_KSU" --include="*.c" .

# Headers
grep -r "#include.*ksu" --include="*.c" .

# Section attributes
grep -r "\.ksu" --include="*.c" --include="*.h" .
```

### Detect Existing Susfs

```bash
# Check susfs files
if [ -f "fs/susfs.c" ]; then
    echo "Susfs found: fs/susfs.c"
fi

if [ -f "include/linux/susfs.h" ]; then
    echo "Susfs header found"
fi

if [ -f "include/linux/susfs_def.h" ]; then
    echo "Susfs def header found"
fi

# Check susfs config
if grep -q "CONFIG_KSU_SUSFS=y" "*/defconfig" 2>/dev/null || \
   grep -q "CONFIG_KSU_SUSFS=y" ".config" 2>/dev/null; then
    echo "CONFIG_KSU_SUSFS enabled"
fi
```

## Git Utilities

### Require Git Commit Before Modify

```bash
# Prompt user to commit before patching
echo "Nên commit trước khi patch:"
echo "  git add -A && git commit -m 'Before KSU patches'"
echo ""
echo "Để rollback nếu cần:"
echo "  git reset --hard HEAD"
```

### Check Git Status

```bash
# Check if there are uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "WARNING: Có thay đổi chưa commit"
    echo "Nên commit trước khi tiếp tục"
fi
```

## Patch Utilities

### Find Reject Files

```bash
# Find all .rej files
find . -name "*.rej" 2>/dev/null

# Find all .orig backup files
find . -name "*.orig" 2>/dev/null
```

### Clean Reject/Orig Files

```bash
# Remove .rej files
find . -name "*.rej" -delete

# Remove .orig backup files
find . -name "*.orig" -delete
```

## Config Utilities

### Enable KSU Config

```bash
# Add to defconfig
echo "CONFIG_KSU=y" >> arch/arm64/configs/your_defconfig

# Or use scripts/config
scripts/config -e KSU
```

### Enable KSU_SUSFS Config

```bash
# Add to defconfig
echo "CONFIG_KSU_SUSFS=y" >> arch/arm64/configs/your_defconfig

# Or use scripts/config
scripts/config -e KSU_SUSFS
```

### Menuconfig Instructions

```
Để bật KSU trong menuconfig:
  make menuconfig

Đường dẫn: Device Drivers -> KernelSU
  -> CONFIG_KSU=y
  -> CONFIG_KSU_SUSFS=y (nếu có susfs)
```

## URL Constants

### KSU Setup Commands (theo biến thể và mode)

| Biến thể | Mode | Setup Command |
|-----------|------|---------------|
| ReSukiSU | - | `curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" \| bash` |
| KSU Next | latest | `curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" \| bash -` |
| KSU Next | stable | `curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" \| bash -s stable` |
| KSU Next | legacy | `curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" \| bash -s legacy` |
| Wild KSU | wild | `curl -LSs "https://raw.githubusercontent.com/WildKernels/Wild_KSU/wild/kernel/setup.sh" \| bash -s wild` |
| SukiSU Ultra | builtin | `curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" \| bash -s builtin` |
| SukiSU Ultra | susfs | `curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" \| bash -s susfs-main` |
| RKSU | main | `curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" \| bash -s main` |
| RKSU | susfs | `curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" \| bash -s susfs-rksu-master` ⚠️ |

### KSU Manual Hook Sources

| Source | URL |
|--------|-----|
| ReSukiSU docs | `https://resukisu.github.io/guide/manual-integrate.html` |
| ReSukiSU setup | `https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh` |
| KSU Next repo | `https://github.com/KernelSU-Next/KernelSU-Next` |
| SukiSU Ultra repo | `https://github.com/SukiSU-Ultra/SukiSU-Ultra` |
| RKSU repo | `https://github.com/rsuntk/KernelSU` |
| rksuorg (shared hooks) | `https://github.com/rksuorg/kernel_patches/tree/master/manual_hook` |

### SUSFS Sources

| Source | URL |
|--------|-----|
| susfs patch | `https://raw.githubusercontent.com/JackA1ltman/NonGKI_Kernel_Build_2nd/mainline/Patches/Patch/susfs_patch_to_{VERSION}.patch` |
| susfs inline script | `https://raw.githubusercontent.com/JackA1ltman/NonGKI_Kernel_Build_2nd/mainline/Patches/susfs_inline_hook_patches.sh` |
| susfs4ksu repo | `https://github.com/simonpunk/susfs4ksu` |

### rksuorg Hook Patches (cho KSU Next, SukiSU Ultra, RKSU)

| Kernel Version | URL |
|----------------|-----|
| 4.4-4.9 | `https://raw.githubusercontent.com/rksuorg/kernel_patches/master/manual_hook/kernel-4.4_4.9.patch` |
| 4.14 | `https://raw.githubusercontent.com/rksuorg/kernel_patches/master/manual_hook/kernel-4.14.patch` |
| 4.19-5.4 | `https://raw.githubusercontent.com/rksuorg/kernel_patches/master/manual_hook/kernel-4.19_5.4.patch` | |

## User Prompts

### Confirm Variant

```
Chọn biến thể KSU:

1. ReSukiSU (hook riêng)
   - Setup: curl ...ReSukiSU/main/kernel/setup.sh | bash

2. KSU Next
   2a. latest - Branch next mới nhất
   2b. stable - Branch stable
   2c. legacy - Cho kernel cũ, nên dùng với SUSFS

3. SukiSU Ultra
   3a. builtin - Manual hook không SUSFS
   3b. susfs - Có SUSFS tích hợp

4. RKSU
   4a. main - Manual hook
   4b. susfs - Có SUSFS tích hợp (⚠️ Experimental)
```

### RKSU Susfs Warning

```
⚠️ RKSU susfs có thể chưa hỗ trợ Non-GKI đầy đủ.
1. Tiếp tục (experimental)
2. Chuyển sang RKSU main mode
3. Hủy bỏ
```

### Handle Existing KSU

```
Phát hiện KSU hooks cũ trong kernel tree.
1. Loại bỏ hoàn toàn và thay thế
2. Chỉ loại bỏ phần conflict
3. Giữ nguyên (không khuyến khích)
4. Hủy bỏ
```

### Handle Existing Susfs

```
Phát hiện SUSFS cũ trong kernel.
1. Xóa hoàn toàn và apply SUSFS 2.0.0 mới
2. Xóa và bỏ qua (không cài SUSFS)
3. Giữ nguyên và bỏ qua
```

### Handle Reject Files

```
Phát hiện {n} file(s) bị reject:
1. Tự động apply thủ công vào source
2. Chỉ liệt kê để user tự xử lý
3. Bỏ qua (có thể build lỗi)
```

### Config Setup

```
Bật CONFIG_KSU:
1. Tự động thêm vào {defconfig}
2. Hướng dẫn bật trong menuconfig
3. Để sau
```
