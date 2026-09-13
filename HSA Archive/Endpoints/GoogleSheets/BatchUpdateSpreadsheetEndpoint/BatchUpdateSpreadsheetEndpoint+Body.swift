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
        case deleteDimension(DeleteDimension)
        case deleteSheet(DeleteSheet)
        case updateSheetProperties(UpdateSheetProperties)

        private enum CodingKeys: String, CodingKey {
            case addSheet
            case deleteDimension
            case deleteSheet
            case updateSheetProperties
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case let .addSheet(request):
                try container.encode(request, forKey: .addSheet)
            case let .deleteDimension(request):
                try container.encode(request, forKey: .deleteDimension)
            case let .deleteSheet(request):
                try container.encode(request, forKey: .deleteSheet)
            case let .updateSheetProperties(request):
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

// MARK: - Body+Request+DeleteDimension

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body.Request {
    struct DeleteDimension: Encodable {
        let range: Range
    }
}

nonisolated extension BatchUpdateSpreadsheetEndpoint.Body.Request.DeleteDimension {
    struct Range: Encodable {
        let sheetID: Int
        let dimension: String
        let startIndex: Int
        let endIndex: Int
        
        init(
            sheetID: Int,
            dimension: String = "ROWS",
            startIndex: Int,
            endIndex: Int
        ) {
            self.sheetID = sheetID
            self.dimension = dimension
            self.startIndex = startIndex
            self.endIndex = endIndex
        }

        private enum CodingKeys: String, CodingKey {
            case sheetID = "sheetId"
            case dimension
            case startIndex
            case endIndex
        }
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
