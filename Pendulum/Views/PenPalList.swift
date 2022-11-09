//
//  PenPalList.swift
//  Pendulum
//
//  Created by Ben Cardy on 04/11/2022.
//

import SwiftUI
import Contacts
import GRDB

struct PenPalList: View {
    
    // MARK: State
    @StateObject private var penPalListController = PenPalListController()
    @State private var contactsAccessStatus: CNAuthorizationStatus = .notDetermined
    @State private var presentingAddPenPalSheet: Bool = false
    @State private var iconWidth: CGFloat = .zero
    
    var body: some View {
        NavigationStack {
            Group {
                if contactsAccessStatus == .notDetermined || (contactsAccessStatus != .authorized && penPalListController.penpals.isEmpty) {
                    /// Show contacts access required message if it hasn't been requested,
                    /// or it has been denied and the user hasn't added any pen pals yet
                    ContactsAccessRequiredView(contactsAccessStatus: $contactsAccessStatus)
                } else if penPalListController.penpals.isEmpty {
                    VStack {
                        Spacer()
                        if let image = UIImage(named: "undraw_just_saying_re_kw9c") {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 200)
                                .padding(.bottom)
                        }
                        Button(action: {
                            self.presentingAddPenPalSheet = true
                        }) {
                            Text("Add your first Pen Pal to get started!")
                        }
                        Spacer()
                    }
                } else {
                    ScrollView {
                        ForEach(EventType.allCases, id: \.self) { eventType in
                            if let penpals = penPalListController.groupedPenPals[eventType] {
                                PenPalListSection(type: eventType, penpals: penpals, iconWidth: $iconWidth)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Pen Pals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentingAddPenPalSheet = true
                    }) {
                        Label("Add Pen Pal", systemImage: "plus.circle")
                    }
                    .disabled(contactsAccessStatus != .authorized)
                }
            }
            .sheet(isPresented: $presentingAddPenPalSheet) {
                AddPenPalSheet(existingPenPals: penPalListController.penpals)
            }
        }
        .onPreferenceChange(PenPalListIconWidthPreferenceKey.self) { value in
            self.iconWidth = value
        }
        .onAppear {
            self.contactsAccessStatus = CNContactStore.authorizationStatus(for: .contacts)
        }
    }
}

struct PenPalListIconWidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct PenPalList_Previews: PreviewProvider {
    static var previews: some View {
        PenPalList()
    }
}
