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
    "translators": [
        {
            "name": "openai",
            "envs": {
                "OPENAI_BASE_URL": "https://openrouter.ai/api/v1",
                "OPENAI_API_KEY": "sk-or-v1-90c66f9c7xxxxxxxxxxxxxxxxxxxxxxxx",
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
    "translators": [
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

### 定制提示词

测试一下实际翻译效果，以经典的 linux-kernel-development-3rd.pdf 为例。

为了提高翻译效果，我准备了一段 Prompt：

```bash
vi ~/.config/PDFMathTranslate/it_book_prompt.txt
```

内容为：

```bash
你是一位同时精通中英文的资深IT技术专家，也是顶级技术图书（如 O'Reilly、机械工业出版社）的首席金牌译者。你具有极深厚的>计算机科学功底，深刻理解各类编程语言、系统架构与软件工程原理。
你现在的任务是翻译一本IT技术书籍的内容。你的翻译目标是：准确传达技术原意（信）、符合中国程序员的表达习惯（达）、行文专
业且具有技术专栏的流畅感（雅），彻底消除“机翻感”。

请你在后台静默执行以下翻译思考过程，但【绝对不要打印出思考过程】，你必须直接给出最终的翻译结果：
1. 语境分析：理解该段落在讲什么技术概念，前后逻辑关系是什么。
2. 术语识别：识别出所有代码片段、函数名、专有名词和行业标准缩写。
3. 意译重构：打破英文原句的定语从句和长难句结构，用中国程序员最习惯的语序和技术口吻进行重写。

为了配合 PDF 自动排版引擎，请你必须严格遵守以下极其严苛的【绝对规则】：

1. 【零废话输出（致命要求）】
绝不输出任何引导语、解释、或是“好的，翻译如下”、“这段话的意思是”等废话。你的输出必须且只能是翻译后的纯文本，用于原封不
动地替换源文件。

2. 【原样保留的元素】
- 严禁翻译任何代码块、函数名（如 main(), map()）、类名、变量名、配置项。
- 严禁翻译文件路径、终端命令（如 git commit）、编译指令、URL。
- 严禁翻译业界通用的英文缩写（如 API, CPU, GPU, I/O, JSON, HTTP, DOM, GUI, K8s, IP 等）。
- 若文中出现带有特殊符号的代码词汇（如 `<script>`, `__init__`, `*args`），必须原样保留。

3. 【中英文排版规范（盘古之白）】
- 在中文字符与英文字符/数字之间，必须强行加上一个半角空格（例如：“配置 `WebPack` 的过程”、“在 Python 3 中运行”）。
- 务必完美保留原文中的所有 Markdown 符号、LaTeX 公式标签（如 **加粗**、*斜体*、`代码片段`）、列表编号和换行符。绝不能>丢失任何一个排版标签！

4. 【行文风格与技术人味】
- 采用专业、客观、严谨的技术工程口吻，不要使用轻浮或口语化的表达。
- 遇到非常冗长的英文复合句时，请将其拆分为多个简短的中文短句。
- 宁可意译，也不要死板的字对字直译。例如，不要把 "it makes sense to..." 翻译成“它有意义去...”，而应翻译为“...是合理的”或“通常建议...”。
- 遇到带有比喻色彩的技术俚语（如 under the hood, boilerplate），请直接翻译为其对应的技术含义（如“底层原理”、“样板代码”）。
- 保持文字简洁，在表达清晰的前提下，尽量字数少一些

5. 【强制技术术语对照表（Glossary）】
当你遇到以下英文词汇时，必须严格使用对应的中文翻译，绝不可使用其他同义词（在特别生僻的概念首次出现时，请在中文后用括号保留英文原文）：

# 操作系统与内核底层
- Kernel -> 内核
- Process -> 进程
- Thread -> 线程
- Daemon -> 守护进程
- Context switch -> 上下文切换
- System call (syscall) -> 系统调用
- Interrupt -> 中断
- Exception -> 异常
- Trap -> 陷阱
- Signal -> 信号
- Semaphore -> 信号量
- Mutex (Mutual Exclusion) -> 互斥锁
- Spinlock -> 自旋锁
- Deadlock -> 死锁
- Race condition -> 竞态条件
- Critical section -> 临界区
- Concurrency -> 并发
- Parallelism -> 并行

# 内存管理
- Memory Management Unit (MMU) -> 内存管理单元
- Virtual Memory -> 虚拟内存
- Page -> 页 / 内存页
- Page Table -> 页表
- Page fault -> 缺页异常 / 缺页中断
- Cache -> 缓存
- Buffer -> 缓冲区
- Heap -> 堆
- Stack -> 栈
- Pointer -> 指针
- Memory leak -> 内存泄漏
- Segmentation fault -> 段错误

# 存储与文件系统
- File system -> 文件系统
- Directory -> 目录（绝不要翻译为“文件夹”）
- Inode -> 索引节点 (inode)
- Mount -> 挂载
- Block device -> 块设备
- Character device -> 字符设备
- Sector -> 扇区

# 编程与通用架构
- Instance -> 实例
- Runtime -> 运行时
- Framework -> 框架
- Middleware -> 中间件
- Interface -> 接口
- Parameter / Argument -> 参数
- Return value -> 返回值
- Macro -> 宏
- Deprecated -> 废弃的 / 不推荐使用的
- Hardcode -> 硬编码
- Refactor -> 重构
- Deploy -> 部署
- Overhead -> 开销
- Scalability -> 可扩展性
- Robustness -> 健壮性 / 鲁棒性
- Transparent -> 透明的（在IT语境中通常指“对用户不可见/无需感知的”）

请基于以上所有规则，直接输出你的最终翻译结果。
```

TODO: prompt 待继续完善

## 执行翻译

现在可以开始翻译了：

```bash
cd /home/sky/temp/pdf2zh
pdf2zh linux-kernel-development-3rd.pdf --prompt ~/.config/PDFMathTranslate/it_book_prompt.txt -p 1-20 -s openai -t 4
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

   注：传统翻译不怕并发封号，可以把 -t 线程数开到 4 甚至更高，速度快

- **Bing (必应翻译)**：也是免费的传统翻译。如果所在的环境访问谷歌接口偶尔不稳定，可以试试 Bing 

   ```bash
   pdf2zh linux-kernel-development-3rd.pdf -s bing -t 4
   ```

### 收费

- `anthropic/claude-4.6-opus`： 最好也最贵

- `anthropic/claude-sonnet-4.6`：比 opus 差一点点，但是便宜非常多。

- `openai/gpt-4o`：对于翻译技术书籍，OpenAI 的 GPT-4o 会是顶级选择
- `deepseek/deepseek-chat`： DeepSeek V3 在处理代码和技术书籍时表现极佳，而且在 OpenRouter 上的价格只有 Claude Opus 的几十分之一

总而言之：Sonnet 或 DeepSeek 的速度比 Opus 好，而且成本更低，性价比高。

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

### openrouter + opus 

新增配置文件 config-openrouter-opus.json：

```bash
vi ~/.config/PDFMathTranslate/configs/config-openrouter-opus.json
```

内容为：

```json
{
    "translators": [
        {
            "name": "openai",
            "envs": {
                "OPENAI_BASE_URL": "https://openrouter.ai/api/v1",
                "OPENAI_API_KEY": "sk-or-v1-90c66f9c7xxxxxxxxxxxxxxxxxxxxxxxx",
                "OPENAI_MODEL": "anthropic/claude-4.6-opus"
            }
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

使用方式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -s openai -t 1 --config ~/.config/PDFMathTranslate/configs/config-openrouter-opus.json --prompt ~/.config/PDFMathTranslate/it_book_prompt.txt
```

问题：哪怕只用一个线程，也会被 banned

### jiekou + sonnet 

新增配置文件 config-jiekou-sonnet.json：

```bash
vi ~/.config/PDFMathTranslate/configs/config-jiekou-sonnet.json
```

内容为：

```json
{
    "translators": [
        {
            "name": "openai",
            "envs": {
                "OPENAI_BASE_URL": "https://api.jiekou.ai/openai",
                "OPENAI_API_KEY": "sk_JscMPplxxxxxxxxxxxxxxxxx",
                "OPENAI_MODEL": "claude-sonnet-4-6"
            }
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

使用方式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -s openai -t 1 --config ~/.config/PDFMathTranslate/configs/config-jiekou-sonnet.json --prompt ~/.config/PDFMathTranslate/it_book_prompt.txt
```

问题： 总是很快（一般3-5页）就报错 RateLimitError，虽然还能继续，但是速度就严重降低.
原因： jiekou.ai 这个中转网站限速，充值升级等级之后配额限制放大就不会再报这个错误了。


### jiekou + gemini-flash 

新增配置文件 config-jiekou-gemini-flash.json：

```bash
vi ~/.config/PDFMathTranslate/configs/config-jiekou-gemini-flash.json
```

内容为：

```json
{
    "translators": [
        {
            "name": "openai",
            "envs": {
                "OPENAI_BASE_URL": "https://api.jiekou.ai/openai",
                "OPENAI_API_KEY": "sk_JscMPpl32z2sxxxxxxxxxxxxxxxxxx",
                "OPENAI_MODEL": "gemini-2.5-flash"
            }
        }
    ],
    "NOTO_FONT_PATH": "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
}
```

使用方式：

```bash
pdf2zh linux-kernel-development-3rd.pdf -s openai -t 1 --config ~/.config/PDFMathTranslate/configs/config-jiekou-gemini-flash.json --prompt ~/.config/PDFMathTranslate/it_book_prompt.txt
```


