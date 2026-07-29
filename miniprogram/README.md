# WeChat Mini Program MVP

这是一个最小可运行的微信小程序示例，用本地 mock 数据模拟二手 iPhone 市场摘要与机型详情，方便在微信开发者工具中本地运行和查看。

运行步骤：
1. 在本地安装并打开「微信开发者工具」。
2. 将仓库克隆到本地：
   git clone https://github.com/zz2775229307-web/-iPhone.git
3. 切换到分支：
   git checkout miniprogram-mvp
4. 在微信开发者工具中选择“导入项目”，选择本仓库中的 miniprogram 目录，或直接打开该目录。
   - AppID 可填为 "tourist" 或留空（仅本地运行、非上线）。
5. 在模拟器中查看首页和机型详情，数据来自 data/mock_data.json。

说明：
- 这是一个离线演示版本，后续可以把 data/mock_data.json 替换为调用后端 API 的网络请求。
- 我已经把项目放在分支 "miniprogram-mvp"，你可以在该分支继续开发或合并到主分支。
