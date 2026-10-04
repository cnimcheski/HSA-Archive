//
//  ShareViewController.swift
//  HSA ArchiveShareExtension
//
//  Created by Steve Nimcheski on 9/30/26.
//

import UIKit

final class ShareViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await importSharedItems() }
    }
}

// MARK: - Private Methods

private extension ShareViewController {
    func importSharedItems() async {
        var directory: URL?
        do {
            let batch = try createInboxBatch()
            directory = batch.directory
            try await copyAttachments(to: batch.directory)
            try await openParentApp(with: batch.batch)
        } catch {
            if let directory { try? FileManager.default.removeItem(at: directory) }
            extensionContext?.cancelRequest(withError: error)
        }
    }

    func createInboxBatch() throws -> (batch: String, directory: URL) {
        guard let root = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID)
        else { throw ShareImportError.appGroupUnavailable }
        let batch = UUID().uuidString
        let directory = root.appendingPathComponent("\(AppConstants.inboxDirectoryName)/\(batch)")
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            return (batch, directory)
        } catch {
            throw ShareImportError.createDirectoryFailed(error)
        }
    }

    func copyAttachments(to directory: URL) async throws {
        let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? [])
            .flatMap { $0.attachments ?? [] }
        guard !providers.isEmpty else { throw ShareImportError.noAttachments }
        await withThrowingTaskGroup(of: Void.self) { group in
            for (index, provider) in providers.enumerated() {
                group.addTask {
                    try await provider.copyFile(to: directory, index: index)
                }
            }
        }
    }
    
    func openParentApp(with batch: String) async throws {
        guard let url = URL(string: "hsaarchive://home/import-receipts?batch=\(batch)")
        else { throw ShareImportError.invalidDeepLink }
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                let opened = await application.open(url)
                guard opened else { throw ShareImportError.failedToOpenParentApp }
                extensionContext?.completeRequest(returningItems: nil)
                return
            }
            responder = responder?.next
        }
    }
}

// MARK: - NSItemProvider Extension
 
private extension NSItemProvider {
    func copyFile(to directory: URL, index: Int) async throws {
        guard let typeIdentifier = registeredTypeIdentifiers.first else { return }
        let url = try await loadAttachmentURL(for: typeIdentifier)
        try saveImage(at: url, to: directory, index: index)
    }
    
    func loadAttachmentURL(for typeIdentifier: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                if let error {
                    continuation.resume(throwing: ShareImportError.loadAttachmentFailed(error))
                    return
                }
                guard let url else {
                    continuation.resume(throwing: ShareImportError.missingAttachmentURL)
                    return
                }
                continuation.resume(returning: url)
            }
        }
    }

    func saveImage(at url: URL, to directory: URL, index: Int) throws {
        guard let image = url.uiImage else { throw ShareImportError.invalidImage }
        guard let data = image.jpegData(compressionQuality: 0.9)
        else { throw ShareImportError.jpegConversionFailed }
        let fileName = String(format: "%03d.jpg", index)
        let destination = directory.appendingPathComponent(fileName)
        do {
            try data.write(to: destination)
        } catch {
            throw ShareImportError.writeFileFailed(error)
        }
    }
}

// MARK: - ShareImportError

private enum ShareImportError: Error {
    case appGroupUnavailable
    case createDirectoryFailed(Error)
    case noAttachments
    case loadAttachmentFailed(Error)
    case missingAttachmentURL
    case invalidImage
    case jpegConversionFailed
    case writeFileFailed(Error)
    case invalidDeepLink
    case failedToOpenParentApp
}
