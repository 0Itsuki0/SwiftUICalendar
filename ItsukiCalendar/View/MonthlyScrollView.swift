//
//  MonthlyCalendarView.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/06.
//


import SwiftUI

struct MonthlyScrollView: View {
    
    @EnvironmentObject var calendarModel: CalendarModel
    var animation: Namespace.ID

    
    @State var monthId: MonthModel.ID?
    @State var showMonthLabel: Bool = false
    
    @State var isInitial: Bool = true

    var body: some View {
        let displayedMonthModel = calendarModel.monthModelFromId(monthId)

        VStack(
            alignment: .center,
            spacing: 0
            
        ) {
            // header
            VStack (
                alignment: .center,
                spacing: 10
            ) {
                // year label
                HStack(
                    alignment: .center,
                    spacing: 10
                ) {
                    Text(Image(systemName: "star.fill"))
                        .font(.system(size: 15, weight: .bold))
                    Text(displayedMonthModel?.firstDayOfMonth.localizedYear() ?? "")
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

                
                // weekday label
                HStackWithPadding {
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

            }
            .frame(alignment: .top)
            .padding(.bottom, 5)
            .background(Color(UIColor.systemGray5))
            .overlay(Rectangle()
                .frame(height: 1, alignment: .bottom)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(UIColor.lightGray)), alignment: .bottom)
//            .matchedGeometryEffect(id: "headerBackground", in: animation)


            // monthly calendar stack
            ZStack(
                alignment: .top
            ) {
                // month label
                if (showMonthLabel) {
                    
                    Text(displayedMonthModel?.firstDayOfMonth.localizedYearMonth() ?? "")
                        .font(.system(size: 20))
                        .fontWeight(Font.Weight.bold)
                        .foregroundStyle(Color.black)
                        .foregroundStyle(Color.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .transition(.opacity)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .zIndex(2.0)
                }
                
                // scrollable monthly view
                ScrollView {
                    LazyVStack {
                        ForEach(calendarModel.monthList) { monthModel in
                            MonthView(monthModel: monthModel)
                                .matchedGeometryEffect(id: "DayViewTabBar\(monthModel.id.uuidString)", in: animation)
                        }
                    }
                    .scrollTargetLayout()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .scrollPosition(id: $monthId)
                .padding(.vertical, 10)
                .onAppear{
                    monthId = calendarModel.displayMonthId
                }
                .scrollIndicators(.hidden)
                .onChange(of: monthId, initial: false) {
                    if (monthId == nil) {
                        return
                    }

                    Task {
                        await calendarModel.loadMoreIfNeeded(monthId: monthId!)
                    }
                    
                    if (isInitial) {
                        isInitial = false
                        return
                    }
                    
                    showMonthLabel = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.smooth) {
                            showMonthLabel = false
                        }
                    }

                }


            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            // footer
            HStack {
                Button(Utility.localizedTodaySymbol()) {
                    if displayedMonthModel?.id == calendarModel.idForCurrentMonth() {
                        withAnimation {
                            calendarModel.selectedDayId = calendarModel.idForToday()
                        }
                    } else {
                        withAnimation(.linear(duration: 0.3)) {
                            monthId = calendarModel.idForCurrentMonth()
                        }
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
//    VStack {
//    MonthlyCalendarView()
    @Namespace var animation

    let calendarModel = CalendarModel()
    return VStack {
        MonthlyScrollView(animation: animation)
            .environmentObject(calendarModel)
    }.onAppear {
        print("appearing")
        
    }
}

