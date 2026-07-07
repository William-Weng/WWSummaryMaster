//
//  WWSummaryMaster.swift
//  WWSummaryMaster
//
//  Created by William.Weng on 2026/7/6.
//

#if canImport(FoundationModels)
import FoundationModels

@available(iOS 26.0, *)
public class WWSummaryMaster {
    
    private let model = SystemLanguageModel.default
    
    public init() {}
}

@available(iOS 26.0, *)
public extension WWSummaryMaster {
    
    func summarize(_ inputText: String, mode: Mode = .plain, length: Length = .medium) async throws -> WWSummaryMaster.Result {
        
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw AgnetError.isTextEmpty }
        
        switch model.availability {
        case .unavailable(let reason):
            switch reason {
            case .appleIntelligenceNotEnabled: throw AgnetError.appleIntelligenceNotEnabled
            case .deviceNotEligible: throw AgnetError.deviceNotEligible
            case .modelNotReady: throw AgnetError.modelNotReady
            default : throw AgnetError.unavailable(reason)
            }
        case .available: return try await summarizeText(trimmed, mode: mode, length: length)
        }
    }
}

@available(iOS 26.0, *)
private extension WWSummaryMaster {
    
    func makePlainPrompt(for text: String, length: Length) -> String {
        """
        請根據以下內容產生摘要。
        
        規則：
        1. 必須使用繁體中文。
        2. 必須忠於原文，不可捏造資訊。
        3. \(length.plainPromptInstruction)
        4. 不要加入前言、結語、標題或 markdown。
        
        原文：
        \(text)
        """
    }
    
    func summarizeText(_ text: String, mode: Mode = .plain, length: Length = .medium) async throws -> WWSummaryMaster.Result {
        
        let session = LanguageModelSession(instructions: """
            你是一個可靠的繁體中文摘要助手。
            任務是忠於原文、去除冗詞、整理重點。
            不要捏造原文沒有提到的資訊。
            """
        )
        
        switch mode {
        case .plain:
            let result = try await summarizePlain(text: text, using: session, length: length)
            return .plain(result)
        case .structured:
            let result = try await summarizeStructured(text: text, using: session, length: length)
            return .structured(result)
        }
    }
    
    func summarizePlain(text: String, using session: LanguageModelSession, length: Length) async throws -> String {
        let prompt = makePlainPrompt(for: text, length: length)
        let response = try await session.respond(to: prompt)
        return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func summarizeStructured(text: String, using session: LanguageModelSession, length: Length) async throws -> RenderedStructuredResult {
        
        let prompt = """
        請閱讀以下內容並產生結構化摘要。
        所有欄位都必須使用繁體中文，內容必須忠於原文，不可捏造資訊。
        
        內容：
        \(text)
        """
        
        switch length {
        case .short:
            let response = try await session.respond(to: prompt, generating: ShortStructuredSummary.self)
            
            return .init(
                title: "",
                summary: response.content.summary,
                keyPoints: []
            )
            
        case .medium:
            let response = try await session.respond(to: prompt, generating: MediumStructuredSummary.self)
            
            return .init(
                title: response.content.title,
                summary: response.content.summary,
                keyPoints: response.content.keyPoints
            )
            
        case .long:
            let response = try await session.respond(to: prompt, generating: LongStructuredSummary.self)
            
            return .init(
                title: response.content.title,
                summary: response.content.summary,
                keyPoints: response.content.keyPoints
            )
        }
    }
}

#endif
