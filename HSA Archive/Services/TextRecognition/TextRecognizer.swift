//
//  TextRecognizer.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/21/26.
//

import UIKit
import Vision

nonisolated struct TextRecognizer {
    private enum Constants {
        static let characterCountMin = 25
        static let lineCountMin = 2
    }
    
    func recognizeText(
        from uiImage: UIImage
    ) async throws(TextRecognitionError) -> ScannedTextResponse {
        guard let cgImage = uiImage.cgImage else { throw .invalidImage }
        let result: Result<ScannedTextResponse, TextRecognitionError> = await withCheckedContinuation { continuation in
            let request = makeRequest(continuation: continuation)
            let handler = VNImageRequestHandler(cgImage: cgImage)
            do {
                try handler.perform([request])
            } catch {
                Debug.log("OCR Handler Error: \(error)", category: .ocr)
                continuation.resume(returning: .failure(.recognitionFailed))
            }
        }
        return try result.get()
    }
}

// MARK: - Private Methods

nonisolated private extension TextRecognizer {
    func makeRequest(
        continuation: CheckedContinuation<Result<TextRecognizer.ScannedTextResponse, TextRecognitionError>, Never>
    ) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { vnRequest, error in
            guard error == nil else {
                continuation.resume(returning: .failure(.recognitionFailed))
                return
            }
            
            let observations = vnRequest.results as? [VNRecognizedTextObservation] ?? []
            let candidates = observations.compactMap { $0.topCandidates(1).first }
            let text = candidates.map(\.string).joined(separator: "\n")
            let confidence = candidates.map(\.confidence)
                .reduce(0, +) / Float(max(candidates.count, 1))
            
            Debug.log("OCR text: \(text)\n\nOCR confidence: \(confidence)", category: .ocr)
            
            if let error = validateOCRText(text) {
                continuation.resume(returning: .failure(error))
                return
            }
            
            continuation.resume(
                returning: .success(
                    .init(text: text, confidence: confidence)
                )
            )
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        return request
    }
    
    /// Ensures the ocr text response is valid, otherwise, returns a `TextRecognitionError`.
    func validateOCRText(_ text: String) -> TextRecognitionError? {
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedText.isEmpty else { return .noTextFound }
        guard cleanedText.count >= Constants.characterCountMin else { return .unusuableText}
        guard cleanedText.split(separator: "\n").count >= Constants.lineCountMin else { return .unusuableText }
        guard cleanedText.contains(where: \.isNumber) else { return .unusuableText }
        return nil
    }
}
