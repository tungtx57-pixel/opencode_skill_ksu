---
name: ksu-manual-hook
description: Integrate KSU (KernelSU variants) manual hooks into Non-GKI kernels
license: MIT
compatibility: opencode
metadata:
  audience: kernel-developers
  workflow: android-rooting
---

## Mục đích

Patch kernel source tree với KSU manual hooks cho Non-GKI devices.

## Hỗ trợ biến thể và Setup Commands

| # | Biến thể | Mode | Setup Command | Kernel hỗ trợ |
|---|----------|------|---------------|---------------|
| 1 | ReSukiSU | - | `curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" \| bash` | 4.4 - 5.4 |
| 2 | KSU Next | latest | `curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" \| bash -` | 5.7+ |
| 2 | KSU Next | stable | `curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" \| bash -s stable` | 5.7+ |
| 2 | KSU Next | legacy | `curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" \| bash -s legacy` | 4.4 - 5.4 |
| 3 | SukiSU Ultra | builtin | `curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" \| bash -s builtin` | 5.7+ |
| 3 | SukiSU Ultra | susfs | `curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" \| bash -s susfs-main` | 5.7+ |
| 4 | RKSU | main | `curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" \| bash -s main` | 4.4 - 5.4 |
| 4 | RKSU | susfs | `curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" \| bash -s susfs-rksu-master` ⚠️ | 5.7+ |

## Kernel Compatibility Notes

| Biến thể | Kernel 4.4-4.14 | Kernel 4.19-5.4 | Kernel 5.7+ |
|----------|-----------------|------------------|-------------|
| ReSukiSU | ✅ | ✅ | ✅ |
| KSU Next legacy | ✅ | ✅ | ✅ |
| KSU Next stable/latest | ❌ | ❌ | ✅ |
| SukiSU Ultra | ⚠️ | ⚠️ | ✅ |
| RKSU main | ✅ | ✅ | ✅ |
| RKSU susfs | ⚠️ | ⚠️ | ✅ |

## Yêu cầu

- Kernel source tree đã build được
- Git đã configured (để backup/rollback)
- Kernel version: 4.4 - 5.4 (Non-GKI)

## Workflow

### Bước 1: Pre-flight Checks

Thực hiện các checks:

1. **Kernel version**:
   ```bash
   make kernelversion
   ```

2. **GKI/Non-GKI detection**:
   ```bash
   # Non-GKI: Makefile ở root, không có kernel/Makefile
   # GKI: có kernel/Makefile
   ```

3. **Architecture**:
   ```bash
   # arm64: arch/arm64 tồn tại
   # arm: arch/arm tồn tại
   ```

4. **Existing KSU**:
   ```bash
   ls -la drivers/kernelsu/ 2>/dev/null || ls -la drivers/misc/ksu/ 2>/dev/null
   grep -r "CONFIG_KSU" . --include="*.config" --include="*defconfig" 2>/dev/null
   ```

5. **Existing Susfs**:
   ```bash
   ls -la fs/susfs.c include/linux/susfs*.h 2>/dev/null
   ```

### Bước 2: Chọn biến thể và Mode

Hỏi user chọn biến thể:

```
Chọn biến thể KSU:

1. ReSukiSU
   - Hook riêng từ resukisu.github.io
   - Hỗ trợ: 4.4 - 5.4

2. KSU Next
   2a. legacy - Cho kernel 4.4-5.4, nên dùng với SUSFS
   2b. stable - Branch stable (5.7+)
   2c. latest - Branch next mới nhất (5.7+)

3. SukiSU Ultra
   3a. builtin - Manual hook không SUSFS (5.7+)
   3b. susfs - Có SUSFS tích hợp (5.7+)

4. RKSU
   4a. main - Manual hook (4.4-5.4)
   4b. susfs - Có SUSFS tích hợp ⚠️ (5.7+, experimental)
```

### Bước 3: Git Backup

**BẮT BUỘC** - Yêu cầu user commit trước:

```bash
# Kiểm tra git status
git status

# Nếu chưa có git, khởi tạo
git init
git add -A
git commit -m "Initial state before KSU manual hooks"

# Nếu đã có git, commit thay đổi hiện tại
git add -A
git commit -m "Before KSU manual hooks"
```

**Rollback nếu cần**:
```bash
git reset --hard HEAD
```

### Bước 4: Run Setup Command

Chạy setup command theo option user đã chọn:

```bash
# ReSukiSU
curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash

# KSU Next - latest (5.7+)
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -

# KSU Next - stable (5.7+)
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s stable

# KSU Next - legacy (4.4-5.4)
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s legacy

# SukiSU Ultra - builtin (5.7+)
curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s builtin

# SukiSU Ultra - susfs (5.7+)
curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s susfs-main

# RKSU - main (4.4-5.4)
curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" | bash -s main

# RKSU - susfs ⚠️ (5.7+, experimental)
curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" | bash -s susfs-rksu-master
```

**Lưu ý cho RKSU susfs**:
Nếu user chọn RKSU susfs, hỏi thêm:
```
⚠️ RKSU susfs có thể chưa hỗ trợ Non-GKI đầy đủ.
1. Tiếp tục (experimental)
2. Chuyển sang RKSU main mode
3. Hủy bỏ
```

### Bước 5: Handle Existing KSU Hooks

