---
# Leave the homepage title empty to use the site title
title: ''
date: 2022-10-24
type: landing

sections:
  - block: about.biography
    id: about
    content:
      title: 个人介绍
      # Choose a user profile to display (a folder name within `content/authors/`)
      username: admin
  - block: features
    content:
      title: 重点关注
      text: '个人看好并正在努力学习和探索中的新技术方向'
      items:
        - name: AI Agent
          description: '探索智能体开发与运行平台'
          icon: object-group
          icon_pack: fa
        - name: AI 编程
          description: '探索 AI 驱动的软件开发新方式'
          icon: code
          icon_pack: fa
        - name: AI 原生应用
          description: '探索以智能体为核心的应用新形态'
          icon: cubes
          icon_pack: fa
  - block: collection
    id: latest-talks
    content:
      title: 最新分享
      subtitle: ''
      text: ''
      # Choose how many pages you would like to display (0 = all pages)
      count: 5
      # Filter on criteria
      filters:
        folders:
          - talk
        featured_only: true
      # Page order: descending (desc) or ascending (asc) date.
      order: desc
    design:
      # Choose a layout view
      view: card
      columns: '2'
  - block: collection
    id: talks
    content:
      title: 演讲分享
      subtitle: ''
      text: ''
      # Choose how many pages you would like to display (0 = all pages)
      count: 2
      # Filter on criteria
      filters:
        folders:
          - talk
        exclude_featured: true
      # Page order: descending (desc) or ascending (asc) date.
      order: desc
    design:
      # Choose a layout view
      view: card
      columns: '2'
  - block: collection
    id: publications
    content:
      title: 出版作品
      text: 
      # Choose how many pages you would like to display (0 = all pages)
      count: 1
      filters:
        folders:
          - publication
        exclude_featured: true
    design:
      columns: '2'
      view: card
  - block: collection
    id: latest-posts
    content:
      title: 最新博客
      subtitle: ''
      text: ''
      # Choose how many pages you would like to display (0 = all pages)
      count: 5
      # Filter on criteria
      filters:
        folders:
          - post
        exclude_featured: true
      # Page order: descending (desc) or ascending (asc) date.
      order: desc
    design:
      # Choose a layout view
      view: compact
      columns: '2'
  - block: portfolio
    id: projects
    content:
      title: 开源项目
      filters:
        folders:
          - project
      # Default filter index (e.g. 0 corresponds to the first `filter_button` instance below).
      default_button_index: 0
      # Filter toolbar (optional).
      # Add or remove as many filters (`filter_button` instances) as you like.
      # To show all items, set `tag` to "*".
      # To filter by a specific tag, set `tag` to an existing tag name.
      # To remove the toolbar, delete the entire `filter_button` block.
      buttons:
        - name: 所有项目
          tag: '*'
        - name: 主导项目
          tag: own
        - name: 参与项目
          tag: participate
    design:
      # Choose how many columns the section has. Valid values: '1' or '2'.
      columns: '2'
      view: showcase
      # For Showcase view, flip alternate rows?
      flip_alt_rows: true
  - block: tag_cloud
    id: tags
    content:
      title: 内容标签
    design:
      columns: '2'
  - block: contact
    id: contact
    content:
      title: 和我联系
      subtitle:
      text: |-
        欢迎和我取得联系，探讨技术问题。
      # Contact (add or remove contact options as necessary)
      email: aoxiaojian@hotmail.com
      phone: 
      address:
        street: 天河区
        city: 广州市
        region: 广东省
        postcode: '510600'
        country: 中国
        country_code: CN
      contact_links:
        - icon: twitter
          icon_pack: fab
          name: DM Me
          link: 'https://twitter.com/skyaoxiaojian80'
      # Automatically link email and phone or display as text?
      autolink: true
      # Email form provider
    design:
      columns: '2'
---
