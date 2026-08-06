//
//  TextRecognizer+TextRecognitionError.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/1/26.
//

enum TextRecognitionError: Error {
    case invalidImage
    case recognitionFailed
    case unusuableText
    case noTextFound
}