Kiểm tra hooks cũ:
```bash
grep -r "ksu_" --include="*.c" .
grep -r "#ifdef CONFIG_KSU" --include="*.c" .
grep -r "#include.*ksu" --include="*.c" .
```

Hỏi user:

```
Phát hiện KSU hooks cũ trong kernel tree.
1. Loại bỏ hoàn toàn và thay thế
2. Chỉ loại bỏ phần conflict  
3. Giữ nguyên (không khuyến khích - có thể conflict)
4. Hủy bỏ
```

### Bước 6: Apply Hooks

#### A. ReSukiSU (Hook riêng)

**Apply manual hooks** theo tài liệu: `https://resukisu.github.io/guide/manual-integrate.html`

ReSukiSU hooks cần apply:

| Hook | File | Kernel | Required |
|------|------|--------|----------|
| stat | `fs/stat.c` | all | ✅ Required |
| execve | `fs/exec.c` | 3.14+/3.14- | ✅ Required |
| faccessat | `fs/open.c` | 4.19+/4.19- | ✅ Required |
| sys_reboot | `kernel/reboot.c` / `kernel/sys.c` | 3.11+/3.11- | ✅ Required |
| setuid | `kernel/sys.c` | 6.8+ / 4.2- | ⚠️ Conditional |
| sys_read | `fs/read_write.c` | 6.8+ / 4.2- | ⚠️ Conditional |
| input | `drivers/input/input.c` | all | ❌ Optional |
| policy_rwlock | `security/selinux/ss/services.c` | all | ❌ Optional |

#### B. KSU Next / SukiSU Ultra / RKSU (Shared hooks)

**Xác định kernel version để chọn patch**:
```bash
KV=$(make kernelversion | head -1)
KV_MAJOR=$(echo $KV | cut -d'.' -f1)
KV_MINOR=$(echo $KV | cut -d'.' -f2)

if [ "$KV_MAJOR" -eq 4 ] && [ "$KV_MINOR" -le 9 ]; then
    HOOK_PATCH="kernel-4.4_4.9.patch"
elif [ "$KV_MAJOR" -eq 4 ] && [ "$KV_MINOR" -eq 14 ]; then
    HOOK_PATCH="kernel-4.14.patch"
else
    HOOK_PATCH="kernel-4.19_5.4.patch"
fi
```

**Download và apply patch**:
```bash
# Download patch
curl -sL "https://raw.githubusercontent.com/rksuorg/kernel_patches/master/manual_hook/${HOOK_PATCH}" -o "${HOOK_PATCH}"

# Apply patch
patch -p1 --force < "${HOOK_PATCH}"
```

### Bước 7: Handle Reject Files

Kiểm tra rejects:
```bash
find . -name "*.rej" 2>/dev/null
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
- Tìm keyword trong file gốc bằng grep
- Nếu code đã có → xóa .rej
- Nếu chưa có → apply thủ công

### Bước 8: Config Setup

Hỏi user:

```
Bật CONFIG_KSU:
1. Tự động thêm vào {defconfig_name}
2. Hướng dẫn bật trong menuconfig
3. Để sau
```

**Option 1 - Auto add**:
```bash
echo "CONFIG_KSU=y" >> arch/arm64/configs/{defconfig}
# Hoặc
scripts/config -e KSU
```

**Option 2 - Menuconfig**:
```
  make menuconfig
  Device Drivers -> KernelSU -> CONFIG_KSU=y
```

### Bước 9: Verification

```bash
# Verify KSU files exist
ls -la drivers/kernelsu/ 2>/dev/null || ls -la drivers/misc/ksu/ 2>/dev/null

# Verify hooks applied
grep -r "CONFIG_KSU" fs/stat.c fs/exec.c fs/open.c kernel/reboot.c 2>/dev/null

# Check no rejects
find . -name "*.rej" -o -name "*.orig"
```

## User Prompts Summary

### Initial Prompt
```
Bạn muốn integrate KSU manual hooks vào kernel này?

Pre-flight check:
- Kernel: {version}
- Architecture: {arm64/arm}
- GKI/Non-GKI: {type}
- KSU hiện tại: {có/không}
- Susfs hiện tại: {có/không}

Cung cấp:
- Defconfig sử dụng: ???
- Biến thể KSU và mode (1-4, a/b/c)
```

### RKSU Susfs Warning
```
⚠️ RKSU susfs có thể chưa hỗ trợ Non-GKI đầy đủ (yêu cầu kernel 5.7+).
1. Tiếp tục (experimental)
2. Chuyển sang RKSU main mode (hỗ trợ 4.4-5.4)
3. Hủy bỏ
```

## Notes

- **Không chạy build test** - Để tránh confuse agent
- Yêu cầu user tự build với script riêng (build.sh)
- Nếu build fails → Check dmesg patterns trong kernel logs
- Nếu bootloop → Kiểm tra hooks conflict với existing code

## References

- ReSukiSU docs: https://resukisu.github.io/guide/manual-integrate.html
- ReSukiSU repo: https://github.com/ReSukiSU/ReSukiSU
- rksuorg patches: https://github.com/rksuorg/kernel_patches/tree/master/manual_hook
- KSU Next: https://github.com/KernelSU-Next/KernelSU-Next
- SukiSU Ultra: https://github.com/SukiSU-Ultra/SukiSU-Ultra
- RKSU: https://github.com/rsuntk/KernelSU
