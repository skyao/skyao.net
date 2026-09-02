+++
title = "pdf2zh_next实践"
date =  2026-09-02
lastmod = 2026-09-02
draft = false

tags = ["PDF", "翻译"]
summary = "使用 pdf2zh_next 进行 pdf 文件中文翻译"
abstract = "使用 pdf2zh_next 进行 pdf 文件中文翻译"

[header]
image = ""
caption = ""

+++

## 准备工作

### 安装

安装非常简单流畅：

```bash
# 先卸载之前安装的 pdf2zh
python -m pip uninstall pdf2zh

# 安装新版本的 pdf2zh_next
pip install pdf2zh_next
```

安装完成后，可以使用 pdf2zh2 命令：

```bash
➜  temp which pdf2zh     
pdf2zh not found
➜  temp which pdf2zh2
/home/sky/.pyenv/shims/pdf2zh2
➜  temp which pdf2zh2_next
pdf2zh2_next not found
➜  temp pdf2zh2 --version    
[09/02/26 14:48:38] WARNING  WARNING:pdf2zh_next.config.cli_env_model:No translation engine         cli_env_model.py:103
                             selected, using SiliconFlow Free                                                           
                    INFO     INFO:pdf2zh_next.config.model:Using translation engine: SiliconFlowFree        model.py:275
                    WARNING  WARNING:pdf2zh_next.config.cli_env_model:No translation engine         cli_env_model.py:103
                             selected, using SiliconFlow Free                                                           
pdf2zh-next version: 2.9.0
```

### 生成默认配置

执行命令：

```bash
pdf2zh_next --gui
```

之后打开地址如  http://192.168.3.182:7860/ 

填写基本配置信息：

- Translate from: English
- Translate to: simplified Chinese
- Service: Deepseek
- DeepSeek model to use: deepseek-v4-flash
- API key for DeepSeek service: xxxxxxxxxxxx
- 勾选 Enable JSON mode for DeepSeek service
- Thinking mode for DeepSeek v4 models (enabled/disabled)： enabled
- Reasoning effort for DeepSeek thinking mode (high/max)： high
- Rate Limit Mode：Custom
- QPS (Queries Per Second)： 4
- Auto Term Extraction
- 不要勾选 Enable auto term extraction
- Pages： All

默认配置文件保存在 `~/.config/pdf2zh/config.v3.toml`。

### 字体文件

我的 linux mint 系统上安装有 文泉驿微米黑 字体，我准备在生成的 pdf 中用这个字体，先找到字体的位置：

```bash
fc-list | grep wqy-microhei
/usr/share/fonts/truetype/wqy/wqy-microhei.ttc: WenQuanYi Micro Hei,文泉驛微米黑,文泉驿微米黑:style=Regular
/usr/share/fonts/truetype/wqy/wqy-microhei.ttc: WenQuanYi Micro Hei Mono,文泉驛等寬微米黑,文泉驿等宽微米黑:style=Regular
```

打开配置文件:

```bash
vi ~/.config/pdf2zh/config.v3.toml
```

设置字体为 文泉驿微米黑：

```toml
[translation]
primary_font_family = "sans-serif"
```

新版没有旧版那种 NOTO_FONT_PATH/font_file 字段，字体族由这个参数控制，sans-serif 会映射到思源黑体 Source Han Sans CN

### api key

准备好 deepseek 和 GLM 的 api key，重点使用 deepseek v4 flash 和 GLM-5.3-Flash。

```bash
vi ~/.config/pdf2zh/config.v3.toml
```

修改配置内容如下：

```toml
deepseek = true
zhipu = false

[deepseek_detail]
translate_engine_type = "DeepSeek"
support_llm = "yes"
deepseek_model = "deepseek-v4-flash"
deepseek_api_key = "sk-xxxxxxxxxxxxxxxx"
deepseek_enable_json_mode = true
deepseek_thinking_mode = "enabled"
deepseek_reasoning_effort = "high"

[zhipu_detail]
translate_engine_type = "Zhipu"
support_llm = "yes"
zhipu_model = "glm-5.3-flash"
zhipu_api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
zhipu_enable_json_mode = "true"
```

### 翻译配置

```bash
vi ~/.config/pdf2zh/config.v3.toml
```

