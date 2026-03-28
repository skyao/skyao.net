+++
title = "pdf2zh深度实践"
date =  2026-03-28
lastmod = 2026-03-28
draft = false

tags = ["PDF", "翻译"]
summary = "深度使用pdf2zh进行 pdf 文件中文翻译"
abstract = "深度使用pdf2zh进行 pdf 文件中文翻译"

[header]
image = ""
caption = ""

+++



## 安装

安装非常简单流畅：

```bash
pip install pdf2zh
```

## 配置

### api key

准备好 openrouter 的 api key，

```bash
sk-or-v1-959e1a04a1505bdd9baa6xxxxxxxxxxxxxxxxxxxxxxxx
```

Model 选择  Claude Opus 4.6。Opus 是 Anthropic 的旗舰重磅模型，拥有最深的上下文理解能力、最强的逻辑推理和最细腻的语义把握。

打开终端，编辑 pdf2zh 的配置文件（如果文件不存在，新建即可）：

```bash
mkdir -p ~/.config/PDFMathTranslate
vi ~/.config/PDFMathTranslate/config.json
```

内容如下：

```json
{
  "translators":[
    {
      "name": "openai",
      "envs": {
        "OPENAI_BASE_URL": "https://openrouter.ai/api/v1",
        "OPENAI_API_KEY": "sk-or-v1-959e1a04a1505bdd9baa6xxxxxxxxxxxxxxxxxxxxxxxx",
        "OPENAI_MODEL": "anthropic/claude-4.6-opus"
      }
    }
  ]
}
```

### pdf中文自体

我的 linux mint 系统上安装有 文泉驿微米黑 字体，我准备在生成的 pdf 中用这个字体，先找到自体的位置：

```bash
fc-list | grep wqy-microhei
/usr/share/fonts/truetype/wqy/wqy-microhei.ttc: WenQuanYi Micro Hei,文泉驛微米黑,文泉驿微米黑:style=Regular
/usr/share/fonts/truetype/wqy/wqy-microhei.ttc: WenQuanYi Micro Hei Mono,文泉驛等寬微米黑,文泉驿等宽微米黑:style=Regular
```

打开配置文件设置自体

```bash
vi ~/.config/PDFMathTranslate/config.json
```

设置字体为 文泉驿微米黑：

```json
{
  "translators":[
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

### 定制提示词

测试一下实际翻译效果，以经典的 linux-kernel-development-3rd.pdf 为例。

为了提高翻译效果，我让 gemini 为了准备了一段 Prompt：

```bash
要翻译的书籍为 linux-kernel-development-3rd.pdf，下面是这本书的介绍内容。

A thorough guide to the design and implementation of the Linux kernel
Linux Kernel Development details the design and implementation of the Linux kernel, presenting the content in a manner that is beneficial to those writing and developing kernel code, as well as to programmers seeking to better understand the operating system and become more efficient and productive in their coding.
The book details the major subsystems and features of the Linux kernel, including its design, implementation, and interfaces. It covers the Linux kernel with both a practical and theoretical eye, which should appeal to readers with a variety of interests and needs.
The author, a core kernel developer, shares valuable knowledge and experience on the 2.6 Linux kernel. Specific topics covered include process management, scheduling, time management and timers, the system call interface, memory addressing, memory management, the page cache, the VFS, kernel synchronization, portability concerns, and debugging techniques. This book covers the most interesting features of the Linux 2.6 kernel, including the CFS scheduler, preemptive kernel, block I/O layer, and I/O schedulers.

The third edition of Linux Kernel Development includes new and updated material throughout the book:
An all-new chapter on kernel data structures
Details on interrupt handlers and bottom halves
Extended coverage of virtual memory and memory allocation
Tips on debugging the Linux kernel
In-depth coverage of kernel synchronization and locking
Useful insight into submitting kernel patches and working with the Linux kernel community

为了最好的翻译效果，请帮我准备一段  系统提示词（Prompt）给 pdf2zh，让 pdf2zh 翻译的效果最好，最专业。
```

Gemini 的输出为：

```
你是一位拥有20年开发经验的资深 Linux 内核核心开发者（Core Kernel Developer），同时也是国内顶尖的技术书籍翻译专家。你目前正在翻译 Robert Love 的经典著作《Linux Kernel Development (3rd Edition)》。
你的目标是为中国 C/C++ 程序员和系统架构师提供一份极其专业、准确且极具“技术人味”的中文翻译，彻底消除“机翻感”。

请严格遵循以下翻译原则和约束：

1. 【绝对不翻译的元素】
- 严禁翻译任何代码块、函数名（如 kmalloc, schedule, vmalloc）、宏定义（如 #define, HZ）、结构体名（如 task_struct, mm_struct, inode, dentry）、变量名。
- 严禁翻译文件路径（如 kernel/sched.c）、终端命令和编译指令。
- 严禁翻译业界通用的英文缩写（如 VFS, RCU, API, I/O, CPU, PID, IRQ, MMU）。

