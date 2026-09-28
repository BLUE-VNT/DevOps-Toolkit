# Folder Quick Switcher 中文说明

Folder Quick Switcher 是一个 Obsidian 插件，用来快速搜索并定位仓库里的文件夹。它的体验类似 Obsidian 自带的快速切换笔记，只是搜索对象从笔记变成了文件夹。

## 功能

- 按文件夹名称或路径搜索文件夹
- 使用模糊搜索快速筛选结果
- 选中文件夹后，在 Obsidian 左侧文件浏览器中定位并展开该文件夹
- 可绑定快捷键，随时呼出文件夹搜索框

## 本地安装

将这个插件目录复制或软链接到你的 Obsidian 仓库插件目录中：

```text
<你的仓库>/.obsidian/plugins/folder-quick-switcher
```

然后在 Obsidian 中打开：

```text
设置 -> 第三方插件 -> 已安装插件
```

启用 **Folder Quick Switcher**。

## 使用方法

1. 打开 Obsidian 设置。
2. 进入 **快捷键**。
3. 搜索 **Open folder quick switcher**。
4. 绑定一个你喜欢的快捷键，例如 `⌘ + ⌥ + O`（macOS）或 `Ctrl + Alt + O`（Windows/Linux）。
5. 按下快捷键后，输入文件夹名称或路径进行搜索。
6. 选中文件夹后，插件会在文件浏览器里定位到该文件夹。

## 适合场景

- 仓库文件夹很多，手动展开很慢
- 想像搜索笔记一样快速跳转到某个文件夹
- 经常需要在不同项目、主题、资料夹之间切换

## 注意事项

- 插件只负责定位文件夹，不会新建、删除或移动文件夹。
- 如果文件浏览器没有打开，插件会尝试打开并定位目标文件夹。
- 插件命令名称目前是英文：**Open folder quick switcher**。
