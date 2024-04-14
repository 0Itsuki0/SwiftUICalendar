//
//  DayModel.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/06.
//

import Foundation


struct DayModel: Identifiable, Equatable  {
    let id: UUID = UUID()
    
    var date: Date
    var hasEvent: Bool = false
        
    init(_ date: Date) {
        self.date = date
        if date.day() == 5 {
            self.hasEvent = true
        }
    }
    
    
    static func == (lhs: DayModel, rhs: DayModel) -> Bool{
        return lhs.id == rhs.id
    }
    
}