其他配置内容如下：

```toml
report_interval = 10
[translation]
qps = 20
pool_max_workers = 20
term_qps = 8
term_pool_max_workers = 8
no_auto_extract_glossary = true

[pdf]
# 双语翻译时使用奇偶页交替（原文页后面紧跟译文页），而不是默认的左右分栏
use_alternating_pages_dual = false
```

### 定制提示词

为了提高翻译效果，我准备了一段 Prompt ：

```bash
你是一名资深的中英文科技翻译专家，精通人工智能、机器学习与计算机科学领域，负责将英文 AI 学术论文和技术文档翻译为规范、专业、通顺的简体中文（zh-CN），译文需达到学术出版级水准。

翻译要求：
1. 信：忠实完整地传达原文技术含义与论证逻辑，不增译、不删减、不改写观点，确保信息零丢失。
2. 达：不逐字直译，按中文技术表达习惯重组长难句，消除机翻感；宁意译勿死译。
3. 术语：专业术语采用学界通行译名，同一术语在译文内保持稳定统一；人名、机构名、模型/方法/数据集名（如 Transformer、LoRA、GPT、ImageNet）及业界通用缩写（API、GPU、JSON 等）保留英文原文。不要在译文中额外添加原文的括号注释。
4. 文体：使用规范严谨的书面技术中文，避免口语化与翻译腔；长句拆分为多个短句，逻辑清晰。

格式铁律：
5. 输出必须且只能是译文纯文本，禁止任何引导语、解释、评论或额外文字。
6. 原样保留公式占位符 {{v}}、代码、函数名、变量名、文件路径、URL、LaTeX/Markdown 排版标记、列表编号与换行符，严禁翻译或改动，一个都不能丢。
7. 若源文本过短或仅含数字、符号、公式，原样返回即可。

请直接输出最终翻译结果。
```

```bash
vi ~/.config/pdf2zh/config.v3.toml
```

```bash
[translation]
custom_system_prompt = """
你是一名资深的中英文科技翻译专家，精通人工智能、机器学习与计算机科学领域，负责将英文 AI 学术论文和技术文档翻译为规范、专业、通顺的简体中文（zh-CN），译文需达到学术出版级水准。

翻译要求：
1. 信：忠实完整地传达原文技术含义与论证逻辑，不增译、不删减、不改写观点，确保信息零丢失。
2. 达：不逐字直译，按中文技术表达习惯重组长难句，消除机翻感；宁意译勿死译。
3. 术语：专业术语采用学界通行译名，同一术语在译文内保持稳定统一；人名、机构名、模型/方法/数据集名（如 Transformer、LoRA、GPT、ImageNet）及业界通用缩写（API、GPU、JSON 等）保留英文原文。不要在译文中额外添加原文的括号注释。
4. 文体：使用规范严谨的书面技术中文，避免口语化与翻译腔；长句拆分为多个短句，逻辑清晰。

格式铁律：
5. 输出必须且只能是译文纯文本，禁止任何引导语、解释、评论或额外文字。
6. 原样保留公式占位符 {{v}}、代码、函数名、变量名、文件路径、URL、LaTeX/Markdown 排版标记、列表编号与换行符，严禁翻译或改动，一个都不能丢。
7. 若源文本过短或仅含数字、符号、公式，原样返回即可。

请直接输出最终翻译结果。
"""
```

### 定制术语表

```bash
vi ~/.config/pdf2zh/glossary_ai.csv
```

内容为：

