# ZHUnusedResourcesPlugin
由于项目版本的迭代，造成不必要的资源增多，很难快速获知这些资源文件是否被使用。
那么 `ZHUnusedResourcesPlugin`就可以解决这个问题。

## 安装
1. 下载项目到本地； 
2. 在 `Xcode` 中打开，运行项目； 
3. 在 `debug` 框中看到 `files completion!` ，已成功安装！

## 使用
太简单了，在 `Xcode`的文件列表中直接单击你的图片文件，
如果这个图片没有使用，会在 `debug` 框中会输出 `xxxx.png unuse!!!` 的提示。
