//
//  CalendarView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-24.
//

//The correct base date and starting value cannot be calculated, view will lose functionality in the following ways...
//1) Wont start on the correct day
//2) Will not be sunday-saturday labelled as it is not guarenteed dates will properly align
//3) On a scroll, selected date will not snap to the next or most recent sunday

import SwiftUI

struct WeekAtAGlanceView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskStore: TaskStore
    @ObservedObject var userPreferencesStore: UserPreferencesStore
    
    private struct Constants {
        struct weekAndDays {
            static let fontSize = CGFloat(17)
            static let fontWeight: Font.Weight = .regular
        }
        
        struct Animations {
            static let weekScroll: Animation = .easeInOut(duration: 0.15)
        }
        
        struct Panels {
            static let num = 21 // Number of days in the scrollable view
            static let numVisible = 7
        }
    }
    
    let dayOfMonthFormatter = DateFormatter()
    let monthNameFormatter = DateFormatter()
    
    let panelSize: CGFloat
    let gapSize: CGFloat
    let baseDate: Date
    let correctBaseDate: Bool //If true, then can use full functionality of view, if false, must account for incorrect parameters
    
    @State private var snappedWeekOffset = 0
    @State private var prevSnappedWeekOffset = 0 //hold the previous snapped weekoffset to determine if scroll is moving forward or backwards
    @State private var draggedWeekOffset = Double.zero
    
    init(_ userPreferencesStore: UserPreferencesStore, availableWidth width: CGFloat) {
        dayOfMonthFormatter.dateFormat = "d"
        monthNameFormatter.dateFormat = "MMMM"
        self.panelSize = width / CGFloat(Constants.Panels.numVisible + 1) // Get width for eight slots
        self.gapSize = panelSize / CGFloat(Constants.Panels.numVisible + 1) // Add 1/8 of each slot width for panel gap
        
        //Scroll starting parameters
        self.userPreferencesStore = userPreferencesStore
        if let base = Date.closestWednesdayTo(Date.now), let start = Date.closestWednesdayTo(userPreferencesStore.preferences.date) {
            
            baseDate = base
            correctBaseDate = true
            let dateOffSet = Date.calculateWeekOffset(from: base, to: start)
            
            self._snappedWeekOffset = State(initialValue: dateOffSet)
            self._prevSnappedWeekOffset = State(initialValue: dateOffSet)
            self._draggedWeekOffset = State(initialValue: Double(dateOffSet * 7))
            
        } else {
            
            baseDate = Date.now
            correctBaseDate = false
            
        }
    }
    
    private var positionWidth: CGFloat {
        CGFloat(panelSize + gapSize)
    }

    private func xOffsetForIndex(_ index: Int) -> Double {
        let midIndex = Double(Constants.Panels.num / 2)
        var dIndex = (Double(index) - draggedWeekOffset - midIndex).truncatingRemainder(dividingBy: Double(Constants.Panels.num))
        if dIndex < -midIndex {
            dIndex += Double(Constants.Panels.num)
        } else if dIndex > midIndex {
            dIndex -= Double(Constants.Panels.num)
        }
        return dIndex * positionWidth
    }

    private func dayAdjustmentForIndex(_ index: Int) -> Int {
        let midIndex = Constants.Panels.num / 2
        var dIndex = (index - snappedWeekOffset * 7 - midIndex) % Constants.Panels.num
        if dIndex < -midIndex {
            dIndex += Constants.Panels.num
        } else if dIndex > midIndex {
            dIndex -= Constants.Panels.num
        }
        return dIndex + snappedWeekOffset * 7
    }
    
    private func dateForIndex(_ index: Int) -> Date {
        let dayAdjustment = dayAdjustmentForIndex(index)
        return Calendar.current.date(byAdding: .day, value: dayAdjustment, to: baseDate) ?? baseDate
    }

    private func dateView(index: Int, halfFullWidth: CGFloat) -> some View {
        let xOffset = xOffsetForIndex(index)
        let dateToDisplay = dateForIndex(index)
        return VStack {
            Text(dayOfMonthFormatter.string(from: dateToDisplay))
        }
        .frame(width: panelSize, height: panelSize)
        .background(dateBackground(for: dateToDisplay))
        .offset(x: xOffset)
        .opacity(xOffset + positionWidth < -halfFullWidth || xOffset - positionWidth > halfFullWidth ? 0 : 1)
    }
    
    private func dateBackground(for date: Date) -> some View {
        let selectedCircle = Circle().fill(Color.accentColor.secondary)
        let taskIndicator = Circle().fill(Color.primary).frame(width: 6, height: 6).offset(y: (panelSize/2) - 3)
        
        return (date.startOfDay == userPreferencesStore.preferences.date.startOfDay ? selectedCircle : nil)
            .overlay(!isEmptyList(onDate: date) ? taskIndicator : nil)
    }
    
    private func isEmptyList(onDate date: Date) -> Bool {
        taskStore.tasks
            .filterByDay(date)
            .filterByCategory(userPreferencesStore.preferences.category)
            .filterByCompletionStatus(userPreferencesStore.preferences.showComplete)
            .isEmpty
    }
    
    private var dragged: some Gesture {
        DragGesture()
               .onChanged { val in
                   draggedWeekOffset = Double(snappedWeekOffset * 7) - (val.translation.width / positionWidth)
               }
               .onEnded { val in
                   // Calculate the change in week offset
                   let totalWeeksScrolled = (val.translation.width / positionWidth).rounded() / 4 //lower the number , the less distance you need to scroll to change weeks
                   let snappedEndWeek = snappedWeekOffset - Int(totalWeeksScrolled)

                   // Snap to the nearest week within the allowed range of -1, 0, or 1 week from the start
                   snappedWeekOffset = max(min(snappedEndWeek, snappedWeekOffset + 1), snappedWeekOffset - 1)
                   

                   withAnimation(Constants.Animations.weekScroll) {
                       draggedWeekOffset = Double(snappedWeekOffset * 7)
                       
                       if correctBaseDate {
                           if  snappedWeekOffset > prevSnappedWeekOffset {
                               if let weekAhead = Date.weekAhead(from: userPreferencesStore.preferences.date), let sundayAhead = Date.mostRecentSunday(from: weekAhead) {
                                   userPreferencesStore.preferences.date = sundayAhead
                               }
                           }
                           
                           if snappedWeekOffset < prevSnappedWeekOffset {
                               if let weekBehind = Date.weekBehind(from: userPreferencesStore.preferences.date), let sundayBehind = Date.mostRecentSunday(from: weekBehind) {
                                   userPreferencesStore.preferences.date = sundayBehind
                               }
                           }
                       }
                   }
                   
                   prevSnappedWeekOffset = snappedWeekOffset
               }
    }

    var body: some View {
        VStack(spacing: 10) {
            titleView

            scrollableDays
                .frame(maxHeight: panelSize)
            
            TaskListView(userPreferencesStore)
        }
    }
    
    private var titleView: some View {
        let weekDays: [String] = DateFormatter().shortWeekdaySymbols ?? []
        
        return Group {
            HStack {
                Text(userPreferencesStore.preferences.date.MY)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
            }
            
            if(correctBaseDate) {
                HStack(spacing: 0) {
                    ForEach(weekDays, id: \.self) { day in
                        Text(day)
                            .font(.system(size: Constants.weekAndDays.fontSize, weight: Constants.weekAndDays.fontWeight))
                            .foregroundStyle(.secondary)
                            .frame(width: positionWidth)
                    }
                }
            }
        }
    }
    
        
    private var scrollableDays: some View {
        GeometryReader { proxy in
            let halfFullWidth = proxy.size.width / 2
            ZStack {
                ForEach(0..<Constants.Panels.num, id: \.self) { index in
                    dateView(index: index, halfFullWidth: halfFullWidth)
                        .onTapGesture {
                            userPreferencesStore.preferences.date = dateForIndex(index)
                        }
                        .font(.system(size: Constants.weekAndDays.fontSize, weight: Constants.weekAndDays.fontWeight))
                }
            }
            .gesture(dragged)
            .frame(maxWidth: .infinity)
        }
    }
}


