# Ez2Eat Mobile App 規格書

## 整體架構

### Tech Stack
| 項目 | 選擇 | 原因 |
|------|------|------|
| Framework | Flutter 3 | iOS + Android 一份程式碼 |
| 狀態管理 | Riverpod | 輕量、易測試 |
| 導航 | go_router | 支援 deep link |
| 地圖 | google_maps_flutter | 與 ez2eat-web 一致 |
| 登入 | google_sign_in | Google 登入 |
| HTTP | Dio | 與 ez2eat 後端 API 串接 |

---

## 3 個 Bottom Nav

```
[🗺 地圖]  [🏪 市集]  [👤 我的]
```

### Tab 1 — 地圖
- Google Maps 全螢幕，標記出所有市集位置
- 點擊 marker 顯示市集名稱小卡
- 右下角 `+` / `−` zoom 按鈕

### Tab 2 — 市集列表
- 卡片列表：封面圖 + 市集名稱 + 地點 + 營業時間
- 點入市集頁：介紹 + 商品列表，每樣商品可加入購物車
- 右上角購物車 icon（顯示數量 badge）

### Tab 3 — 我的
- Google 登入 / 登出
- 付款資訊（信用卡 / LINE Pay，UI 設定頁）
- 聯絡我們（email + 社群連結）

---

## 開發順序

| 優先 | 功能 | 狀態 |
|------|------|------|
| 1 | 專案初始化 | ✅ 完成 |
| 2 | Bottom Nav Shell | 待做 |
| 3 | 地圖頁 | 待做 |
| 4 | 市集列表頁 | 待做 |
| 5 | 市集詳情 + 商品 | 待做 |
| 6 | 購物車 | 待做 |
| 7 | Google 登入 | 待做 |
| 8 | 我的頁面 | 待做 |
| 9 | 串接後端 API | 待做 |
