//
//  BatchUpdateSpreadsheetEndpoint+Body.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/15/26.
//

nonisolated extension BatchUpdateSpreadsheetEndpoint {
    struct Body: Encodable {
        let requests: [Request]
    }
}

// MARK: - Body+Request

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body {
    enum Request: Encodable {
        case addSheet(AddSheet)
        case deleteSheet(DeleteSheet)
        case updateSheetProperties(UpdateSheetProperties)

        private enum CodingKeys: String, CodingKey {
            case addSheet
            case deleteSheet
            case updateSheetProperties
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .addSheet(let request):
                try container.encode(request, forKey: .addSheet)
            case .deleteSheet(let request):
                try container.encode(request, forKey: .deleteSheet)
            case .updateSheetProperties(let request):
                try container.encode(request, forKey: .updateSheetProperties)
            }
        }
    }
}

// MARK: - Body+Request+AddSheet

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body.Request {
    struct AddSheet: Encodable {
        let properties: Properties
    }
}

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body.Request.AddSheet {
    struct Properties: Encodable {
        let title: String
    }
}

// MARK: - Body+Request+DeleteSheet

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body.Request {
    struct DeleteSheet: Encodable {
        let sheetID: Int
        
        private enum CodingKeys: String, CodingKey {
            case sheetID = "sheetId"
        }
    }
}

// MARK: - Body+Request+UpdateSheetProperties

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body.Request {
    struct UpdateSheetProperties: Encodable {
        let properties: Properties
        let fields: String
    }
}

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body.Request.UpdateSheetProperties {
    struct Properties: Encodable {
        let sheetID: Int
        let title: String

        private enum CodingKeys: String, CodingKey {
            case sheetID = "sheetId"
            case title
        }
    }
}
