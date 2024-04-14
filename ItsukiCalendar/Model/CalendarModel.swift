//
//  CalendarModel.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/06.
//

import SwiftUI

class CalendarModel: ObservableObject {
    var monthList: [MonthModel] = []
    var weekList: [WeekModel] = []
    @Published var dayList: [DayModel] = [] {
        didSet {
            monthList = makeMonthList()
            weekList = makeWeekList()
        }
    }
    
    @Published var selectedDayId: DayModel.ID? = nil {
        willSet(newValue) {
            if let newDayId = newValue, let dayModel = dayModelFromId(newDayId) {
                displayMonthId = monthIdForDay(dayModel)
                displayWeekId = weekIdForDay(dayModel)
            }
        }
    }
    var displayMonthId: MonthModel.ID?
    var displayWeekId: WeekModel.ID?

    
    init() {
        let today = Date()
        let firstDayOfCurrentMonth = today.firstDayOfMonth()
        var firstDayOfMonth = firstDayOfCurrentMonth.minusMonth(2)

        var dayList: [DayModel] = []
        

        for _ in 0..<5 {
            let daysInMonth = firstDayOfMonth.daysInMonth()
            var date = firstDayOfMonth
            for _ in 0..<daysInMonth {
                dayList.append(DayModel(date))
                date = date.plusDate()
            }
            firstDayOfMonth = firstDayOfMonth.plusMonth()
        }
        self.dayList = dayList
        
        self.displayMonthId = idForCurrentMonth()
    }
    
    
    func weekIdForDay(_ dayModel: DayModel) -> WeekModel.ID? {
        return weekList.first(where: {$0.dayList.contains(dayModel)})?.id
    }

    
    func weekIdForMonthRow(_ monthModel: MonthModel, row: Int) -> WeekModel.ID? {
        if row  > 0 {
            return monthModel.dayList[row*7]?.id
        }
        let startingSpace = monthModel.firstDayOfMonth.weekDay()
        let firstDayOfWeek = monthModel.firstDayOfMonth.minusDate(startingSpace)
        let weekModel = weekList.first{$0.firstDayOfWeek == firstDayOfWeek}
        return weekModel?.id

    }

    
    func monthIdForDay(_ dayModel: DayModel) -> MonthModel.ID? {
        return  monthList.first(where: {$0.dayList.contains(dayModel)})?.id
    }
    
    
    func idForCurrentMonth() -> MonthModel.ID? {
        let today = Date()
        let firstDayOfCurrentMonth = today.firstDayOfMonth()
        let dayModel = dayList.first(where: ({$0.date == firstDayOfCurrentMonth}))
        return dayModel?.id
    }
    
    func idForToday() -> DayModel.ID? {
        let dayModel = dayList.first(where: ({$0.date.isToday()}))
        return dayModel?.id
    }
    
    func monthModelFromId(_ id: MonthModel.ID?) -> MonthModel? {
        return monthList.first(where: {$0.id == id })
    }
    
    
    func dayModelFromId(_ id: DayModel.ID) -> DayModel? {
        return dayList.first(where: {$0.id == id})
    }
    
    
    func dayModelInWeek(_ weekId: WeekModel.ID) -> [DayModel] {
        guard let index = dayList.firstIndex(where: {$0.id == weekId}) else {return []}
        return Array(dayList[(index) ..< (index + 7)])
    }
    

    
    
    private func makeWeekList() -> [WeekModel] {
        if dayList.isEmpty {
            return []
        }
        var index = dayList.firstIndex(where: {$0.date.weekDay() == 0}) ?? 0
        var weekList: [WeekModel] = []
        while index < dayList.count - 8 {
            let weekModel = WeekModel(Array(dayList[index ..< index + 7]))
            weekList.append(weekModel)
            index = index + 7
        }
        return weekList
    }
    
    private func makeMonthList() -> [MonthModel] {
        if dayList.isEmpty {
            return []
        }
        var firstDate = dayList[0].date

        var index = 0
        var endIndex = firstDate.daysInMonth()
        var monthList: [MonthModel] = []
        while endIndex <= dayList.count {
            let monthModel = MonthModel(Array(dayList[index ..< endIndex]))
            monthList.append(monthModel)
            
            firstDate = firstDate.plusMonth()
            index = endIndex
            endIndex = endIndex + firstDate.daysInMonth()
        }
        
        return monthList
    }
    
    
    
   
    
    func addMonthAfter(_ count: Int) async {
        sleep(1)

        var firstDayOfLastMonth = dayList.last!.date.firstDayOfMonth()
        firstDayOfLastMonth = firstDayOfLastMonth.plusMonth()

        var newDayList: [DayModel] = []
        for _ in 0..<count {
            let daysInMonth = firstDayOfLastMonth.daysInMonth()

            var date = firstDayOfLastMonth

            for _ in 0..<daysInMonth {
                newDayList.append(DayModel(date))
                date = date.plusDate()
            }
            firstDayOfLastMonth = firstDayOfLastMonth.plusMonth()

        }
        DispatchQueue.main.async { [newDayList] in
            self.dayList.append(contentsOf: newDayList)
        }
    }
    
    
    func addMonthBefore(_ count: Int) async {
        sleep(1)
        var firstDayOfFirstMonth = dayList.first!.date.firstDayOfMonth()
        firstDayOfFirstMonth = firstDayOfFirstMonth.minusMonth(count)
        
        var newDayList: [DayModel] = []

        for _ in 0..<count {
            let daysInMonth = firstDayOfFirstMonth.daysInMonth()
            var date = firstDayOfFirstMonth

            for _ in 0..<daysInMonth  {
                newDayList.append(DayModel(date))
                date = date.plusDate()
            }
            firstDayOfFirstMonth = firstDayOfFirstMonth.plusMonth()

        }
        
        DispatchQueue.main.async { [newDayList] in
            self.dayList.insert(contentsOf: newDayList, at: 0)
        }

    }
}



extension CalendarModel {
    func loadMoreIfNeeded(dayId: DayModel.ID) async {
        guard let currentDayIndex = dayList.firstIndex(where: {$0.id == dayId}) else {return}
    
        if currentDayIndex >= dayList.count - 1 {
            
//            print("last visible day")
            await addMonthAfter(1)
            
        } else if currentDayIndex <=  0 {
            
//            print("first visible day")
            await addMonthBefore(1)
            
        }
    }
    
    func loadMoreIfNeeded(monthId: MonthModel.ID) async {
        if monthId == monthList.last?.id {
//            print("last visible row")
            Task {
                await addMonthAfter(2)
            }
        } else if monthId == monthList.first?.id {
//            print("first visible row")
            Task {
                await addMonthBefore(2)

            }
        }
        
    }
    
    func loadMoreIfNeeded(weekId: WeekModel.ID) async {
        guard let currentWeekIndex = weekList.firstIndex(where: {$0.id == weekId}) else {return}
    
        if currentWeekIndex >= weekList.count - 1 {
            
//            print("last visible week")
            await addMonthAfter(1)
            
        } else if currentWeekIndex <=  0 {
            
//            print("first visible week")
            await addMonthBefore(1)
            
        }
        
    }
}
