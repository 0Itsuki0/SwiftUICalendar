//
//  EventView.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/13.
//


import SwiftUI

struct EventView: View {
    @EnvironmentObject var calendarModel: CalendarModel
//    @State var dayId: DayModel.ID?

    var body: some View {
    
        ScrollView(.horizontal) {
            LazyHStack(
                spacing: 0
            ) {
                ForEach(calendarModel.dayList) { dayModel in
//                    let state = dayModel.state
                    VStack{
                        Text("\(dayModel.date)")
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .frame(width: UIScreen.main.bounds.size.width)
                    .background(Color.white)
                }
            }
            .scrollTargetLayout()
//            .padding(.vertical, 10)
            .background(Color.yellow)
           
        }
        .scrollPosition(id: $calendarModel.selectedDayId)
//        .onAppear{
//            print("appear")
//            
//            self.dayId = calendarModel.selectedDayId
//
//        }
        .onChange(of: calendarModel.selectedDayId) {

            guard let dayId = calendarModel.selectedDayId else { return }
            Task {
                await calendarModel.loadMoreIfNeeded(dayId: dayId)
            }

        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .padding(.horizontal, 0)
        .padding(.vertical, 10)
        .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

    }
        
}


#Preview {
    let calendar = CalendarModel()
//    @State var monthId: MonthModel.ID = calendar.idForCurrentMonth()
    let dayModel = calendar.monthList.first!.dayList[15]!
    calendar.selectedDayId = dayModel.id

    return EventView()
        .environmentObject(calendar)
        .background(Color.blue)

}

