//
//  ListFilterController.swift
//  pointercrate
//
//  Created by samara on 3/24/24.
//

import Foundation
import SwiftUI

struct Filter {
    static var selectedList: Int = 0
}

struct ListFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedOption: Int?

    init() {
        _selectedOption = State(initialValue: Filter.selectedList)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Lists") {
                    RadioButton(title: "Main", isSelected: Binding(get: {
                        self.selectedOption == 0
                    }, set: { newValue in
                        if newValue {
                            self.selectedOption = 0
                        } else {
                            self.selectedOption = nil
                        }
                    }))
                    RadioButton(title: "Extended", isSelected: Binding(get: {
                        self.selectedOption == 1
                    }, set: { newValue in
                        if newValue {
                            self.selectedOption = 1
                        } else {
                            self.selectedOption = nil
                        }
                    }))
                    RadioButton(title: "Legacy", isSelected: Binding(get: {
                        self.selectedOption == 2
                    }, set: { newValue in
                        if newValue {
                            self.selectedOption = 2
                        } else {
                            self.selectedOption = nil
                        }
                    }))
                }
            }
            .padding(.top, 20)
            .navigationBarHidden(true)
            .listStyle(SidebarListStyle())
            .toolbar {
                createToolbar()
            }
        }
    }
}

struct RadioButton: View {
    var title: String
    var isSelected: Binding<Bool>

    var body: some View {
        Button(action: {
            isSelected.wrappedValue = true
        }) {
            HStack(spacing: 15) {
                Image(systemName: isSelected.wrappedValue ? "circle.inset.filled" : "circle")
                    .font(Font.system(size: 20))
                    .foregroundColor(isSelected.wrappedValue ? .accentColor : Color(UIColor.quaternaryLabel))
                Text(title)
                    .foregroundColor(isSelected.wrappedValue ? .accentColor : .primary)
            }
        }
        .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
        .animation(.linear(duration: 0.1), value: isSelected.wrappedValue)
    }
}




extension ListFilterView {
    private func createToolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    Filter.selectedList = 0
                }) {
                    Text("Reset")
                        .font(.subheadline)
                        .bold()
                        .textCase(.uppercase)
                        .foregroundStyle(Color.accentColor)
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .foregroundStyle(Color(UIColor.label))
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    if let selectedOption = selectedOption {
                        Filter.selectedList = selectedOption
                    }
                    presentationMode.wrappedValue.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }) {
                    Text("Filter")
                        .font(.subheadline)
                        .bold()
                        .textCase(.uppercase)
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .foregroundStyle(.white)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                }
            }
        }
    }
}
