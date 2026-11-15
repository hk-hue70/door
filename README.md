# door

手机门牌 · 固定入口（只含跳转，无数据无密钥）

---

## 🆘 新设备一键复活（设备全丢走这里）

新 Mac / 新机上，打开终端粘这一条：

```bash
curl -fsSL https://raw.githubusercontent.com/hk-hue70/door/main/xiaode-bootstrap.sh | bash
```

会自动：探网络 → 装 gh → **设备码登录 GitHub（唯一要点的步骤）** → 拉系统镜像 → 全量装机。
中途会要一次「逃生舱口令」还原密钥。

### 想用 AI 引导？（opencode + 临时模型）

```bash
# 1) 装 opencode
curl -fsSL https://opencode.ai/install | bash
# 2) 登录免费账号（GitHub OAuth）后用免费模型 opencode/deepseek-v4.1-flash-free
opencode
```

进去后对它说：「读 `~/devin/devin-env/docs/oss-v6/新设备复活-SOP.md`，跑本地一键部署」。
（先跑上面那条 curl 也行——幂等，重复跑不坏事。）

全流程 SOP（人工步清单/验收/充值兜底/配网）：装完后在 `~/devin/devin-env/docs/oss-v6/新设备复活-SOP.md`。
