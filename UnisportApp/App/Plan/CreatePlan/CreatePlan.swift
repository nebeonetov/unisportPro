//
//  CreatePlanView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import SwiftUI
import RealmSwift

struct CreatePlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CreatePlanViewModel()
    var onSave: (() -> Void)? // Callback after saving

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32)
    private let secondaryTextColor = Color.gray
    private let placeholderTextColor = Color.gray

    var body: some View {
        // Wrap in NavigationView to get Navigation Bar for title/buttons
        NavigationView {
            VStack(spacing: 0) { // Use spacing 0 for seamless list
                // Use List for potential performance benefits and standard row separators
                List {
                    // Section for Plan Title
                    Section {
                         TextField("Enter Plan Title", text: $viewModel.planTitle)
                             .listRowBackground(cardBackgroundColor) // Apply background to row
                             .foregroundColor(.white)
                             .padding(.vertical, 5) // Add some padding inside the textfield row
                    } header: {
                         Text("Plan Name")
                             .foregroundColor(secondaryTextColor)
                             .padding(.top) // Add padding above first section header
                    }


                    // Section for Daily Schedule
                    Section {
                        ForEach($viewModel.dayEntries) { $entry in
                            PlanDayRow(
                                entry: $entry,
                                dayNumber: (viewModel.dayEntries.firstIndex(where: { $0.id == entry.id }) ?? 0) + 1,
                                accentColor: accentColor,
                                secondaryTextColor: secondaryTextColor,
                                cardBackgroundColor: cardBackgroundColor,
                                placeholderTextColor: placeholderTextColor,
                                updateDateAction: { newDate in
                                    viewModel.updateDate(for: entry.id, newDate: newDate)
                                }
                            )
                            .listRowInsets(EdgeInsets()) // Remove default padding
                            .listRowSeparator(.hidden) // Hide default separators
                             .padding(.vertical, 8) // Add custom vertical padding between rows
                             .listRowBackground(backgroundColor) // Match background


                        }
                         // Button to Add Day
                         Button(action: viewModel.addDay) {
                              Label("Add Day", systemImage: "plus.circle.fill")
                                  .foregroundColor(accentColor)
                         }
                         .listRowBackground(cardBackgroundColor)
                         .frame(maxWidth: .infinity, alignment: .center)
                         .padding(.vertical, 5)


                    } header: {
                         Text("Schedule Your Training")
                             .font(.body) // Use body font matching design
                             .foregroundColor(secondaryTextColor) // Use subtle color
                             .fontWeight(.regular)
                             .textCase(nil) // Remove uppercasing
                             .padding(.bottom, 5) // Add spacing below header
                    } footer: {
                         Text("Plan your daily activities leading up to your competition.")
                             .font(.caption)
                              .foregroundColor(secondaryTextColor)
                              .padding(.bottom) // Add padding below footer
                    }


                }
                .listStyle(.plain) // Use plain style to remove default List background/styling
                 .background(backgroundColor) // Set background for the whole List area
                 .scrollContentBackground(.hidden) // Needed for List background color
                 .environment(\.defaultMinListRowHeight, 10) // Adjust row height if necessary


                 //MARK: - Save Button Area
                VStack {
                    Button {
                        if viewModel.savePlan() {
                             onSave?() // Call the callback
                             presentationMode.wrappedValue.dismiss() // Dismiss view on success
                        } else {
                            // Optionally show an error alert to the user
                            print("Failed to save plan")
                        }
                    } label: {
                        Text("Save Plan")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(accentColor)
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.planTitle.isEmpty || viewModel.dayEntries.isEmpty) // Disable if title or days are empty
                    .opacity((viewModel.planTitle.isEmpty || viewModel.dayEntries.isEmpty) ? 0.6 : 1.0)
                }
                .padding()
                .background(backgroundColor) // Match background
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle("Create Training Plan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() }.foregroundColor(accentColor), // Changed back button to Cancel
                 trailing: Text("Step 2/2").font(.caption).foregroundColor(secondaryTextColor) // Use Text instead of Button
            )
            .preferredColorScheme(.dark)
        }
         .navigationViewStyle(.stack) // Ensures consistent presentation if pushed
    }
}






struct CreatePlanView_Previews: PreviewProvider {
    static var previews: some View {
         CreatePlanView(onSave: { print("Preview Save Tapped") })
            .preferredColorScheme(.dark)
    }
}