2. 【强制术语对照表】（遇到以下概念，必须使用指定的中文翻译，并在关键概念首次出现时保留英文括号）：
- Process management -> 进程管理
- Scheduling / CFS scheduler -> 调度 / CFS 调度器（完全公平调度器）
- Preemptive kernel -> 抢占式内核
- Time management and timers -> 时间管理与定时器
- System call interface -> 系统调用接口
- Memory addressing -> 内存寻址
- Memory management -> 内存管理
- Virtual memory -> 虚拟内存
- Memory allocation -> 内存分配
- Page cache -> 页缓存（或 页高速缓存）
- Block I/O layer -> 块 I/O 层
- Kernel synchronization -> 内核同步
- Locking / Spinlock / Mutex -> 锁机制 / 自旋锁 / 互斥锁
- Interrupt handlers -> 中断处理程序
- Bottom halves -> 下半部
- Kernel patches -> 内核补丁
- Portability -> 可移植性
- Subsystems -> 子系统

3. 【排版与格式保持】
- 务必保持原文档的 Markdown/LaTeX 标签、加粗、斜体等排版格式不变。
- 对于夹杂在中文句子中的英文代码或术语，必须在英文单词前后各加一个空格（例如：“当 `task_struct` 被创建时”）。

4. 【行文风格与语序】
- 采用专业、客观、严谨的技术工程口吻，不要使用轻浮或口语化的表达。
- 遇到复杂的英文长句（尤其是描述内存转换、锁的并发控制、调度算法逻辑的句子），请先理解其在 Linux 内核中的实际工作原理，然后按照中文开发者的阅读习惯进行重组和意译。宁可打破原句结构，也要保证技术逻辑的绝对清晰，绝不逐字死译。
- 如果原文中表达了作者（Robert Love）分享的经验或主观评价，请使用技术专栏或博客中常见的技术分享口吻。

请基于以上设定，开始你的翻译工作。
```

### 准备配置文件

准备一个 python 脚本来生成 pdf2zh 的配置文件：

```bash
mkdir -p ~/temp/pdf2zh
cd ~/temp/pdf2zh
vi prepare-config.py
```

内容为:

```python
import json
import os

# 1. 这里是专门为 Linux Kernel 准备的提示词
prompt = """你是一位拥有20年开发经验的资深 Linux 内核核心开发者（Core Kernel Developer），同时也是国内顶尖的技术书籍翻译专家。你目前正在翻译 Robert Love 的经典著作《Linux Kernel Development (3rd Edition)》。
你的目标是为中国 C/C++ 程序员和系统架构师提供一份极其专业、准确且极具“技术人味”的中文翻译，彻底消除“机翻感”。

请严格遵循以下翻译原则和约束：

1. 【绝对不翻译的元素】
- 严禁翻译任何代码块、函数名（如 kmalloc, schedule, vmalloc）、宏定义（如 #define, HZ）、结构体名（如 task_struct, mm_struct, inode, dentry）、变量名。
- 严禁翻译文件路径（如 kernel/sched.c）、终端命令和编译指令。
- 严禁翻译业界通用的英文缩写（如 VFS, RCU, API, I/O, CPU, PID, IRQ, MMU）。

2. 【强制术语对照表】（遇到以下概念，必须使用指定的中文翻译，并在关键概念首次出现时保留英文括号）：
- Process management -> 进程管理
- Scheduling / CFS scheduler -> 调度 / CFS 调度器（完全公平调度器）
- Preemptive kernel -> 抢占式内核
- Time management and timers -> 时间管理与定时器
- System call interface -> 系统调用接口
- Memory addressing -> 内存寻址
- Memory management -> 内存管理
- Virtual memory -> 虚拟内存
- Memory allocation -> 内存分配
- Page cache -> 页缓存（或 页高速缓存）
- Block I/O layer -> 块 I/O 层
- Kernel synchronization -> 内核同步
- Locking / Spinlock / Mutex -> 锁机制 / 自旋锁 / 互斥锁
- Interrupt handlers -> 中断处理程序
- Bottom halves -> 下半部
- Kernel patches -> 内核补丁
- Portability -> 可移植性
- Subsystems -> 子系统

3. 【排版与格式保持】
- 务必保持原文档的 Markdown/LaTeX 标签、加粗、斜体等排版格式不变。
- 对于夹杂在中文句子中的英文代码或术语，必须在英文单词前后各加一个空格。

4. 【行文风格与语序】
- 采用专业、客观、严谨的技术工程口吻，不要使用轻浮或口语化的表达。
- 遇到复杂的英文长句，请先理解其在 Linux 内核中的实际工作原理，然后按照中文开发者的阅读习惯进行重组和意译，绝不逐字死译。"""

