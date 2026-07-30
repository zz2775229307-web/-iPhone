# 生成演示视频（本地操作脚本）

说明：本脚本把仓库中 miniprogram/assets 里的 SVG 图片（或你替换为 PNG）合成为一个演示视频（MP4）。
脚本依赖：imagemagick（convert）和 ffmpeg。请在 macOS、Linux、或 WSL 中运行。

操作步骤（一键脚本）：
1. 克隆仓库并切换到分支 miniprogram-mvp：
   git clone https://github.com/zz2775229307-web/-iPhone.git
   cd -iPhone
   git checkout miniprogram-mvp

2. 安装依赖（示例，Ubuntu）：
   sudo apt update
   sudo apt install -y imagemagick ffmpeg

3. 运行生成脚本（可选先编辑脚本自定义时长/分辨率）：
   bash demo/generate_video.sh

脚本会执行以下工作流程：
- 把 SVG 转为 PNG（分辨率 750x1334，适合手机竖屏）
- 为每张 PNG 生成一个短视频片段（默认每张 3~4 秒）
- 合并片段为无声 MP4
- 如果存在 demo/voiceover.mp3，会把音频合并进视频并生成带字幕的最终文件 demo/demo_video_with_audio.mp4
- 生成的文件保存在 demo/ 目录下

注意：脚本不会自动生成语音文件。请根据 demo/narration.txt 录制语音（或用 TTS 生成）并保存为 demo/voiceover.mp3，再运行脚本以合成有声视频。
