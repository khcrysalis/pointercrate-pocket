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
  static var limit: Int?
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
    limit = nil
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
      Button(action: {
        Filter.reset()
        updateViews()
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
      
      Button(action: {
        if let selectedOption = selectedOption,
           let listOption = ListOption(rawValue: selectedOption) {
          listOption.updateFilter()
        }
        updateViews()
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

