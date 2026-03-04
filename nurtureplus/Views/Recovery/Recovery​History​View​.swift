//
//  Recovery​History​View​.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Full history view for recovery entries
struct RecoveryHistoryView: View {
    
    @StateObject private var viewModel = RecoveryViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let babyID: UUID
    
    @State private var showingAddRecovery = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.recoveryEntries.isEmpty {
                    emptyStateView
                } else {
                    recoveryList
                }
            }
            .background(NurtureColors.background)
            .navigationTitle("Recovery History")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddRecovery = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                    }
                }
            }
            .sheet(isPresented: $showingAddRecovery) {
                AddRecoveryView(viewModel: viewModel, babyID: babyID)
                    .onDisappear {
                        viewModel.loadRecoveryEntries(for: babyID)
                    }
            }
            .task {
                viewModel.loadRecoveryEntries(for: babyID)
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: NurtureSpacing.lg) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80))
                .foregroundColor(NurtureColors.accent.opacity(0.3))
            
            Text("No Recovery Check-Ins Yet")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            Text("Track your recovery journey.\nYour well-being matters too.")
                .font(.system(size: 16))
                .foregroundColor(NurtureColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddRecovery = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Check-In")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, NurtureSpacing.xl)
                .padding(.vertical, NurtureSpacing.md)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [NurtureColors.accent, NurtureColors.primary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
            .padding(.top, NurtureSpacing.md)
            
            Spacer()
        }
        .padding(NurtureSpacing.xl)
    }
    
    // MARK: - Recovery List
    
    private var recoveryList: some View {
        ScrollView {
            VStack(spacing: NurtureSpacing.md) {
                // Stats card
                statsCard
                
                // Entries
                ForEach(viewModel.recoveryEntries) { entry in
                    RecoveryCard(entry: entry) {
                        viewModel.startEditing(entry)
                        showingAddRecovery = true
                    }
                    .contextMenu {
                        Button {
                            viewModel.startEditing(entry)
                            showingAddRecovery = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            deleteEntry(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteEntry(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(NurtureSpacing.lg)
        }
    }
    
    private var statsCard: some View {
        NurtureCard {
            VStack(spacing: NurtureSpacing.md) {
                HStack {
                    Text("7-Day Average")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(NurtureColors.textSecondary)
                    
                    Spacer()
                }
                
                HStack(spacing: NurtureSpacing.xl) {
                    VStack(spacing: NurtureSpacing.xs) {
                        Text("💧")
                            .font(.system(size: 28))
                        
                        Text(String(format: "%.0f oz", viewModel.averageWaterIntake(for: babyID, days: 7)))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(NurtureColors.primary)
                        
                        Text("Water")
                            .font(.system(size: 12))
                            .foregroundColor(NurtureColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 60)
                    
                    VStack(spacing: NurtureSpacing.xs) {
                        Text("📝")
                            .font(.system(size: 28))
                        
                        Text("\(viewModel.recoveryEntries.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .weekOfYear) }.count)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(NurtureColors.accent)
                        
                        Text("Check-Ins")
                            .font(.system(size: 12))
                            .foregroundColor(NurtureColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func deleteEntry(_ entry: RecoveryEntry) {
        do {
            try viewModel.deleteEntry(entry)
        } catch {
            print("Error deleting entry: \(error)")
        }
    }
}

// MARK: - Preview

#Preview {
    RecoveryHistoryView(babyID: UUID())
}

