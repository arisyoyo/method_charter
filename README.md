# method-charter

一个给论文写作用的 skill：把「方法框架」从一次讨论里沉淀出来，变成能约束后续所有章节对话的文档，并让改动可追溯。

它解决三个具体问题：

- **讨论越长越散。** 上下文一旦被压缩，已经谈定的结论就散了，下次接着聊又得从头对齐。
- **框架只活在对话里。** 改引言、改结果分析、写讨论时，对不齐上一次谈定的方法结构。
- **改动是隐形的。** 多轮修改中术语悄悄漂移，没被确认的想法悄悄变成「既定结论」，最后没人说得清哪句是定的。

## 三种模式

| 模式 | 输入 | 产物 | 做什么 |
|---|---|---|---|
| `clean` | 一段正在进行的讨论 | `./method/context-clean-<日期>.md` | 折叠修订链，只留终态；结论逐字、带限定条件；被否方案一行留档；未决事项单列 |
| `distill` | 上述清理产物 | `./method/method-core.md` | 生成六板块约束文档：内核逻辑链、术语与禁替代表、论述红线、可调整项 |
| `merge` | 主文档 + 一处人工确认的变更 | 新版本 + `CHANGELOG.md` | 定点并入，未受影响部分逐字保留；三项兼容性检查 |

三段之间是**人工闸**：clean 之后停下看未决清单，distill/merge 之后停下看红线与舍弃清单。

## 调用方式

**必须显式调用 `/method-charter`，不会自动触发。**

frontmatter 里设了 `disable-model-invocation: true`，模型看不到这个 skill，不会在无关任务里自己把它拉进来。代价是它也不会提醒你「该沉淀了」——如果你想要提醒，在项目 `AGENTS.md` 里写一条口播规则即可，执行仍然由你显式发起。

想让模型也能自己调用，删掉 SKILL.md frontmatter 里那一行即可。

## 安装

### 项目级（建议先这样试）

```powershell
git clone https://github.com/arisyoyo/method_charter <你的项目>\.dsh\skills\method-charter
```

> 仓库名用下划线（`method_charter`），安装目录用连字符（`method-charter`）。技能的正式名取自 `SKILL.md` 的 `name`，必须是 kebab-case，所以目录名请保持连字符。

或克隆到任意位置，再装到目标项目：

```powershell
<克隆目录>\install.ps1 -Target <你的项目>
```

### 用户级（所有项目可用）

```powershell
<克隆目录>\install.ps1 -User
```

### 手动

把整个目录复制到 `<项目>/.dsh/skills/method-charter/`（或 `~/.dsh/skills/method-charter/`）。

**安装后新开一个会话**再验证（技能目录有缓存）。输入 `/method-charter` 能调起即安装成功。

**卸载 = 删掉那个目录。** 没有注册表，没有其它残留。

## 用法

```
讨论告一段落
  /method-charter            → clean，产出 context-clean-20261101.md
  审未决清单，逐条给结论
  /method-charter            → distill，产出 method-core.md

改某一章时
  新对话里贴 method-core 的 §6 与范围声明，只让它改那几段
  发现冲突时它按【冲突上报】列出，不就地改主文档

冲突被确认后
  /method-charter            → merge，出新版本 + CHANGELOG
```

## 产物约定

所有产物落在调用方项目的 `./method/` 下：

| 文件 | 说明 |
|---|---|
| `context-clean-<日期>.md` | 一次性清理产物，凝练后归档 |
| `method-core.md` | 约束主文档，冻结；只有 merge 能写 |
| `CHANGELOG.md` | 变更史，append-only，任何模式不得改写已有条目 |
| `_archive/` | 历史版本，只增不删 |

`method-core.md` 的版本号放在 frontmatter（`version: 2.1.0`），**不放文件名**——文件名一改，Obsidian 链接就断。

## 文件清单

```
SKILL.md                                    入口：调用方式、模式路由、共享契约
references/
  mode-clean.md                             判据、修订链折叠、触发表
  mode-distill.md                           六板块、预算地板、取舍、舍弃清单
  mode-merge.md                             逐字保留、兼容性、版本号、CHANGELOG
  template-context-clean.md                 清理产物模板
  template-method-core.md                   主文档模板 + 范围声明 + 冲突上报 + 首次校验
install.ps1                                 安装脚本
```

## 几条关键设计取舍

- **为什么叫 charter。** 名字要描述的是它的**角色**，不是"论文方法"这个领域：一份章程——立规矩、下游必须遵守、只能按程序修订。`paper-method` 只说了领域，读起来像知识库，不像一个动作。
- **一个 skill 三个模式，而不是三个 skill。** 注册表里没有「管线」这个原语，把带人工闸的流程切成多个注册项，连接处就无处安放。需要隔离的是三套互斥的规则（无损／有损／逐字保留），用文件边界隔离即可，不必动用 skill 注册表。
- **地板不参与取舍。** 内核逻辑链、术语与禁替代表、论述红线永远全量；其余部分 8000 字封顶。超预算时先砍细节，砍完还超就升级结构，**不许砍红线**——删掉红线不是文档变短，是反向授权。
- **冲突只上报，不就地裁决。** 修改会话永远没有写主文档的权限。裁决权与修改权分离，才挡得住「被约束的对话反向改写约束」。
- **变更史独立成文件。** 放进清理产物里，下一次 clean 会把它当过程性内容折叠掉——历史被清理工具改写，是这套流程最不该发生的污染。

## 已知限制

- **没有校验器。** 结构完整性（编号唯一、`counts` 不变式、字数预算、舍弃清单可追溯）目前靠人眼或自写脚本。
- **不扫描正文里新增的论断。** 只靠每章 `method-version` 指针加合并时人工触发 diff。
- **不替代 git。** `_archive/` 是文档级归档，不是版本控制。
- **需要人显式触发**，所以「该沉淀时没沉淀」仍可能发生。

## 兼容性

面向 DSH 的 `skill-filesystem`（`<项目>/.dsh/skills/<name>/SKILL.md`，或平铺 `<项目>/.dsh/skills/<name>.md`）。

内容是纯 Markdown 指令加引用文件，不依赖 DSH 专有格式；其它工具（如 opencode）我没有验证过它的技能发现机制，请勿假定行为一致。

## 版本

`v0.1.0` — 初次发布，三种模式。