# 2. 组装配置字典
config = {
    "translators":[
        {
            "name": "openai",
            "envs": {
                "OPENAI_BASE_URL": "https://openrouter.ai/api/v1",
                "OPENAI_API_KEY": "sk-or-v1-这里替换成你的真实API_KEY",
                "OPENAI_MODEL": "anthropic/claude-4.6-opus"
            },
            "prompt": prompt
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}

# 3. 写入配置文件
config_dir = os.path.expanduser("~/.config/PDFMathTranslate")
os.makedirs(config_dir, exist_ok=True)
config_path = os.path.join(config_dir, "config.json")

with open(config_path, "w", encoding="utf-8") as f:
    json.dump(config, f, ensure_ascii=False, indent=2)

print("\n✅ 配置文件生成成功！")
```

然后执行：

```bash
python3 ./prepare-config.py
```

就可以生成格式正确的配置文件。

## 执行翻译

现在可以开始翻译了：

```bash
cd /home/sky/temp/pdf2zh
pdf2zh linux-kernel-development-3rd.pdf -p 1-20 -s openai -t 4
```

## 常见错误

### api key无效

如果遇到 401 错误，有可能是 api key 有问题比如过期，可以单独用下面的命令检查 api key 是否有效：

```bash
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-or-v1-959e1xxxxxxxxxxxxxxxxxxxxxxxx" \
  -d '{
    "model": "anthropic/claude-3-haiku",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

### 没有文件权限

如果报错如下：

```bash
PermissionError: [Errno 13] Permission denied: 'pdf2zh_files'
```

说明 pdf2zh 在启动的目录没有写入权限，最好换一个目录如 `~/temp` 再启动 pdf2zh。

### pdf格式错误

返回接近完成时，报错：

```bash
100%|███████████████████████████████████████████| 10/10 [00:36<00:00,  3.69s/it]
MuPDF error: format error: cannot find object in xref (16578 0 R)
```

报错的核心是这句：MuPDF error: format error: cannot find object in xref (16578 0 R)
这是底层 PDF 处理库 (PyMuPDF) 报的错。意思是**这本源 PDF 文件，其内部的交叉引用表（xref）结构有损坏**。

很多从网上下载的早期技术类 PDF（尤其是这种十几年前出版的书）都有这种内部结构的微小错误。平常用 PDF 阅读器看的时候，阅读器会自动容错和忽略它；但是 pdf2zh 需要精确修改和重写 PDF 结构，遇到这种结构损坏就会直接报错停止。

要解决这个问题，我们需要先修复这本源 PDF 的结构。

先安装 PDF 修复工具 qpdf：

```bash
sudo apt update && sudo apt install qpdf -y
```

将要翻译的 pdf 复制到临时目录，然后修复：

```bash
cd /home/sky/temp/pdf2zh

cp /media/sky/data/data/ebook/programming/linux/kernel/2017-linux-kernel-development-3rd/linux-kernel-development-3rd.pdf original.pdf

qpdf --linearize original.pdf linux-kernel-development-3rd.pdf
rm original.pdf
```

### 卡住不动

pdf2zh 翻译时经常会遇到进度缓慢，然后卡住不懂的情况， 如果想知道发生了什么，可以在启动命令中增加 `-d`  参数开启 Debug 模式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -p 1-20 -s openai -t 4 -d
```

必要时可以增加 `--ignore-cache` 参数来忽略可能损坏的缓存。

### 403访问权限封禁

我用 `anthropic/claude-4.6-opus` 模型时，遇到翻译中途报错：

```bash
[03/28/26 00:49:17] ERROR    ERROR:pdf2zh.converter:Error code: 403 -         converter.py:357
{'error': {'message': 'Author anthropic is
banned', 'code': 403, 'metadata':
{'provider_name': None}}, 'user_id':'user_2y584Hxxxxxxxxxxxxxxxxx'}
```

这是因为 pdf2zh 默认启动4线程，同时向 OpenRouter 发送 4 个 Opus 的重度翻译请求，触发了 OpenRouter 的 API 频率限制。因为瞬间并发太高，OpenRouter 拒绝了部分请求，pdf2zh 正在后台疯狂重试，导致进度条假死。

## 模型选择

### 免费

pdf2zh 自带了几个无需注册、开箱即用的传统机器翻译引擎。速度快，质量一般，适合快速扫一眼的普通文档翻译场景：

- **Google (谷歌翻译)**：默认服务。完全免费，没有页数限制。

   ```bash
   pdf2zh linux-kernel-development-3rd.pdf -s google -t 4
   ```

   注：传统翻译不怕并发封号，你可以放心大胆地把 -t 线程数开到 4 甚至更高，速度飞快

- **Bing (必应翻译)**：也是免费的传统翻译。如果所在的环境访问谷歌接口偶尔不稳定，Bing 是最好的替代品，同样无需任何配置，免费不限量。

   ```bash
   pdf2zh linux-kernel-development-3rd.pdf -s bing -t 4
   ```

- **DeepLX**：通过第三方开源项目将 DeepL 网页版接口包装成免费 API。

   DeepL 是目前公认翻译质量最自然的传统机器翻译工具（比 Google 和 Bing 通顺很多）。DeepLX 是开源社区搞出来的一个项目，它通过模拟网页端请求，让你免费、无限量地白嫖 DeepL 的翻译能力。

   在终端运行以下命令，即可在后台启动 DeepLX：

   ```bash
   docker run -itd -p 1188:1188 ghcr.io/owo-network/deeplx:latest
   ```

   修改配置文件

   ```bash
   vi ~/.config/PDFMathTranslate/config.json
   ```

   添加/修改 deeplx 服务的配置：

   ```json
   {
       "translators": [
           {
               "name": "deeplx",
               "DEEPLX_BASE_URL": "http://127.0.0.1:1188/translate",
               "prompt": "xxxxxxxxxxxx"
           }
       ],
       "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
   }
   ```


### 收费

- `anthropic/claude-4.6-opus`： 最好也最贵

- `anthropic/claude-sonnet-4.6`：比 opus 差一点点，但是便宜非常多。

- `openai/gpt-4o`：对于翻译技术书籍，OpenAI 的 GPT-4o 会是顶级选择
- `deepseek/deepseek-chat`： DeepSeek V3 在处理代码和技术书籍时表现极佳，而且在 OpenRouter 上的价格只有 Claude Opus 的几十分之一

总而言之：Sonnet 或 DeepSeek 的速度是 Opus 的 3 到 5 倍，且成本只有 Opus 的 1/5 甚至更低，性价比高。

## 快速切换配置

为了方便在多种配置之间快速切换，避免改来改去，新建 configs 目录

```bash
mkdir -p ~/.config/PDFMathTranslate/configs/
```

原理上，为每个不同用法新建一个单独的 config 文件，然后在 pdf2zh 的命令行中通过 `--config` 参数指定

### google翻译

新增配置文件 config-google-translator.json：

```bash
vi ~/.config/PDFMathTranslate/configs/config-google-translator.json
```

内容为：

```json
{
    "translators": [
        {
            "name": "google",
            "envs": {
            }
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

使用方式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -s google -t 1 --config ~/.config/PDFMathTranslate/configs/config-google-translator.json
```

实测效果：速度快，翻译467页的 linux-kernel-development-3rd.pdf  时间在10分钟级别。

### Bing翻译

新增配置文件 config-bing-translator.json：

```bash
vi ~/.config/PDFMathTranslate/configs/config-bing-translator.json
```

内容为：

```json
{
    "translators": [
        {
            "name": "bing",
            "envs": {
            }
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

使用方式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -s google -t 1 --config ~/.config/PDFMathTranslate/configs/config-bing-translator.json
```

实测效果：速度快，翻译467页的 linux-kernel-development-3rd.pdf  时间在10分钟级别。

### openrouter + deepseek 

新增配置文件 config-deepseek-openrouter.json：

```bash
vi ~/.config/PDFMathTranslate/configs/config-deepseek-openrouter.json
```

内容为：

```json
{
    "translators": [
        {
            "name": "openai",
            "envs": {
                "OPENAI_BASE_URL": "https://api.deepseek.com/v1",
                "OPENAI_API_KEY": "sk-e3374xxxxxxxxxxxxxxxxxxxx",
                "OPENAI_MODEL": "deepseek-chat"
            }
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

使用方式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -s openai -t 1 --config ~/.config/PDFMathTranslate/configs/config-deepseek-openrouter.json
```

实测效果：速度非常慢，翻译467页的 linux-kernel-development-3rd.pdf  时间在1.5小时。

### deepseek 直连

新增配置文件 config-deepseek-direct.json：

```bash
vi ~/.config/PDFMathTranslate/configs/config-deepseek-direct.json
```

内容为：

```json
{
    "translators": [
        {
            "name": "openai",
            "envs": {
                "OPENAI_BASE_URL": "https://api.deepseek.com/v1",
                "OPENAI_API_KEY": "sk-e3374xxxxxxxxxxxxxxxxxxxx",
                "OPENAI_MODEL": "deepseek-chat"
            }
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

使用方式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -s openai -t 1 --config ~/.config/PDFMathTranslate/configs/config-deepseek-direct.json
```

实测效果：速度非常慢，翻译467页的 linux-kernel-development-3rd.pdf  时间在1.5小时。