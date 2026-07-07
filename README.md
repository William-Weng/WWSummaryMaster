# WWSummaryMaster

[![Swift-5.10](https://img.shields.io/badge/Swift-5.10-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS-17.0](https://img.shields.io/badge/iOS-17.0-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWSummaryMaster)
[![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

- 智能摘要大師 (使用APPLE AI 功能，智能化取得文字摘要)

https://github.com/user-attachments/assets/86fc033f-3f7e-44ee-8a88-3d21e5f340fc

```swift
import SwiftUI
import WWSummaryMaster

struct ContentView: View {
    
    private let master = WWSummaryMaster()
    private let notes = """
    # WWDC 2026 核心亮點
    
    1. Apple Intelligence 與 Siri 2.0 升級今年蘋果的AI 戰略走向成熟，AI 功能深度融合於日常操作中：
        - Google Gemini 合作：蘋果正式確認與 Google 建立合作關係，讓 AI 語言模型與蘋果的隱私運算技術相互結合。
        - 全新 Siri 2.0：支援跨 App 操作，並能理解螢幕當前內容。使用者能直接針對畫面提問，Siri 的回答也變得更像真實對話，甚至具備「電腦視覺」，可透過相機鏡頭回答現實場景的問題。
    2. 作業系統更新重點iOS 27：
        - 改善了系統效能（App 啟動速度提升 30%、Photos 開啟速度提升 70%），Apple Wallet 新增會員卡掃描功能，Health App 加入圍絕經期（更年期）追蹤儀表板。
        - macOS Golden Gate：全面整合 AI 功能，並成為首個僅支援 Apple 自研晶片（Apple Silicon）MacBook 的作業系統，正式終結對 Intel Mac 的支援。
        - watchOS 27：強化健康與運動監測數據，引入全新 Siri App 讓用戶回顧對話並提供個人化建議。
    3. 裝置支援與硬體門檻iOS 27 支援性：
        - 淘汰了 iPhone 11 系列與 iPhone SE 第 2 代。
        - AI 完整支援性：完整的 Apple Intelligence 與全新 Siri 功能，硬體門檻較高，僅支援 iPhone 15 Pro、iPhone 15 Pro Max、iPhone 16 全系列及後續機型。
    """
    
    @State private var text: String = ""
    
    var body: some View {
        
        HStack {
            
            if text.isEmpty {
                ProgressView()
            } else {
                Text(text)
                    .padding()
            }
            
        }.task {
            Task { @MainActor in
                
                do {
                    switch try await master.summarize(notes) {
                    case .plain(let plain): text = plain
                    case .structured(let result): text = "\(result)"
                    }
                } catch {
                    text = "\(error.localizedDescription)"
                }
            }
        }
    }
}
```
