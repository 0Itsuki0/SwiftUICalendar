//
//  PagedDayViewTabBar.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/12.
//

import SwiftUI

struct DayViewTabBar: View {
    @EnvironmentObject var calendarModel: CalendarModel
    @State var weekId: WeekModel.ID?
    
    var body: some View {
        let weekList = calendarModel.weekList
        let selectedIndex = calendarModel.dayModelFromId(calendarModel.selectedDayId ?? UUID())?.date.weekDay()

        
        ScrollView(.horizontal) {
            LazyHStack(
                spacing: 0
            ) {
                ForEach(weekList) { weekModel in

                    HStackWithPadding{
                        ForEach(weekModel.dayList) { dayModel in
                            let isSelected = dayModel.id == calendarModel.selectedDayId

                            DayView(dayModel: dayModel, showDecoration: false, isSelected: isSelected)
//                                .environmentObject(calendarModel)
                            
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width)
                }
            }
            .scrollTargetLayout()
           
        }
        .scrollPosition(id: $weekId)
        .onAppear{
            if let dayId = calendarModel.selectedDayId,
                let dayModel = calendarModel.dayModelFromId(dayId),
               let weekId = calendarModel.weekIdForDay(dayModel)  {
                self.weekId = weekId
            }
        }
        .onChange(of: weekId) {
            guard let weekId = weekId else { return }
            
            Task {
                await calendarModel.loadMoreIfNeeded(weekId: weekId)
            }
            
            let daysInWeek = calendarModel.dayModelInWeek(weekId)
            
            // selected date within days in week
            if !daysInWeek.filter({$0.id == calendarModel.selectedDayId}).isEmpty {
                print("selected date within days in week")
                return
            }
            
            if let selectedIndex = selectedIndex {
                print("not in, reselecting index: ", selectedIndex)
                withAnimation {
                    calendarModel.selectedDayId = daysInWeek[selectedIndex].id
                }
            }
        }
        .onChange(of: calendarModel.displayWeekId) {
            self.weekId = calendarModel.displayWeekId
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .padding(.all, 0)
        .frame(height: 50, alignment: .center)
        

    }
        
}


#Preview {
    let calendar = CalendarModel()
//    @State var monthId: MonthModel.ID = calendar.idForCurrentMonth()
    @State var dayModel = calendar.monthList.first!.dayList[15]!
    calendar.selectedDayId = dayModel.id

    return DayViewTabBar()
        .environmentObject(calendar)
        .background(Color.blue)

}
