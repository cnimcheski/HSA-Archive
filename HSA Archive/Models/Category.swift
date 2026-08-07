//
//  Category.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/23/26.
//

import FirebaseAI
import Foundation

enum Category: String, AIResponse, CaseIterable, Decodable {
    case prescription = "Prescription"
    case overTheCounter = "Over-the-Counter"
    case doctorVisit = "Doctor Visit"
    case dental = "Dental"
    case vision = "Vision"
    case mentalHealth = "Mental Health"
    case hospital = "Hospital"
    case urgentCare = "Urgent Care"
    case laboratory = "Laboratory"
    case medicalEquipment = "Medical Equipment"
    case medicalSupplies = "Medical Supplies"
    case womensHealth = "Women's Health"
    case physicalTherapy = "Physical Therapy"
    case pharmacy = "Pharmacy"
    case other = "Other"
    
    var selection: Selection {
        .init(title: rawValue, systemImage: systemImage)
    }
    
    private var systemImage: String {
        switch self {
        case .prescription:
            "pills.fill"
        case .overTheCounter:
            "cross.case.fill"
        case .doctorVisit:
            "stethoscope"
        case .dental:
            "mouth.fill"
        case .vision:
            "eye.fill"
        case .mentalHealth:
            "brain.head.profile"
        case .hospital:
            "cross.case"
        case .urgentCare:
            "cross.case.circle.fill"
        case .laboratory:
            "testtube.2"
        case .medicalEquipment:
            "figure.roll"
        case .medicalSupplies:
            "bandage.fill"
        case .womensHealth:
            "figure.and.child.holdinghands"
        case .physicalTherapy:
            "figure.walk.motion"
        case .pharmacy:
            "cross.vial.fill"
        case .other:
            "square.grid.2x2"
        }
    }
    
    static var schema: Schema {
        Schema.enumeration(
            values: rawValues,
            description: "The category that best matches the HSA-eligible expense. Use 'Other' if none apply."
        )
    }
}
