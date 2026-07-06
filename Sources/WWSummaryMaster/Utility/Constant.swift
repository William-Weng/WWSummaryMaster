//
//  Constant.swift
//  WWSummaryMaster
//
//  Created by William.Weng on 2026/7/6.
//

import Foundation
import FoundationModels

@available(iOS 26.0, *)
public extension WWSummaryMaster {
    
    enum Mode: String {
        
        case plain
        case structured
    }

    enum Length: String {
        
        case short
        case medium
        case long
    }
    
    /// 摘要結果
    enum Result {
        case plain(String)
        case structured(RenderedStructuredResult)
    }
    
    /// Apple Intelligence錯誤
    enum AgnetError: Error {
        
        case isTextEmpty                                                                // 輸入文字為空
        case deviceNotEligible                                                          // 此裝置不支援 Apple Intelligence
        case appleIntelligenceNotEnabled                                                // Apple Intelligence 尚未啟用，請先到系統設定開啟
        case modelNotReady                                                              // 模型尚未就緒，可能仍在下載或初始化
        case unavailable(_ other: SystemLanguageModel.Availability.UnavailableReason)   // 目前無法使用模型
    }
}


@available(iOS 26.0, *)
extension WWSummaryMaster.Mode: CaseIterable, Identifiable {
    
    public var id: String { rawValue }
    
    var title: String {
        switch self {
        case .plain: return "文字摘要"
        case .structured: return "結構化摘要"
        }
    }
}

@available(iOS 26.0, *)
extension WWSummaryMaster.Length: CaseIterable, Identifiable {
    
    public var id: String { rawValue }
    
    var title: String {
        
        switch self {
        case .short: return "短"
        case .medium: return "中"
        case .long: return "長"
        }
    }
    
    var displayDescription: String {
        
        switch self {
        case .short: return "短摘要（1–2 句）"
        case .medium: return "中摘要（3 句 / 3 點）"
        case .long: return "長摘要（完整段落 / 5 點）"
        }
    }
    
    var plainPromptInstruction: String {
        
        switch self {
        case .short: return "請用繁體中文輸出 1 到 2 句摘要，總長盡量控制在 40 到 80 字。"
        case .medium: return "請用繁體中文輸出 3 句摘要，保留主要脈絡，總長盡量控制在 80 到 140 字。"
        case .long: return "請用繁體中文輸出 1 段較完整摘要，長度約 120 到 220 字，保留背景、重點與結論。"
        }
    }
}