```bash
source,target,tgt_lng
task decomposition,任务分解,zh-CN
subtask,子任务,zh-CN
orchestration,编排,zh-CN
orchestrator,编排器,zh-CN
environment,环境,zh-CN
observation,观测,zh-CN
reward,奖励,zh-CN
reward model,奖励模型,zh-CN
policy,策略,zh-CN
reinforcement learning,强化学习,zh-CN
sandbox,沙箱,zh-CN
guardrails,护栏,zh-CN
reflection,反思,zh-CN
self-reflection,自我反思,zh-CN
retrieval-augmented generation,检索增强生成,zh-CN
RAG,检索增强生成,zh-CN
retriever,检索器,zh-CN
retrieval,检索,zh-CN
knowledge base,知识库,zh-CN
knowledge graph,知识图谱,zh-CN
vector database,向量数据库,zh-CN
vector store,向量存储,zh-CN
semantic search,语义检索,zh-CN
multimodal,多模态,zh-CN
multi-modal,多模态,zh-CN
vision-language model,视觉语言模型,zh-CN
language model,语言模型,zh-CN
machine learning,机器学习,zh-CN
deep learning,深度学习,zh-CN
artificial intelligence,人工智能,zh-CN
computer vision,计算机视觉,zh-CN
natural language processing,自然语言处理,zh-CN
natural language understanding,自然语言理解,zh-CN
text generation,文本生成,zh-CN
image generation,图像生成,zh-CN
summarization,摘要,zh-CN
question answering,问答,zh-CN
knowledge distillation,知识蒸馏,zh-CN
quantization,量化,zh-CN
pruning,剪枝,zh-CN
low-rank adaptation,低秩适配,zh-CN
LoRA,LoRA,zh-CN
scaling law,缩放定律,zh-CN
emergent ability,涌现能力,zh-CN
open-source model,开源模型,zh-CN
proprietary model,闭源模型,zh-CN
closed-source model,闭源模型,zh-CN
latency,延迟,zh-CN
throughput,吞吐量,zh-CN
chatbot,聊天机器人,zh-CN
conversation,对话,zh-CN
temperature,温度,zh-CN
sampling,采样,zh-CN
beam search,束搜索,zh-CN
autoregressive,自回归,zh-CN
context,上下文,zh-CN
fine-tuned model,微调模型,zh-CN
pre-trained model,预训练模型,zh-CN
pretrained model,预训练模型,zh-CN
```

备注：术语表内容后续再完善。

修改配置：

```bash
vi ~/.config/pdf2zh/config.v3.toml
```

加入术语表文件，注意检查 no_auto_extract_glossary 要设置为 true：

```toml
glossaries = "/home/sky/.config/pdf2zh/glossary_ai.csv"
no_auto_extract_glossary = true
```

## 执行翻译

### 翻译命令

现在可以开始翻译了：

```bash
cd /home/sky/temp/pdf2zh

# 默认用 deepseek 翻译
pdf2zh2 2607.29069v1.pdf

# 指定用智谱翻译
pdf2zh2 2607.29069v1.pdf --zhipu
```

### 翻译选项

#### 引擎选择

主翻译引擎，每组互斥，一次只能选一个，对应 toml 顶部布尔开关，命令行传了会覆盖配置文件里的布尔值：

```bash
--deepseek

--zhipu

--openai

--gemini

--siliconflowfree
```

目前仅仅使用 deepseek 和 zhipu，其中 deepseek 为默认值。后面可以考虑试试 siliconflowfree 这个免费的看看效果。

#### 行为控制

| 参数                           | 作用                                      | 备注                                                         |
| ------------------------------ | ----------------------------------------- | ------------------------------------------------------------ |
| `--config-file`                | 指定配置文件                              | 目前通过 toml 集中管理，不需要指定                           |
| `--ignore-cache`               | **忽略翻译缓存，强制重翻**                | ⚠️ 关键坑：改了提示词/术语表后**不加它会被旧缓存命中**，等于白改。但平时不想要重复花钱时**别加**（缓存能省钱，DeepSeek 缓存命中价极低） |
| `--pages`                      | 只翻指定页，如 `1,2,1-,-3,3-5`            | 调试用；配 `--only-include-translated-page` 可只输出所选页   |
| `--qps` / `--pool-max-workers` | 并发控制                                  | 现在默认 25/25；QPS 是请求速率，workers 是并发线程，**workers 不设时默认跟随 qps** |
| `--no-auto-extract-glossary`   | 禁用自动术语提取                          | 配置里已设 true，命令行可不带                                |
| `--glossaries`                 | 指定术语表 CSV                            | 配置里已设，命令行可不带；以后如果有高级用法再说             |
| `--custom-system-prompt`       | 自定义系统提示词                          | 配置里已设，命令行可不带                                     |
| `--primary-font-family`        | 字体族覆盖：`serif`/`sans-serif`/`script` | 配置里已设，命令行可不带                                     |
| `--lang-in` / `--lang-out`     | 源/目标语言                               | 默认 en→zh-CN，一般不用改                                    |
| `--output`                     | 输出目录                                  | 建议固定一个目录便于管理                                     |
| `--min-text-length`            | 短于该长度的文本不翻译                    | 默认 5，过滤孤立数字/符号                                    |
| `--no-dual` / `--no-mono`      | 控制输出                                  | 默认中文和中英文双语都输出，一般不用修改                     |
| --dual-translate-first         | 双语 PDF 里译文页放前面                   | 默认原文在前，一般不用修改                                   |
| --use-alternating-pages-dual   | 双语模式从"左右分栏"改成"奇偶页交替"      | 配置文件已设置，更适合手机/平板阅读                          |
| --watermark-output-mode        | `watermarked` / `no_watermark` / `both`   | 配置文件已设 no_watermark                                    |
| --report-interval              | 进度刷新间隔                              | 默认 0.2s，日志刷屏时可以调大                                |
| --warmup                       | 只下载/校验资源后退出                     | **换机器/离线部署前先跑一次**很省心（避免第一次下载字体等半天） |
| --debug                        |                                           | 出问题想看详细堆栈时开                                       |

