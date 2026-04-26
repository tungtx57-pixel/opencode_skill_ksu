---
name: ksu-susfs-inline
description: Integrate SUSFS v2.0.0 with inline hooks for KSU Next, ReSukiSU, SukiSU Ultra
license: MIT
compatibility: opencode
metadata:
  audience: kernel-developers
  workflow: android-rooting
---

## Mục đích

Tích hợp SUSFS v2.0.0 với inline hooks vào Non-GKI kernels.

## Hỗ trợ biến thể

| Biến thể | SUSFS Inline | Notes |
|----------|-------------|-------|
| KSU Next | ✅ | **Primary target** - Nên dùng **legacy** mode |
| ReSukiSU | ✅ | Có hook riêng nhưng dùng chung susfs |
| SukiSU Ultra | ✅ | KernelPatch-based - Có mode **susfs-main** |
| Wild KSU | ❌ | Chưa hỗ trợ |
| RKSU | ⚠️ | Mode **susfs-rksu-master** - Experimental, có thể chưa hỗ trợ Non-GKI |

## Setup Commands cho SUSFS

| Biến thể | Mode | Setup Command |
|-----------|------|---------------|
| KSU Next | legacy | `curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" \| bash -s legacy` |
| ReSukiSU | - | `curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" \| bash` |
| SukiSU Ultra | susfs | `curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" \| bash -s susfs-main` |
| RKSU | susfs | `curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" \| bash -s susfs-rksu-master` ⚠️ |

## Yêu cầu

- Kernel source đã có KSU installed (manual hooks đã apply)
- Kernel version: Non-GKI (4.4 - 5.4)
- Git đã configured

## SUSFS Version

**Cố định: v2.0.0**

## Workflow

### Bước 1: Pre-flight Checks

1. **Verify KSU exists**:
   ```bash
   ls -la drivers/kernelsu/ 2>/dev/null || ls -la drivers/misc/ksu/ 2>/dev/null
   ```

2. **Kernel version**:
   ```bash
   make kernelversion
   ```

3. **Architecture**:
   ```bash
   [ -d "arch/arm64" ] && echo "arm64" || echo "arm"
   ```

4. **Existing Susfs**:
   ```bash
   ls -la fs/susfs.c include/linux/susfs*.h 2>/dev/null
   ```

### Bước 2: Chọn biến thể KSU

Hỏi user xác nhận biến thể:

```
Chọn biến thể KSU đã cài (phải có KSU trước khi cài SUSFS):

1. KSU Next
   - Nên dùng: legacy mode (curl ... | bash -s legacy)
   - Setup: curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s legacy

2. ReSukiSU
   - Setup: curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash

3. SukiSU Ultra
   - Nên dùng: susfs-main mode (đã có SUSFS tích hợp)
   - Setup: curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s susfs-main

4. RKSU
   - Mode susfs (⚠️ Experimental - có thể chưa hỗ trợ Non-GKI)
   - Setup: curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" | bash -s susfs-rksu-master

5. Hủy bỏ
```

**Lưu ý cho RKSU**:
Nếu user chọn RKSU, hỏi thêm:
```
⚠️ RKSU susfs có thể chưa hỗ trợ Non-GKI đầy đủ.
1. Tiếp tục (experimental)
2. Chuyển sang biến thể khác
3. Hủy bỏ
```

### Bước 3: Git Backup

**BẮT BUỘC** - Yêu cầu user commit:

```bash
# Kiểm tra git
git status

# Commit trước khi modify
git add -A
git commit -m "Before SUSFS v2.0.0 inline hooks"
```

**Rollback nếu cần**:
```bash
git reset --hard HEAD~1
```

### Bước 4: Handle Existing SUSFS

Kiểm tra susfs cũ:
```bash
ls -la fs/susfs.c include/linux/susfs*.h 2>/dev/null
grep -r "SUSFS" fs/ include/linux/ --include="*.c" --include="*.h" 2>/dev/null
```

Hỏi user:

```
Phát hiện SUSFS cũ trong kernel.
1. Xóa hoàn toàn và apply SUSFS 2.0.0 mới
2. Xóa và bỏ qua (không cài SUSFS)
3. Giữ nguyên và bỏ qua
```

**Nếu chọn xóa** - Xóa files:
```bash
rm -f fs/susfs.c
rm -f include/linux/susfs.h
rm -f include/linux/susfs_def.h
```

### Bước 5: Xác định Kernel Version

```bash
KV=$(make kernelversion | head -1)
KV_NUM=$(echo $KV | tr -d '.' | cut -c1-3)
# VD: 4.19 -> 419, 5.4 -> 54
```

### Bước 6: Apply SUSFS Core Patch

#### Option A: Sử dụng source mặc định

```bash
# Download patch theo kernel version
SUSFS_PATCH_URL="https://raw.githubusercontent.com/JackA1ltman/NonGKI_Kernel_Build_2nd/mainline/Patches/Patch/susfs_patch_to_${KV_NUM}.patch"

curl -sL "${SUSFS_PATCH_URL}" -o susfs_patch.patch

# Apply patch
patch -p1 --force < susfs_patch.patch
```

