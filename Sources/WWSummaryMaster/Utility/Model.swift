//
//  Model.swift
//  WWSummaryMaster
//
//  Created by William.Weng on 2026/7/6.
//

import FoundationModels

@available(iOS 26.0, *)
@Generable
struct ShortStructuredSummary {
    @Guide(description: "一句繁體中文摘要")
    let summary: String
}

@available(iOS 26.0, *)
@Generable
struct MediumStructuredSummary {
    @Guide(description: "簡短標題")
    let title: String
    
    @Guide(description: "一句到兩句繁體中文摘要")
    let summary: String
    
    @Guide(description: "三個重點", .count(3))
    let keyPoints: [String]
}

@available(iOS 26.0, *)
@Generable
struct LongStructuredSummary {
    @Guide(description: "簡短標題")
    let title: String
    
    @Guide(description: "一段較完整的繁體中文摘要")
    let summary: String
    
    @Guide(description: "五個重點", .count(5))
    let keyPoints: [String]
}
