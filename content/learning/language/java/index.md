---
title: "Java"
weight: 100
date: 2025-10-08
description: Java及Java相关类库
toc: true  # Show table of contents? true/false
---


## 维护中

以下内容更新不频繁，但偶尔还是会关注一下这些方向的业界动态，因此学习笔记也会偶尔更新一下。

### learning-jdk

JDK 版本信息和部分 JDK 相关的工具介绍。2023年左右，对 Dapr 的 java-sdk 进行了版本升级，因此更新了部分 JDK 相关的知识。

- 访问地址：<https://skyao.net/learning-jdk>
- 仓库地址：<https://github.com/skyao/learning-jdk>
- 格式：hugo格式 + docsy 主题

### learning-java-aot

Java AOT / Ahead Of Time 编译技术。2022年左右，曾计划在 dapr 中配合 AOT 技术，用于解决 Java 应用启动时间过长导致不太适用于 FaaS 场景的问题。但后来发现，Java AOT 技术在实际应用中，并不如预期那么理想，因此暂时放弃了这个计划。

- 访问地址：<https://skyao.net/learning-java-aot>
- 仓库地址：<https://github.com/skyao/learning-java-aot>
- 格式：hugo格式 + docsy 主题

## 休眠中

以下内容短期内没有时间和精力更新，但以后有机会可能会重新拾取。

### learning-spring-cloud

Spring Cloud 相关内容。2022年左右，曾计划在 dapr 中集成 Spring Cloud，当时主要是实现 dapr pub/sub 对接 spring cloud stream 的功能。后来发现，spring 社区对 service mesh / runtime 等基于 sidecar 的技术非常排斥，合作无法谈成，dapr spring cloud 项目也因此宣布失败。

- 访问地址：<https://skyao.net/learning-spring-cloud>
- 仓库地址：<https://github.com/skyao/learning-spring-cloud>
- 格式：hugo格式 + docsy 主题

## 已归档

以下内容长期不更新，而且格式和主题都很老，内容归档不可访问，以后有机会再考虑重新整理。

- learning-java-unit-test
- learning-maven
- learning-guava
- learning-jenkins2

## 已删除

以下内容因为太过久远，已经没有留存意义，已被删除，不可访问：

- learning-spring-boot
- leaning-java-performance-tuning
- learning-netty
- learning-cucumber