#### Option B: User cung cấp source khác

Hỏi user:

```
Bạn có muốn sử dụng SUSFS source khác không?
1. Sử dụng source mặc định (JackA1ltman/NonGKI_Kernel_Build_2nd)
2. Cung cấp URL khác
```

Nếu user cung cấp URL:
```bash
# User nhập URL
curl -sL "{USER_PROVIDED_URL}" -o susfs_patch.patch
patch -p1 --force < susfs_patch.patch
```

### Bước 7: Copy SUSFS Files

```bash
# Copy nếu có kernel_patches directory
if [ -d "kernel_patches/fs" ]; then
    cp kernel_patches/fs/susfs.c fs/
    cp kernel_patches/include/linux/susfs.h include/linux/
    cp kernel_patches/include/linux/susfs_def.h include/linux/
fi
```

### Bước 8: Apply SUSFS Inline Hook Patches

#### Option A: Sử dụng script mặc định

```bash
# Download inline hook script
curl -sL "https://raw.githubusercontent.com/JackA1ltman/NonGKI_Kernel_Build_2nd/mainline/Patches/susfs_inline_hook_patches.sh" -o susfs_inline.sh

chmod +x susfs_inline.sh

# Run script
bash susfs_inline.sh
```

#### Option B: User cung cấp script khác

Hỏi user:

```
Bạn có muốn sử dụng inline hook script khác không?
1. Sử dụng script mặc định
2. Cung cấp URL/Commit khác
```

### Bước 9: Handle Reject Files

Kiểm tra rejects:
```bash
find . -name "*.rej" 2>/dev/null | head -20
```

Hỏi user:

```
Phát hiện {n} file(s) bị reject:
1. Tự động apply thủ công vào source
2. Chỉ liệt kê để user tự xử lý
3. Bỏ qua (có thể build lỗi)
```

**Nếu chọn auto-apply**:
- Đọc từng file .rej
- Tìm keyword trong file gốc
- Nếu code đã có → xóa .rej
- Nếu chưa có → apply thủ công

### Bước 10: Clean Backup Files

```bash
find . -name "*.orig" -delete
```

### Bước 11: Config Setup

Hỏi user:

```
Bật CONFIG_KSU_SUSFS=y:
1. Tự động thêm vào {defconfig_name}
2. Hướng dẫn bật trong menuconfig (Device Drivers -> KernelSU -> KSU_SUSFS)
3. Để sau
```

**Option 1 - Auto add**:
```bash
echo "CONFIG_KSU_SUSFS=y" >> arch/arm64/configs/{defconfig}
# Hoặc
scripts/config -e KSU_SUSFS
```

**Option 2 - Menuconfig**:
```
  make menuconfig
  Device Drivers -> KernelSU -> CONFIG_KSU_SUSFS=y
```

### Bước 12: Verification

```bash
# Check SUSFS version
grep "SUSFS_VERSION" include/linux/susfs.h

# Check inline hooks applied
grep -r "susfs" fs/exec.c fs/open.c kernel/reboot.c 2>/dev/null

# Check no rejects
find . -name "*.rej" -o -name "*.orig"

# Verify KSU still intact
ls -la drivers/kernelsu/ 2>/dev/null || ls -la drivers/misc/ksu/ 2>/dev/null
```

## Files Modified by Inline Hooks

| File | Hook |
|------|------|
| `fs/exec.c` | execve hooks |
| `fs/open.c` | open/faccessat hooks |
| `fs/read_write.c` | read/write hooks |
| `fs/stat.c` | stat hooks |
| `kernel/reboot.c` | reboot hooks |
| `kernel/sys.c` | syscalls |
| `security/selinux/hooks.c` | SELinux hooks |

## User Prompts Summary

### Initial Prompt
```
Bạn muốn integrate SUSFS v2.0.0 inline hooks?
Yêu cầu: Kernel đã có KSU (manual hooks đã apply)
- Kernel version: $(make kernelversion)
- KSU đã cài: {có/không}
```

### Source Confirmation
```
SUSFS Source:
1. Mặc định (JackA1ltman/NonGKI_Kernel_Build_2nd)
2. Tự cung cấp URL/commit
```

### Post-Apply Summary
```
SUSFS v2.0.0 đã được apply:
- Version: {from susfs.h}
- Hooks: {list files}
- Config: {CONFIG_KSU_SUSFS}
```

## Error Handling

### Patch Fails
```bash
# Thử với --force
patch -p1 --force < susfs_patch.patch

# Nếu vẫn lỗi, xóa hoàn toàn susfs cũ và apply lại
```

### Build Fails
- Check missing symbols
- Check extern declarations
- Verify all susfs headers included

### Bootloop
- Kiểm tra hooks conflict với existing KSU code
- Verify SUSFS compatible với KSU version

## Notes

- **Không chạy build test** - Để tránh confuse agent
- SUSFS v2.0.0 là phiên bản cố định
- Inline hooks sẽ skip nếu đã có KSU hooks (bình thường)
- Khuyến khích user tự build với script riêng

## References

- JackA1ltman patches: https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd
- SUSFS docs: https://github.com/simonpunk/susfs4ksu/wiki
