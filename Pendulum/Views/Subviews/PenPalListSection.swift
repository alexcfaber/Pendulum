//
//  PenPalListSection.swift
//  Pendulum
//
//  Created by Ben Cardy on 05/11/2022.
//

import SwiftUI

struct PenPalListSection: View {
    
    // MARK: Parameters
    let type: EventType
    let penpals: [PenPal]
    
    // MARK: State
    @State private var currentPenPal: PenPal? = nil
    @State private var showDeleteAlert = false
    @State private var presentAddEventSheetForType: EventType? = nil
    
    func dateText(for penpal: PenPal) -> Text {
        if let date = penpal.lastEventDate {
            return Text("\(penpal.lastEventType.datePrefix) \(Calendar.current.verboseNumberOfDaysBetween(date, and: Date()))")
        } else {
            return Text("")
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: type.phraseIcon)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(8)
                    .background {
                            Circle()
                                .fill(type.color)
                    }
                Text(type.phrase)
                    .font(.headline)
                    .fullWidth()
            }
            ForEach(penpals) { penpal in
                NavigationLink(destination: PenPalView(penpal: penpal)) {
                    GroupBox {
                        VStack {
                            HStack {
                                if let image = penpal.displayImage {
                                    image
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(.gray)
                                        Text(penpal.initials)
                                            .font(.system(.headline, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 40, height: 40)
                                }
                                VStack {
                                    Text(penpal.name)
                                        .font(.headline)
                                        .fullWidth()
                                    if penpal.lastEventDate != nil {
                                        self.dateText(for: penpal)
                                            .font(.caption)
                                            .fullWidth()
                                    }
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    .contextMenu {
                        ForEach(EventType.actionableCases, id: \.self) { eventType in
                            Button(action: {
                                self.currentPenPal = penpal
                                self.presentAddEventSheetForType = eventType
                            }) {
                                Label(eventType.actionableText, systemImage: eventType.icon)
                            }
                        }
                        Divider()
                        Button(role: .destructive, action: {
                            self.currentPenPal = penpal
                            self.showDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .confirmationDialog("Are you sure?", isPresented: $showDeleteAlert, titleVisibility: .visible, presenting: currentPenPal) { penpal in
                        Button("Delete \(penpal.name)", role: .destructive) {
                            Task {
                                await penpal.delete()
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $presentAddEventSheetForType) { eventType in
            if let penpal = self.currentPenPal {
                AddEventSheet(penpal: penpal, event: nil, eventType: eventType) { newEvent, newEventType in
                    self.presentAddEventSheetForType = nil
                }
            }
        }
        .padding()
    }
}

struct PenPalListSection_Previews: PreviewProvider {
    static var previews: some View {
        PenPalListSection(type: .written, penpals: [
            PenPal(id: "1", name: "Ben Cardy", initials: "BC", image: nil, _lastEventType: EventType.written.rawValue, lastEventDate: Date(), notes: nil),
            PenPal(id: "2", name: "Alex Faber", initials: "AF", image: nil, _lastEventType: EventType.written.rawValue, lastEventDate: Date(), notes: nil),
            PenPal(id: "3", name: "Madi Van Houten", initials: "MV", image: nil, _lastEventType: EventType.written.rawValue, lastEventDate: Date(), notes: nil)
        ])
    }
}
