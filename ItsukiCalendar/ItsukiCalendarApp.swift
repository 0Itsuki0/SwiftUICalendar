//
//  ItsukiCalendarApp.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/06.
//

import SwiftUI

@main
struct ItsukiCalendarApp: App {
    var body: some Scene {
//        let calendar = CalendarModel()
    //    @State var monthId: MonthModel.ID = calendar.idForCurrentMonth()

        
        WindowGroup {

//            ContentView()

//            let dayModel = calendar.monthList.first!.dayList[7]!
//            calendar.selectedDayId = dayModel.id

            let calendar = CalendarModel()
//            @State var monthId: MonthModel.ID = calendar.idForCurrentMonth()
            @State var dayModel = calendar.dayList[10]
//            calendar.selectedDayId = dayModel.id
            
            return CalendarContentView()
            
//            return MatchedGeometryDemo()
//            return NavigationStackDemo()
//            return DailyEventView(animation: animation)
//                .environmentObject(calendar)
//            return MonthlyScrollView()
//                .environmentObject(calendar)
//            return EventView()
//                .environmentObject(calendar)
//                .background(Color.blue)
        

        //    print("monthId: \(monthId)")
        //    print("dayModel: \(dayModel)")

//            return DailyEventView()
//                .environmentObject(calendar)

        }
    }
}
