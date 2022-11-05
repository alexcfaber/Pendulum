//
//  Event.swift
//  Pendulum
//
//  Created by Ben Cardy on 04/11/2022.
//

import Foundation
import GRDB

enum EventType: Int, CaseIterable {
    case written = 1
    case received = 2
    case inbound = 3
    case sent = 4
    
    case noEvent = 99
    
    var description: String {
        switch self {
        case .noEvent:
            return "Nothing yet"
        case .written:
            return "Written"
        case .sent:
            return "Sent"
        case .inbound:
            return "Inbound"
        case .received:
            return "Received"
        }
    }
    
    var icon: String {
        switch self {
        case .noEvent:
            return "hourglass"
        case .written:
            return "envelope"
        case .sent:
            return "paperplane"
        case .inbound:
            return "square.and.arrow.down"
        case .received:
            return "pencil.line"
        }
    }
    
    var phrase: String {
        switch self {
        case .noEvent:
            return "Get started!"
        case .written:
            return "You have letters to post!"
        case .sent:
            return "Waiting for a response..."
        case .inbound:
            return "Post is on its way!"
        case .received:
            return "You have letters to reply to!"
        }
    }
    
    var datePrefix: String {
        switch self {
        case .noEvent:
            return "N/A"
        case .written:
            return "You wrote to them"
        case .sent:
            return "You posted their letter"
        case .inbound:
            return "They posted their letter"
        case .received:
            return "You received their letter"
        }
    }
    
    var nextType: EventType? {
        switch self {
        case .noEvent:
            return nil
        case .written:
            return .sent
        case .sent:
            return nil
        case .inbound:
            return .received
        case .received:
            return .written
        }
    }
    
    var nextTypeButtonText: String {
        switch self {
        case .noEvent:
            return ""
        case .written:
            return "I've posted it!"
        case .sent:
            return ""
        case .inbound:
            return "I've received it!"
        case .received:
            return "I've written back!"
        }
    }
    
}

struct Event: Identifiable, Hashable {
    let id: Int64?
    let _type: Int
    let date: Date
    let penpalID: String
    
    var eventType: EventType {
        EventType(rawValue: self._type) ?? .noEvent
    }
    
}

extension Event: Codable, FetchableRecord, MutablePersistableRecord {
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let _type = Column(CodingKeys._type)
        static let date = Column(CodingKeys.date)
    }
    static let penpal = belongsTo(PenPal.self)
    var penpal: QueryInterfaceRequest<PenPal> {
        request(for: Event.penpal)
    }
}
