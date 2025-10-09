---
title: 编程语言及类库
date: "2025-10-08"
weight: 100
description: 编程语言及类库
toc: true
---

## 前言

过去20多年中，我主要使用的编程语言有：

- Java
- Golang

短时间使用过的有：

- VBScript/asp
- JavaScript
- PHP
- C#/.net
- C++/vc++
- Python
- Lua(简单写过一些内嵌脚本)

尝试学习而没能学会的有：

- Erlang(已放弃)
- Rust (舍不得放弃，继续努力中)

## Java

### JDK学习笔记

JDK 版本信息和部分 JDK 相关的工具介绍。2023年左右，对 Dapr 的 java-sdk 进行了版本升级，因此更新了部分 JDK 相关的知识。

- 访问地址：<https://skyao.net/learning-jdk>
- 仓库地址：<https://github.com/skyao/learning-jdk>
- 格式：hugo格式 + docsy 主题
- 状态：维护

### Java AOT学习笔记

Java AOT / Ahead Of Time 编译技术。2022年左右，曾计划在 dapr 中配合 AOT 技术，用于解决 Java 应用启动时间过长导致不太适用于 FaaS 场景的问题。但后来发现，Java AOT 技术在实际应用中，并不如预期那么理想，因此暂时放弃了这个计划。

- 访问地址：<https://skyao.net/learning-java-aot>
- 仓库地址：<https://github.com/skyao/learning-java-aot>
- 格式：hugo格式 + docsy 主题
- 状态：维护

### Spring Cloud学习笔记

Spring Cloud 相关内容。2022年左右，曾计划在 dapr 中集成 Spring Cloud，当时主要是实现 dapr pub/sub 对接 spring cloud stream 的功能。后来发现，spring 社区对 service mesh / runtime 等基于 sidecar 的技术非常排斥，合作无法谈成，dapr spring cloud 项目也因此宣布失败。

- 访问地址：<https://skyao.net/learning-spring-cloud>
- 仓库地址：<https://github.com/skyao/learning-spring-cloud>
- 格式：hugo格式 + docsy 主题
- 状态：休眠

### Mockito学习笔记

Mockito 是 Java 中用于单元测试的模拟框架, 我之前写 Java 代码是重度使用 mocktio. 之前曾经想把以前积累的一些 mockito 的博客内容整理到这个笔记中,但后来因为时间原因没能完成,这个笔记暂时没啥内容,等待后续补充.

- 访问地址：<https://skyao.net/learning-mockito>
- 仓库地址：<https://github.com/skyao/learning-mockito>
- 格式：hugo格式 + docsy 主题
- 状态：休眠

### 其他(归档和删除)

以下内容长期不更新，而且格式和主题都很老，内容归档不可访问，以后有机会再考虑重新整理。

- learning-java-unit-test
- learning-maven
- learning-guava
- learning-jenkins2

以下内容因为太过久远，已经没有留存意义，已被删除，不可访问：

- learning-spring-boot
- leaning-java-performance-tuning
- learning-netty
- learning-cucumber

## Golang

### Golang学习笔记

Golang 语言相关内容。2020年左右，开始学习并使用 Golang 语言，并记录了一些学习笔记。不过，最近一年代码写的少了，golang学习笔记也更新不频繁。

- 访问地址：<https://skyao.net/learning-golang>
- 仓库地址：<https://github.com/skyao/learning-golang>
- 格式：hugo格式 + docsy 主题
- 状态: 维护中

## Rust

### Rust学习笔记

Rust 语言相关内容。从2017年因为 linkerd 项目开始学习 Rust 语言，但一直没能深入掌握，主要是没机会在实际项目中大规模使用。最近几年，随着 Rust 语言的成熟，以及 Rust 语言在云原生领域的应用越来越多，因此决定继续学习 Rust 语言，后续希望可以用 Rust 语言实现一些想法。

- 访问地址：<https://skyao.net/learning-rust>
- 仓库地址：<https://github.com/skyao/learning-rust>
- 格式：hugo格式 + docsy 主题
- 状态: 维护

### Tokio学习笔记

Tokio是用于Rust编程语言的一个异步运行时。2021年曾努力学习 tokio，但后来因为没怎么使用 rust，就荒废了。希望后面有机会能继续学习 tokio。

- 访问地址：<https://skyao.net/learning-tokio>
- 仓库地址：<https://github.com/skyao/learning-tokio>
- 格式：hugo格式 + docsy 主题
- 状态: 休眠

### Yarp学习笔记

- 访问地址：<https://skyao.net/learning-yarp>
- 仓库地址：<https://github.com/skyao/learning-yarp>
- 格式：hugo格式 + docsy 主题
- 状态: 休眠

## Python

### Python学习笔记

Python 语言相关内容。很早很早以前学过一点点python，主要用来写简单的运维脚本，后来没怎么用。最近几年，因为 AI 的原因，有越来越多的机会使用到 python 编写的各种软件/类库，因此考虑找时间再重新学习一下 python，以满足简单开发的需要。

- 访问地址：<https://skyao.net/learning-python>
- 仓库地址：<https://github.com/skyao/learning-python>
- 格式：hugo格式 + docsy 主题
- 状态: 维护