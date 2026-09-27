//
//  GoogleAccountService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/18/26.
//

import FactoryKit
import Toast

nonisolated final class GoogleAccountService {
    private let googleAuthService = Container.shared.googleAuthService()
    private let googleDriveService = Container.shared.googleDriveService()
    
    /// Deletes the user's HSA Archive files from Google Drive and signs them out if successful.
    /// Returns the deleted files or `nil` if the request failed.
    func deleteAccount() async -> [ListFilesEndpoint.Response.DriveFile]? {
        guard let files = await googleDriveService.listFiles(
            query: "appProperties has { key='\(AppConstants.spreadsheetAppPropertyKey)' and value='\(AppConstants.spreadsheetAppPropertyValue)' }"
        ) else { return nil }
        let didSucceed = await withTaskGroup { group in
            for file in files {
                group.addTask {
                    do {
                        guard try await self.googleDriveService.deleteFile(id: file.id) != nil else { return false }
                        return true
                    } catch let error as DeleteFileEndpoint.EndpointError {
                        return self.handleDeleteFileError(error)
                    } catch {
                        return false
                    }
                }
            }
            return await group.reduce(true) { $0 && $1 }
        }
        guard didSucceed else { return nil }
        await googleAuthService.signOut()
        await ToastManager.shared.show(DefaultToastType.accountDeleted)
        return files
    }
}

// MARK: - Private Methods

nonisolated private extension GoogleAccountService {
    /// Returns whether the request is considered a success or not.
    func handleDeleteFileError(_ error: DeleteFileEndpoint.EndpointError) -> Bool {
        switch error {
        case .notFound:
            return true
        }
    }
}
