# KSU Kernel Patching Skills for OpenCode

Bộ skill cho [OpenCode](https://opencode.ai) hỗ trợ patch và hook các biến thể KernelSU.

## Skills

| Skill | Mô tả |
|-------|--------|
| `ksu-manual-hook` | Integrate KSU manual hooks vào Non-GKI kernels |
| `ksu-susfs-inline` | Integrate SUSFS v2.0.0 với inline hooks |
| `ksu-common` | Shared utilities và detection functions |

## Hỗ trợ biến thể KSU

| Biến thể | Manual Hook | SUSFS Inline |
|-----------|------------|-------------|
| ReSukiSU | ✅ | ✅ |
| KSU Next | ✅ (latest/stable/legacy) | ✅ (legacy) |
| Wild KSU | ✅ | ❌ |
| SukiSU Ultra | ✅ (builtin/susfs) | ✅ (susfs-main) |
| RKSU | ✅ (main/susfs) | ⚠️ (experimental) |

## Setup cho OpenCode

### Cách 1: Symlink (Khuyến nghị)

```bash
# Tạo symlink từ repo đến config
mkdir -p ~/.config/opencode/skills
ln -sf /path/to/skills/* ~/.config/opencode/skills/
```

### Cách 2: Copy trực tiếp

```bash
mkdir -p ~/.config/opencode/skills
cp -r skills/* ~/.config/opencode/skills/
```

## Sử dụng

Khi cần patch kernel, agent sẽ tự động thấy skills và có thể load:

```
/load-skill ksu-manual-hook
/load-skill ksu-susfs-inline
```

## Kernel Versions hỗ trợ

- 4.4 - 4.9
- 4.14
- 4.19 - 5.4

## Notes

- **Không chạy build test** tự động - Để tránh confuse agent
- Yêu cầu **git commit** trước khi patch để rollback nếu cần
- Hỗ trợ **Non-GKI** kernels

## References

- [ReSukiSU](https://github.com/ReSukiSU/ReSukiSU)
- [KSU Next](https://github.com/KernelSU-Next/KernelSU-Next)
- [Wild KSU](https://github.com/WildKernels/Wild_KSU)
- [SukiSU Ultra](https://github.com/SukiSU-Ultra/SukiSU-Ultra)
- [RKSU](https://github.com/rsuntk/KernelSU)
- [rksuorg patches](https://github.com/rksuorg/kernel_patches)
- [SUSFS](https://github.com/simonpunk/susfs4ksu)

## Credits

Cảm ơn các tác giả và contributors đã phát triển các dự án nguồn mở:

| Project | Author |
|---------|--------|
| KernelSU | [@tiann](https://github.com/tiann) |
| RKSU | [@rsuntk](https://github.com/rsuntk) |
| xxKSU | [@backslashxx](https://github.com/backslashxx) |
| SukiSU Ultra | [@ShirkNeko](https://github.com/ShirkNeko) |
| ReSukiSU | [ReSukiSU Development](https://github.com/ReSukiSU) |
| KSU Next | [@rifsxd](https://github.com/rifsxd) |
| SuSFS | [@simonpunk](https://github.com/simonpunk) |
| Re:Kernel | [Sakion-Team](https://github.com/Sakion-Team) |
| Baseband Guard | [秋刀鱼](https://github.com) |

Và tất cả các tác giả kernel nguồn mở khác.

## SUSFS Inline Hook Backport

Cảm ơn [@JackA1ltman](https://github.com/JackA1ltman) đã backport và tổng hợp SUSFS inline hooks cho Non-GKI kernels.

- [NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd)

## Copyright

```
Copyright (c) 2026

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

**Lưu ý**: Các dự án KernelSU và biến thể có license riêng. Vui lòng tuân thủ license của từng dự án khi sử dụng.
