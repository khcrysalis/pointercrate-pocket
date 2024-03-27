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
    static var name: String?
    static var nameContains: String?
    static var requirement: Int?
    static var verifierID: Int?
    static var publisherID: Int?
    static var verifierName: String?
    static var publisherName: String?
    static var limit: Int = 75
    static var after: Int?
    static var before: Int?
    
    static func reset() {
        selectedList = 0
        name = nil
        nameContains = nil
        requirement = nil
        verifierID = nil
        publisherID = nil
        verifierName = nil
        publisherName = nil
        limit = 75
        after = nil
        before = nil
    }
}

enum ListOption: Int, CaseIterable {
    case main = 0
    case extended = 1
    case legacy = 2
    
    var title: String {
        switch self {
        case .main: return "Main"
        case .extended: return "Extended"
        case .legacy: return "Legacy"
        }
    }
    
    func updateFilter() {
        switch self {
        case .extended:
            Filter.after = 75
        case .legacy:
            Filter.after = 150
        default:
            Filter.after = nil
        }
        Filter.selectedList = self.rawValue
    }
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
                Section {
                    ForEach(ListOption.allCases, id: \.self) { option in
                        let isSelected = Binding<Bool>(
                            get: { self.selectedOption == option.rawValue },
                            set: { newValue in
                                if newValue {
                                    self.selectedOption = option.rawValue
                                } else {
                                    self.selectedOption = ListOption.main.rawValue
                                }
                            }
                        )
                        RadioButton(title: option.title, isSelected: isSelected)
                    }
                } header: {
                    Text("Lists")
                        .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .listStyle(SidebarListStyle())
            .toolbar {
                createToolbar()
            }
        }
    }
    
    func updateViews() {
        presentationMode.wrappedValue.dismiss()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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
                    .animation(.linear(duration: 0.1), value: isSelected.wrappedValue)
                Text(title)
                    .foregroundColor(isSelected.wrappedValue ? .accentColor : .primary)
            }
        }
    }
}




extension ListFilterView {
    private func createToolbar() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            FilterButton(action: {
                Filter.reset()
                updateViews()
            }, foregroundStyle: Color(UIColor.tintColor), backgroundColor: Color(UIColor.secondarySystemGroupedBackground), buttonText: "Reset")
            
            FilterButton(action: {
                 if let selectedOption = selectedOption,
                    let listOption = ListOption(rawValue: selectedOption) {
                     listOption.updateFilter()
                 }
                 updateViews()
             }, foregroundStyle: .white, backgroundColor: .accentColor, buttonText: "Filter")
        }
    }
}

struct FilterButton: View {
    let action: () -> Void
    let foregroundStyle: Color
    let backgroundColor: Color
    let buttonText: String

    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .font(.subheadline)
                .bold()
                .textCase(.uppercase)
                .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .foregroundStyle(foregroundStyle)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
    }
}

