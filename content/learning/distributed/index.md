---
title: 分布式
weight: 1100
date: "2025-10-09"
description: 分布式
toc: true
---

## 分布式状态

### CloudState学习笔记

CloudState 是一个专注于 Serverless 的分布式状态管理开源项目,之前研究 serverless 和 dpar 时调研了一下.但这几年看这个项目发展的也不是很好,2021年后停止开发.这个笔记也没有继续更新.

- 访问地址：<https://skyao.net/learning-cloudstate>
- 仓库地址：<https://github.com/skyao/learning-cloudstate>
- 格式：hugo格式 + docsy 主题
- 状态：归档


CloudState的核心价值在于,CloudState是一个开创性的项目，最早致力于解决无服务器架构中的状态管理难题。CloudState通过引入事件溯源（Event Sourcing）、CRDTs（无冲突复制数据类型） 等分布式系统模式，为构建有状态、高可用的无服务器服务提供了参考实现。其设计非常适合需要管理复杂状态的场景，如实时协作应用、物联网（IoT）平台和微服务架构.

CloudState 的继任者有:

- Eigr：作为CloudState精神上的继承者，Eigr同样是一个开源项目，它不仅吸收了CloudState的思想，还致力于提供更强大、灵活且易用的解决方案。这个项目可以后续关注.

- Akka Serverless (Lightbend Fusion)：这是由原班团队打造的商业化产品，提供了成熟稳定的平台服务。

## 分布式事务

### 分布式事务学习笔记

2022年时,曾计划在 dapr 中实现分布式事务的功能, 抽取 api 并集成社区分布式事务的能力, 后来项目因故取消, 这个学习笔记也就没有再更新了. 后续希望能有机会继续研究分布式事务相关的技术.

- 访问地址：<https://skyao.net/learning-distributed-transaction>
- 仓库地址：<https://github.com/skyao/learning-distributed-transaction>
- 格式：hugo格式 + docsy 主题
- 状态：归档

