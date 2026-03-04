//
//  TrackingView.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Tracking screen - for logging and viewing activities
struct TrackingView: View {
    
    @StateObject private var viewModel = TrackingViewModel()
    @State private var showAddFeeding = false
    @State private var showAddDiaper = false
    @State private var showAddSleep = false
    @State private var editingFeeding: FeedingEntry?
    @State private var editingDiaper: DiaperEntry?
    @State private var editingSleep: SleepEntry?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Category picker
                    categoryPicker
                    
                    // Content based on selected category
                    categoryContent
                }
                .padding(NurtureSpacing.lg)
                .padding(.bottom, 80) // Space for FAB
            }
            .background(NurtureColors.background)
            
            // Floating action button
            addButton
                .padding(NurtureSpacing.xl)
        }
        .navigationTitle("Tracking")
        .onAppear {
            viewModel.loadData()
        }
        .sheet(isPresented: $showAddFeeding) {
            AddFeedingView(viewModel: viewModel)
        }
        .sheet(isPresented: $showAddDiaper) {
            AddDiaperView(viewModel: viewModel)
        }
        .sheet(isPresented: $showAddSleep) {
            AddSleepView(viewModel: viewModel)
        }
        .sheet(item: $editingFeeding) { entry in
            EditFeedingView(viewModel: viewModel, entry: entry)
        }
        .sheet(item: $editingDiaper) { entry in
            EditDiaperView(viewModel: viewModel, entry: entry)
        }
        .sheet(item: $editingSleep) { entry in
            EditSleepView(viewModel: viewModel, entry: entry)
        }
    }
    
    // MARK: - Add Button
    
    private var addButton: some View {
        Button {
            showFormForCurrentCategory()
        } label: {
            HStack(spacing: NurtureSpacing.sm) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                
                Text("Add \(viewModel.selectedCategory.title)")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, NurtureSpacing.lg)
            .padding(.vertical, NurtureSpacing.md)
            .background(
                Capsule()
                    .fill(NurtureColors.primary)
                    .shadow(color: NurtureColors.shadow.opacity(0.3), radius: 12, y: 6)
            )
        }
    }
    
    private func showFormForCurrentCategory() {
        switch viewModel.selectedCategory {
        case .feeding:
            showAddFeeding = true
        case .diaper:
            showAddDiaper = true
        case .sleep:
            showAddSleep = true
        }
    }
    
    // MARK: - View Components
    
    private var categoryPicker: some View {
        HStack(spacing: NurtureSpacing.sm) {
            ForEach(TrackingCategory.allCases, id: \.self) { category in
                categoryButton(category)
            }
        }
    }
    
    private func categoryButton(_ category: TrackingCategory) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectedCategory = category
            }
        } label: {
            HStack(spacing: NurtureSpacing.xs) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(category.title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(viewModel.selectedCategory == category ? .white : NurtureColors.textPrimary)
            .padding(.horizontal, NurtureSpacing.md)
            .padding(.vertical, NurtureSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.full)
                    .fill(viewModel.selectedCategory == category ? NurtureColors.primary : NurtureColors.cardBackground)
            )
            .shadow(
                color: viewModel.selectedCategory == category ? NurtureColors.shadow : .clear,
                radius: 4,
                y: 2
            )
        }
    }
    
    @ViewBuilder
    private var categoryContent: some View {
        switch viewModel.selectedCategory {
        case .feeding:
            feedingList
        case .diaper:
            diaperList
        case .sleep:
            sleepList
        }
    }
    
    // MARK: - Feeding List
    
    private var feedingList: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            sectionHeader(
                title: "Feeding History",
                count: viewModel.feedingEntries.count
            )
            
            if viewModel.feedingEntries.isEmpty {
                emptyStateView(
                    icon: "waterbottle.fill",
                    message: "No feeding entries yet",
                    subMessage: "Start tracking feedings to see them here"
                )
            } else {
                ForEach(viewModel.feedingEntries) { entry in
                    feedingRow(entry)
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteFeedingEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteFeedingEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
    
    private func feedingRow(_ entry: FeedingEntry) -> some View {
        Button {
            editingFeeding = entry
        } label: {
            NurtureCard(padding: NurtureSpacing.md) {
                HStack(spacing: NurtureSpacing.md) {
                    Circle()
                        .fill(NurtureColors.primary.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: entry.feedingType.icon)
                                .font(.system(size: 20))
                                .foregroundColor(NurtureColors.primary)
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.feedingType.displayName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(NurtureColors.textPrimary)
                        
                        if let duration = entry.durationMinutes {
                            Text("\(duration) minutes")
                                .font(.system(size: 14))
                                .foregroundColor(NurtureColors.textSecondary)
                        }
                        
                        if let amount = entry.amountML {
                            Text("\(Int(amount)) ml")
                                .font(.system(size: 14))
                                .foregroundColor(NurtureColors.textSecondary)
                        }
                        
                        Text(formatTime(entry.timestamp))
                            .font(.system(size: 13))
                            .foregroundColor(NurtureColors.textTertiary)
                    }
                    
                    Spacer()
                }
            }
        }
        .buttonStyle(.plain)

    }
    
    // MARK: - Diaper List
    
    private var diaperList: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            sectionHeader(
                title: "Diaper History",
                count: viewModel.diaperEntries.count
            )
            
            if viewModel.diaperEntries.isEmpty {
                emptyStateView(
                    icon: "leaf.fill",
                    message: "No diaper entries yet",
                    subMessage: "Start tracking diaper changes to see them here"
                )
            } else {
                ForEach(viewModel.diaperEntries) { entry in
                    diaperRow(entry)
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteDiaperEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteDiaperEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
    
    private func diaperRow(_ entry: DiaperEntry) -> some View {
        Button {
            editingDiaper = entry
        } label: {
            NurtureCard(padding: NurtureSpacing.md) {
                HStack(spacing: NurtureSpacing.md) {
                    Circle()
                        .fill(NurtureColors.accentSecondary.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: entry.type.icon)
                                .font(.system(size: 20))
                                .foregroundColor(NurtureColors.accentSecondary)
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.type.displayName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(NurtureColors.textPrimary)
                        
                        Text(formatTime(entry.timestamp))
                            .font(.system(size: 13))
                            .foregroundColor(NurtureColors.textTertiary)
                    }
                    
                    Spacer()
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Sleep List
    
    private var sleepList: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            sectionHeader(
                title: "Sleep History",
                count: viewModel.sleepEntries.count
            )
            
            if viewModel.sleepEntries.isEmpty {
                emptyStateView(
                    icon: "moon.fill",
                    message: "No sleep entries yet",
                    subMessage: "Start tracking sleep to see it here"
                )
            } else {
                ForEach(viewModel.sleepEntries) { entry in
                    sleepRow(entry)
                        .contextMenu {
                            if entry.isOngoing {
                                Button {
                                    endSleepSession(entry)
                                } label: {
                                    Label("End Sleep Session", systemImage: "moon.zzz")
                                }
                            }
                            
                            Button(role: .destructive) {
                                deleteSleepEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: !entry.isOngoing) {
                            Button(role: .destructive) {
                                deleteSleepEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            if entry.isOngoing {
                                Button {
                                    endSleepSession(entry)
                                } label: {
                                    Label("End", systemImage: "moon.zzz")
                                }
                                .tint(NurtureColors.success)
                            }
                        }
                }
            }
        }
    }
    
    private func sleepRow(_ entry: SleepEntry) -> some View {
        Button {
            editingSleep = entry
        } label: {
            NurtureCard(padding: NurtureSpacing.md) {
                HStack(spacing: NurtureSpacing.md) {
                    Circle()
                        .fill(NurtureColors.accent.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: entry.isOngoing ? "moon.zzz.fill" : "moon.fill")
                                .font(.system(size: 20))
                                .foregroundColor(NurtureColors.accent)
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.isOngoing ? "Sleeping now" : "Sleep Session")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(NurtureColors.textPrimary)
                        
                        Text(entry.durationDescription)
                            .font(.system(size: 14))
                            .foregroundColor(NurtureColors.textSecondary)
                        
                        Text(formatTime(entry.startTime))
                            .font(.system(size: 13))
                            .foregroundColor(NurtureColors.textTertiary)
                    }
                    
                    Spacer()
                    
                    if entry.isOngoing {
                        Text("Active")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(NurtureColors.success)
                            .padding(.horizontal, NurtureSpacing.sm)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: NurtureCornerRadius.sm)
                                    .fill(NurtureColors.success.opacity(0.15))
                            )
                    }
                }
            }
        }
        .buttonStyle(.plain)

    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            Spacer()
            
            Text("\(count)")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(NurtureColors.textSecondary)
                .padding(.horizontal, NurtureSpacing.sm)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: NurtureCornerRadius.sm)
                        .fill(NurtureColors.primaryLight)
                )
        }
    }
    
    private func emptyStateView(icon: String, message: String, subMessage: String) -> some View {
        NurtureCard {
            VStack(spacing: NurtureSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(NurtureColors.textTertiary)
                
                Text(message)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Text(subMessage)
                    .font(.system(size: 14))
                    .foregroundColor(NurtureColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(NurtureSpacing.xl)
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today at \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday at \(formatter.string(from: date))"
        } else {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
    
    // MARK: - Delete Actions
    
    private func deleteFeedingEntry(_ entry: FeedingEntry) {
        withAnimation {
            viewModel.deleteFeedingEntry(entry)
        }
    }
    
    private func deleteDiaperEntry(_ entry: DiaperEntry) {
        withAnimation {
            viewModel.deleteDiaperEntry(entry)
        }
    }
    
    private func deleteSleepEntry(_ entry: SleepEntry) {
        withAnimation {
            viewModel.deleteSleepEntry(entry)
        }
    }
    
    private func endSleepSession(_ entry: SleepEntry) {
        withAnimation {
            viewModel.endSleepSession(entry)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TrackingView()
    }
}