#### 特殊文档适用

| 参数                           | 作用                              | 备注                                  |
| ------------------------------ | --------------------------------- | ------------------------------------- |
| `--auto-enable-ocr-workaround` | 检测到重度扫描件自动启用 OCR 兼容 | 翻译扫描版 pdf 时建议开               |
| `--ocr-workaround`             | 强制译文黑字+白底                 | 对 OCR 件有用                         |
| `--enhance-compatibility`      | 一键开启全部兼容性增强            | 遇到翻译后排版错乱/重影可试           |
| `--max-pages-per-part`         | 超大文档分块翻译                  | 防止长文档中断/超时                   |
| `--translate-table-text`       | 翻译表格文字                      | 实验性                                |
| `--skip-clean`                 | 跳过 PDF 清理                     | 某些特殊 PDF 解析失败时可试，通常不开 |
| `--skip-scanned-detection`     | 跳过扫描件检测                    | 确定是文本 PDF 时可加速               |


## 书籍翻译

几百页的书和 10 页论文完全是两个量级，策略要变。

常见的问题是：

1. 成本会到"十几~几十元"量级。之前 10 页论文约 33.6 万 token（其中输出 27.5 万）、约 ¥0.6-0.7。按文字量线性外推，一本 300 页的书 ≈ 30 倍 ≈ ¥20 上下（thinking 开 high 会放大输出 token，是主要成本）。因此一定要先试跑，待确认各种设置都无误之后，再决定值不值得全书翻译。因此，`--pages` 参数非常有用。

2. 翻译时间会到"小时"量级。10 页 3.5 分钟 → 300 页约 1.5-2 小时（如果中间不出错）。

3. 长跑最容易死在"中途出错"，而不是"慢"。API 偶发限流（429）、网络抖动、内存不足都可能中断——所以核心策略是分块 + 断点续跑。

让 AI 写了一个分块翻译的脚本：

```bash
mkdir -p ~/work/soft/pdf2zh

vi ~/work/soft/pdf2zh/pdf2zh_chunk.sh
```

内容为：

