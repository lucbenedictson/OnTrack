//
//  CalendarView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-24.
//


import SwiftUI
//
////1) Need to fit 7 dates on screen no matter what screen width ✅
////2) Date to the left always needs to be the most recent sunday ✅
////3) add sun - sat labels above days
////

struct WeekView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var store: TaskStore
    
    let nPanels = 21 // Number of days in the scrollable view
    let nVisiblePanels = 7
    let dayOfMonthFormatter = DateFormatter()
    let monthNameFormatter = DateFormatter()
    
    let panelSize: CGFloat
    let gapSize: CGFloat
    let baseDate: Date
    
    let category: Category?
    let showComplete: Bool
    
    @Binding var selectedDate: Date
    
    @State private var snappedWeekOffset = 0
    @State private var draggedWeekOffset = Double.zero
    
    init(currentDate: Binding<Date>, availableWidth width: CGFloat, category: Category?, showComplete: Bool) {
        dayOfMonthFormatter.dateFormat = "d"
        monthNameFormatter.dateFormat = "MMMM"
        self.baseDate = Date.closestWednesdayTo(Date.now)
        self._selectedDate = currentDate
        self.panelSize = width / CGFloat(nVisiblePanels + 1) // Get width for eight slots
        self.gapSize = panelSize / CGFloat(nVisiblePanels + 1) // Add 1/8 of each slot width for panel gap
        self.category = category
        self.showComplete = showComplete
        // result --> 7 panels with consistent spacing
        
        let dateOffSet = calculateDateOffSet(from: Date.now, to: selectedDate)
        self._snappedWeekOffset = State(initialValue: dateOffSet)
        self._draggedWeekOffset = State(initialValue: Double(dateOffSet * 7))
    }

    private var positionWidth: CGFloat {
        CGFloat(panelSize + gapSize)
    }
    
    private func calculateDateOffSet(from: Date, to: Date) -> Int {
        let calendar = Calendar.current
        let weekOffset = calendar.dateComponents([.day] , from: Date.closestWednesdayTo(from.startOfDay), to: Date.closestWednesdayTo(to.startOfDay))
        return weekOffset.day! / 7
    }

    private func xOffsetForIndex(_ index: Int) -> Double {
        let midIndex = Double(nPanels / 2)
        var dIndex = (Double(index) - draggedWeekOffset - midIndex).truncatingRemainder(dividingBy: Double(nPanels))
        if dIndex < -midIndex {
            dIndex += Double(nPanels)
        } else if dIndex > midIndex {
            dIndex -= Double(nPanels)
        }
        return dIndex * positionWidth
    }

    private func dayAdjustmentForIndex(_ index: Int) -> Int {
        let midIndex = nPanels / 2
        var dIndex = (index - snappedWeekOffset * 7 - midIndex) % nPanels
        if dIndex < -midIndex {
            dIndex += nPanels
        } else if dIndex > midIndex {
            dIndex -= nPanels
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
//        .background(dateToDisplay.startOfDay == selectedDate.startOfDay ? Circle().fill(Color.accentColor.secondary) : nil)
        .background(dateBackground(for: dateToDisplay))
        .offset(x: xOffset)
        .opacity(xOffset + positionWidth < -halfFullWidth || xOffset - positionWidth > halfFullWidth ? 0 : 1)
    }
    
    private func dateBackground(for date: Date) -> some View {
        let selectedCircle = Circle().fill(Color.accentColor.secondary)
        let taskIndicator = Circle().fill(Color.primary).frame(width: 6, height: 6).offset(y: (panelSize/2) - 3)
        
        return (date.startOfDay == selectedDate.startOfDay ? selectedCircle : nil)
            .overlay(!store.isEmpty(category, on: date, allowsComplete: showComplete) ? taskIndicator : nil)
                    
        
    }
    
    private var dragged: some Gesture {
        DragGesture()
               .onChanged { val in
                   draggedWeekOffset = Double(snappedWeekOffset * 7) - (val.translation.width / positionWidth)
               }
               .onEnded { val in
                   // Calculate the change in week offset
                   let totalWeeksScrolled = (val.translation.width / positionWidth).rounded() / 4 //low the number , the less distance you need to scroll to change weeks
                   let snappedEndWeek = snappedWeekOffset - Int(totalWeeksScrolled)

                   // Snap to the nearest week within the allowed range of -1, 0, or 1 week from the start
                   snappedWeekOffset = max(min(snappedEndWeek, snappedWeekOffset + 1), snappedWeekOffset - 1)

                   withAnimation(.easeInOut(duration: 0.15)) {
                       draggedWeekOffset = Double(snappedWeekOffset * 7)
                   }
               }
    }

    var body: some View {
        VStack(spacing: 10) {
            titleView

            scrollableDays
                .frame(maxHeight: panelSize)
            
            TaskListView(category: category, date: selectedDate, showComplete: showComplete)
        }
    }
    
//    @State private var minimumScaleFactor: CGFloat = 1.0
    
    var titleView: some View {
        let weekDays: [String] = DateFormatter().shortWeekdaySymbols ?? []
        
        return Group {
            HStack {
                Text(selectedDate.MY)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
            }
            
            HStack(spacing: 0) {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .appFont()
                        .foregroundStyle(.secondary)
                        .frame(width: positionWidth)
                }
            }
        }
    }
    
        
    var scrollableDays: some View {
        GeometryReader { proxy in
            let halfFullWidth = proxy.size.width / 2
            ZStack {
                ForEach(0..<nPanels, id: \.self) { index in
                    dateView(index: index, halfFullWidth: halfFullWidth)
                        .onTapGesture {
                            selectedDate = dateForIndex(index)
                        }
                        .appFont()
                }
            }
            .gesture(dragged)
            .frame(maxWidth: .infinity)
        }
    }
}


