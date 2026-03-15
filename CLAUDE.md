# CLAUDE.md — Ez2Eat Mobile

This file provides guidance to Claude Code when working with the `ez2eat_mobile` project.

## What Is This

**Ez2Eat Mobile** 是北台灣小農市集的消費者端 Flutter App，支援 Android 與 iOS。
配套網站：`ez2eat-web`（Next.js），後端 API 規格見 `api.md`（待串接）。

## Commands

```bash
flutter run              # 執行 App（需連接手機或模擬器）
flutter run -d chrome    # 在 Chrome 執行（地圖功能不支援）
flutter analyze          # 靜態分析
flutter build apk        # 建立 Android APK
```

Flutter SDK 位於 `C:\Users\ASUS\flutter\bin\flutter`。

## Architecture

**Flutter 3.41 + Dart 3.11**，採用 Riverpod 狀態管理 + go_router 導航。

### Tech Stack
| 套件 | 用途 |
|------|------|
| flutter_riverpod | 狀態管理 |
| go_router | 底部導航路由 |
| google_maps_flutter | 地圖（Android/iOS only） |
| google_sign_in | Google 登入 |
| geolocator | 取得目前位置 |
| cached_network_image | 圖片快取 |
| dio | HTTP（待串接 API） |

### 資料夾結構
```
lib/
├── main.dart                        # App 入口、ProviderScope、go_router、MainShell
├── data/
│   └── mock_markets.dart            # Mock 市集與商品資料（待換成 API）
├── models/
│   ├── market.dart                  # Market、Product
│   ├── cart_item.dart               # CartItem
│   └── order.dart                   # Order
├── providers/
│   ├── auth_provider.dart           # Google 登入狀態
│   ├── cart_provider.dart           # 購物車（add/remove/updateQuantity/clear）
│   ├── favorites_provider.dart      # 收藏市集（toggle）
│   └── orders_provider.dart         # 訂單紀錄（addOrder）
└── screens/
    ├── map/map_screen.dart          # Google Maps + marker + 市集資訊卡
    ├── markets/
    │   ├── markets_screen.dart      # 市集列表 + 搜尋 + 收藏愛心
    │   └── market_detail_screen.dart # 市集詳情 + 商品列表 + 加入購物車
    ├── cart/cart_screen.dart        # 購物車（數量調整、刪除確認、結帳確認）
    └── profile/
        ├── profile_screen.dart      # 我的頁（登入/登出、收藏、訂單、付款、聯絡）
        ├── favorites_screen.dart    # 收藏市集列表
        ├── orders_screen.dart       # 訂單紀錄（ExpansionTile）
        ├── payment_screen.dart      # 付款設定（信用卡 / LINE Pay）
        └── contact_screen.dart      # 聯絡我們

```

### Bottom Navigation
```
[🗺 地圖]  [🏪 市集]  [👤 我的]
```

### Google Maps
- Android：API Key 寫在 `android/app/src/main/AndroidManifest.xml`
- iOS：`GMSServices.provideAPIKey()` 在 `ios/Runner/AppDelegate.swift`
- Web：顯示佔位畫面（`kIsWeb` 判斷）
- Marker tap → 底部浮出市集資訊卡 → 「查看詳情」跳到詳情頁
- 右下角定位按鈕：請求位置權限 → 移動鏡頭到目前位置 + 藍色定位圓圈
- `myLocationEnabled` 動態控制（需權限才啟用，`initState` 自動檢查已有權限）
- Android 位置權限：`ACCESS_FINE_LOCATION` + `ACCESS_COARSE_LOCATION`（AndroidManifest.xml）

### Google Sign-In
- Android：需在 Google Cloud Console 建立 Android OAuth Client ID
  - Package name: `com.ez2eat.ez2eat_mobile`
  - SHA-1: `B7:FF:02:EC:FE:5D:FD:E7:E2:01:1D:5C:D9:D9:17:DB:C5:EE:6B:CE`（debug keystore）
- Web：需 Web Client ID（目前顯示提示訊息）

### State Management
所有 Provider 皆為 `NotifierProvider`，不做持久化（重啟 App 後狀態重置）。
待串接後端後再加 `SharedPreferences` 或 `flutter_secure_storage`。

### 待完成
- [ ] 串接 ez2eat 後端 API（替換 `mock_markets.dart`）
- [ ] 狀態持久化（收藏、訂單本地儲存）
- [ ] 推播通知（FCM）
- [ ] 搜尋頁面優化（地圖篩選）