```bash
#!/usr/bin/env bash
# pdf2zh_chunk.sh —— pdf2zh_next 分块翻译 + 断点续跑
set -uo pipefail

INPUT=""
START=1
CHUNK=60
QPS=18
POOL=""
OUTDIR="$HOME/pdf2zh_out"
RETRY=2
ENGINE="deepseek"
CONFIG="$HOME/.config/pdf2zh/config.v3.toml"
MONO_ONLY=0
OCR_WORKAROUND=0
FULL_MERGE=1
DRY_RUN=0

usage() {
    cat <<'EOF'
用法: ./pdf2zh_chunk.sh <input.pdf> [选项]

选项:
  --start N          起始页 (默认 1)
  --chunk N          每块页数 (默认 60)
  --qps N            QPS (默认 18, 大书建议保守)
  --pool N           pool-max-workers (默认跟随 qps)
  --output DIR       输出根目录 (默认 ~/pdf2zh_out)
  --retry N          每块失败重试次数 (默认 2)
  --engine NAME      翻译引擎: deepseek|zhipu|openai (默认 deepseek)
  --config FILE      配置文件 (默认 ~/.config/pdf2zh/config.v3.toml)
  --mono-only        只输出单语 PDF (省体积, 大书推荐)
  --ocr              对扫描件启用 OCR 兼容
  --no-full          跳过最后整本整合
  --dry-run          只打印分块计划, 不执行
  --help             显示本帮助
EOF
    exit 0
}

# ---- 参数解析 ----
[[ $# -lt 1 ]] && usage
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h) usage ;;
        --start) START="$2"; shift 2 ;;
        --chunk) CHUNK="$2"; shift 2 ;;
        --qps) QPS="$2"; shift 2 ;;
        --pool) POOL="$2"; shift 2 ;;
        --output) OUTDIR="$2"; shift 2 ;;
        --retry) RETRY="$2"; shift 2 ;;
        --engine) ENGINE="$2"; shift 2 ;;
        --config) CONFIG="$2"; shift 2 ;;
        --mono-only) MONO_ONLY=1; shift ;;
        --ocr) OCR_WORKAROUND=1; shift ;;
        --no-full) FULL_MERGE=0; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        -*)
            if [[ -f "$1" ]]; then INPUT="$1"; shift
            else echo "未知参数: $1 (可用 --help)"; exit 1; fi ;;
        *)
            INPUT="$1"; shift ;;
    esac
done

# ---- 前置检查 ----
[[ -z "$INPUT" ]] && { echo "错误: 未指定输入 PDF"; usage; }
[[ -f "$INPUT" ]] || { echo "错误: 文件不存在: $INPUT"; exit 1; }
[[ -f "$CONFIG" ]] || { echo "警告: 配置文件不存在: $CONFIG"; }

# 引擎 flag
case "$ENGINE" in
    deepseek) ENGINE_FLAG="--deepseek" ;;
    zhipu)    ENGINE_FLAG="--zhipu" ;;
    openai)   ENGINE_FLAG="--openai" ;;
    *) echo "错误: 未知引擎 $ENGINE (deepseek|zhipu|openai)"; exit 1 ;;
esac

# 检测页数
get_total_pages() {
    if command -v pdfinfo >/dev/null 2>&1; then
        pdfinfo "$1" | awk '/^Pages:/{print $2}'
    else
        echo ""
    fi
}
TOTAL=$(get_total_pages "$INPUT")
if [[ -z "$TOTAL" || "$TOTAL" -le 0 ]]; then
    echo "错误: 无法用 pdfinfo 检测页数。请安装 poppler-utils:"
    echo "  sudo apt install poppler-utils    # Debian/Ubuntu"
    exit 1
fi
echo "== 输入: $INPUT ($TOTAL 页)"
echo "== 配置: $CONFIG | 引擎: $ENGINE_FLAG | 每块 $CHUNK 页 | QPS=$QPS"

# ---- 干跑预览 ----
if [[ "$DRY_RUN" == 1 ]]; then
    echo "== [DRY RUN] 分块计划:"
    for (( s=START; s<=TOTAL; s+=CHUNK )); do
        e=$(( s + CHUNK - 1 )); (( e > TOTAL )) && e=TOTAL
        echo "  pages $s-$e -> $OUTDIR/part_$(printf '%04d' $s)-$(printf '%04d' $e)/"
    done
    exit 0
fi

# ---- 单块执行 ----
run_chunk() {
    local range="$1" outdir="$2"
    mkdir -p "$outdir"
    local cmd=( pdf2zh2 "$INPUT" --config-file "$CONFIG" "$ENGINE_FLAG" \
                --pages "$range" --output "$outdir" --qps "$QPS" )
    [[ -n "$POOL" ]] && cmd+=( --pool-max-workers "$POOL" )
    [[ "$MONO_ONLY" == 1 ]] && cmd+=( --no-dual )
    [[ "$OCR_WORKAROUND" == 1 ]] && cmd+=( --auto-enable-ocr-workaround )
    echo ">> [$(date '+%H:%M:%S')] 执行: ${cmd[*]}"
    "${cmd[@]}"
    return $?
}

# ---- 分块主循环 ----
ok_count=0
skip_count=0
fail_list=()

for (( s=START; s<=TOTAL; s+=CHUNK )); do
    e=$(( s + CHUNK - 1 )); (( e > TOTAL )) && e=TOTAL
    part_dir="$OUTDIR/part_$(printf '%04d' $s)-$(printf '%04d' $e)"

    # 断点判断: 有 .done 或已有输出 PDF
    if [[ -f "$part_dir/.done" ]] || compgen -G "$part_dir/*zh-CN*.pdf" >/dev/null; then
        echo "== [跳过] 分块 $s-$e 已完成: $part_dir"
        skip_count=$(( skip_count + 1 ))
        continue
    fi

    attempt=0
    success=0
    while [[ $attempt -le $RETRY ]]; do
        if run_chunk "$s-$e" "$part_dir"; then
            touch "$part_dir/.done"
            echo "== [成功] 分块 $s-$e"
            ok_count=$(( ok_count + 1 ))
            success=1
            break
        else
            attempt=$(( attempt + 1 ))
            echo "!! [失败] 分块 $s-$e 第 $attempt/$RETRY 次"
            [[ $attempt -le $RETRY ]] && sleep 10
        fi
    done
    if [[ $success == 0 ]]; then
        echo "$s-$e" >> "$OUTDIR/.failed"
        fail_list+=("$s-$e")
        echo "!! [放弃] 分块 $s-$e 已达最大重试, 已记录到 $OUTDIR/.failed"
    fi
done

echo ""
echo "==== 分块翻译完成: 成功 $ok_count, 跳过 $skip_count, 失败 ${#fail_list[@]} ===="
[[ ${#fail_list[@]} -gt 0 ]] && echo "失败分块: ${fail_list[*]} (可修复后重跑本脚本续传)"

# ---- 整本整合 ----
if [[ "$FULL_MERGE" == 1 && ${#fail_list[@]} -eq 0 ]]; then
    full_dir="$OUTDIR/full"
    mkdir -p "$full_dir"
    echo ">> [$(date '+%H:%M:%S')] 所有分块完成, 运行整本整合 (命中缓存, 只做排版)..."
    cmd=( pdf2zh2 "$INPUT" --config-file "$CONFIG" "$ENGINE_FLAG" \
          --output "$full_dir" --qps "$QPS" )
    [[ -n "$POOL" ]] && cmd+=( --pool-max-workers "$POOL" )
    [[ "$MONO_ONLY" == 1 ]] && cmd+=( --no-dual )
    echo ">> 执行: ${cmd[*]}"
    if "${cmd[@]}"; then
        echo ""
        echo "==== 整本整合完成 ===="
        ls -lh "$full_dir"
    else
        echo "!! 整本整合失败, 可重跑本脚本 (分块已缓存, 会直接进入整合)"
    fi
else
    echo ""
    echo "跳过整本整合 (原因: --no-full 或存在失败分块)。"
    echo "各分块产物在: $OUTDIR/part_*/"
fi
```

