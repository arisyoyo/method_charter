---
name: method-charter
description: 论文方法框架的沉淀与约束管理。三种模式——clean（把讨论折叠成干净上下文）、distill（凝练成方法主文档 method-core.md）、merge（合并经人工确认的变更）。用于论文方法讨论的交接、收尾、分叉、上下文即将超限时，以及生成或更新跨对话复用的方法约束文档时。需显式调用 /method-charter，不会自动触发。
disable-model-invocation: true
user-invocable: true
---

# 论文方法框架 · 沉淀与约束

一个 skill，三种模式。**一次执行只用一个模式**，模式之间不自动串联。

```
讨论 ──clean──► context-clean-<日期>.md ──distill──► method-core.md
                  （人工看未决）        （人工看红线）      │
                                                          │ 只读引用
修改会话 ◄────────────────────────────────────────────────┘
   │ 冲突上报（不就地改）
   ▼
人工确认 ──merge──► method-core.md 新版本 + CHANGELOG
```

## 调用方式

**只在你显式调用 `/method-charter` 时加载**，不参与自动路由（由 frontmatter 的 `disable-model-invocation: true` 保证）。

取舍：这杜绝了「模型在无关任务里自己把它拉进来」的风险，代价是它也不会主动提醒你「该沉淀了」。若要提醒，在项目的 `AGENTS.md` 里写一条口播规则——提醒归提醒，执行仍要你显式调用。

## 模式选择

| 模式 | 什么时候 | 输入 → 产物 |
|---|---|---|
| `clean` | 讨论要交接、收尾、分叉，或上下文将满 | 当前对话 → `context-clean-<日期>.md` |
| `distill` | 已有干净上下文，要生成或重做约束文档 | `context-clean-*.md` → `method-core.md` |
| `merge` | 有一处经人工确认的变更要并入 | 主文档 + 变更 + 理由 → 新版本 + CHANGELOG |

判据只有一条：**你手上的输入是什么**。是对话 → `clean`；是干净的清理产物 → `distill`；是「对现有主文档的一处改动」→ `merge`。

## 为什么按模式拆规则

三种模式的硬约束互斥，写在一份流程里必然会串味：

| 模式 | 对既有表述的态度 |
|---|---|
| `clean` | **无损**：只删过程，结论逐字 |
| `distill` | **有损**：可以重组、改写、取舍 |
| `merge` | **不动**：未受影响部分逐字保留 |

该保留的被改写、该重组的被逐字抄，是这类文档最常见的两种坏法。所以规则按模式分文件，**执行前先声明模式**。

## 共享契约

| 项 | 约定 |
|---|---|
| 目录 | `./method/`；历史版本在 `./method/_archive/` |
| 编号 | C 结论、R 否定分支、U 未决、L 修订链；跨模式沿用，不重编 |
| 变更史 | `./method/CHANGELOG.md`，append-only，任何模式不得改写已有条目 |
| 冻结 | 只有 `merge` 能写 `method-core.md`；其余模式只读 |
| 人工闸 | `clean` 之后必停；`distill`、`merge` 之后必停 |
| 执行 | `clean` 与 `distill` 在子会话跑，主对话只回收产物路径与摘要 |

## 失败行为（共用）

| 情形 | 行为 |
|---|---|
| 拿不准归类 | 记入「未决」或「存疑」，**禁止猜** |
| 结论之间互相矛盾 | **硬停**：只出冲突报告，不出产物 |
| 输入超长、无法一次处理 | 分窗归并；归并不了硬停，并**列出未处理的区间** |
| 目标文件版本冲突 | **硬停**，不覆盖 |
| 任何情况 | **禁止为「看起来完整」而填充**。宁可留空并标注 |

## 禁止跨模式

- 不在 `clean` 里改结论的表述。
- 不在 `distill` 里改动未受影响的既有板块。
- 不在 `merge` 里重组结构或做风格统一。
- **不自动从 `clean` 串到 `distill`**：clean 结束就停，等人看完未决清单再开始 distill。

## 读取

| 模式 | 先读 | 模板 |
|---|---|---|
| `clean` | `references/mode-clean.md` | `references/template-context-clean.md` |
| `distill` | `references/mode-distill.md` | `references/template-method-core.md` |
| `merge` | `references/mode-merge.md` | 沿用现有主文档结构 |
