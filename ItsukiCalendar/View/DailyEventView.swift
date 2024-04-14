//
//  DayEventView.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/07.
//

import SwiftUI


struct DailyEventView: View {
    @EnvironmentObject var calendarModel: CalendarModel
    var animation: Namespace.ID


    var body: some View {

        let selectedDayModel = calendarModel.dayModelFromId(calendarModel.selectedDayId ?? UUID())
        

        VStack(
            alignment: .center,
            spacing: 0
            
        ) {
            // header
            VStack (
                alignment: .center,
                spacing: 10
            ) {
                // month label     
                HStack(
                    alignment: .center,
                    spacing: 10
                ) {
                    Text(Image(systemName: "chevron.left"))
                        .font(.system(size: 15, weight: .bold))
                    Text(selectedDayModel?.date.localizedMonth() ?? "")
                       .font(.system(size: 20))
                       
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .foregroundStyle(Color.red)
                .onTapGesture {
                    withAnimation {
                        calendarModel.selectedDayId = nil
                    }
                }

                

                VStack (
                    alignment: .center,
                    spacing: -3
                ) {
                    // weekday label
                    HStackWithPadding  {
                        let weekdaySymbols = Utility.weekdaySymbols()
                        ForEach(0..<weekdaySymbols.count, id: \.self) { i in
                            let symbol = weekdaySymbols[i]
                            Text(symbol)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 16))
                                .padding(.all, 5)
                                .foregroundStyle((i == 0 || i == 6) ? Color.red : Color.black)
                        }
                    }
                    
                    // days label
                    DayViewTabBar()
                        .matchedGeometryEffect(id: "DayViewTabBar\(calendarModel.displayMonthId?.uuidString ?? "")", in: animation)
                    
                    // date label
                    Text("\(selectedDayModel?.date.localizedDateWithWeekday() ?? "")")

                }
                


            }
            .frame(alignment: .top)
            .padding(.bottom, 5)
            .background(Color(UIColor.systemGray5))
            .overlay(Rectangle()
                .frame(height: 1, alignment: .bottom)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(UIColor.lightGray)), alignment: .bottom)
            
                
            // paged weekly tab bar
            EventView()

            
            // footer
            HStack {
                Button(Utility.localizedTodaySymbol()) {
                    withAnimation(.linear(duration: 0.3)) {
                        calendarModel.selectedDayId = calendarModel.idForToday()
                    }
                }
                .foregroundStyle(Color.red)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color(UIColor.systemGray5))
            .overlay(Rectangle()
                .frame(height: 1, alignment: .top)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(UIColor.lightGray)), alignment: .top)
            
            
        }
        
    }
    
}


#Preview {

    let calendar = CalendarModel()
//    @State var monthId: MonthModel.ID = calendar.idForCurrentMonth()
    @State var dayModel = calendar.dayList[10]
    calendar.selectedDayId = dayModel.id

//    print("monthId: \(monthId)")
//    print("dayModel: \(dayModel)")
    @Namespace var animation

    return DailyEventView(animation: animation)
        .environmentObject(calendar)


}

