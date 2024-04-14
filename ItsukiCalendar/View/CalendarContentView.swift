//
//  CalendarContentView.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/14.
//

import SwiftUI


struct CalendarContentView: View {
    @StateObject var calendarModel = CalendarModel()
    @Namespace var animation
        
    var body: some View {
        ZStack {
            if (calendarModel.selectedDayId == nil) {
                MonthlyScrollView(animation: animation)
                    .environmentObject(calendarModel)

            } else {
                DailyEventView(animation: animation)
                    .environmentObject(calendarModel)
            }
        }

    }
}


#Preview {
    return CalendarContentView()
}


