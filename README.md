# Ez2Eat Mobile

北台灣小農市集消費者端 App，使用 Flutter 開發，支援 Android 與 iOS。

## 功能介紹

### 🗺 地圖
- Google Maps 顯示附近市集位置
- 點擊 marker 彈出市集資訊卡，可直接跳轉詳情頁
- 右下角 `+` / `−` 縮放按鈕

### 🏪 市集
- 市集列表，顯示封面圖、地點、營業時間
- 關鍵字搜尋（名稱 / 地點）
- 愛心收藏市集
- 點入市集查看介紹與販售商品，可加入購物車

### 🛒 購物車
- 調整商品數量
- 刪除商品（附確認 dialog）
- 結帳（附確認 dialog），自動建立訂單

### 👤 我的
- Google 登入 / 登出
- 收藏市集列表
- 訂單紀錄（含商品明細與金額）
- 付款資訊設定（信用卡 / LINE Pay）
- 聯絡我們

## Tech Stack

| 項目 | 套件 |
|------|------|
| Framework | Flutter 3.41 / Dart 3.11 |
| 狀態管理 | flutter_riverpod |
| 導航 | go_router |
| 地圖 | google_maps_flutter |
| 登入 | google_sign_in |
| 圖片快取 | cached_network_image |
| HTTP | dio |

## 開發環境設定

### 1. 安裝依賴
```bash
flutter pub get
```

### 2. Google Maps API Key
- 前往 [Google Cloud Console](https://console.cloud.google.com/) 申請 API Key
- 啟用 **Maps SDK for Android** 及 **Maps SDK for iOS**
- Android：將 Key 填入 `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY" />
```
- iOS：在 `ios/Runner/AppDelegate.swift` 中呼叫 `GMSServices.provideAPIKey("YOUR_API_KEY")`

### 3. Google Sign-In（Android）
- 在 Google Cloud Console 建立 **Android OAuth Client ID**
- Package name：`com.ez2eat.ez2eat_mobile`
- 填入 debug keystore 的 SHA-1（取得方式：`keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android`）

### 4. 執行
```bash
flutter run          # 連接手機或模擬器
flutter run -d chrome  # 瀏覽器（地圖功能不支援）
```

## 專案結構

```
lib/
├── main.dart
├── data/mock_markets.dart       # Mock 資料（待串接後端 API）
├── models/                      # Market、Product、CartItem、Order
├── providers/                   # auth、cart、favorites、orders
└── screens/
    ├── map/                     # 地圖頁
    ├── markets/                 # 市集列表、市集詳情
    ├── cart/                    # 購物車
    └── profile/                 # 我的、收藏、訂單、付款、聯絡
```

## 相關專案

- [ez2eat-web](https://github.com/SheldonChangL/ez2eat-web) — 消費者端網站（Next.js）