增加可执行权限：

```bash
chmod +x ~/work/soft/pdf2zh/pdf2zh_chunk.sh
```

常用命令：

```bash
cd ~/work/soft/pdf2zh/
mkdir bookname
cd bookname

# 扫描版书（加 OCR 兼容）
../pdf2zh_chunk.sh book.pdf --mono-only --ocr

# 指定引擎换 GLM
../pdf2zh_chunk.sh book.pdf --engine zhipu

# 自定义每块页数/并发（默认 60 页/块，qps 18）
../pdf2zh_chunk.sh book.pdf --chunk 40 --qps 15

# 只翻第 100 页往后
../pdf2zh_chunk.sh book.pdf --start 100
```

考虑到一本书籍翻译的时间以小时计算，需要支持后台运行：

```bash
nohup ~/pdf2zh_chunk.sh book.pdf --output ~/pdf2zh_out > translate.log 2>&1 &
```

更方便的方式是用 tmux：

```bash
sudo apt install tmux

tmux new -s translate
nohup ~/pdf2zh_chunk.sh book.pdf --output ~/pdf2zh_out > translate.log
# 离开前按 Ctrl+B 再按 D 脱离（detach），进程继续跑
```

回来后：

```bash
# 重新附着，看实时进度；Ctrl+C 可停
tmux attach -t translate
```