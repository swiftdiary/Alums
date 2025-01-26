//
//  CreateTask.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct CreateTask: View {
    @Environment(\.dismiss) private var dismiss
    @State private var observable = CreateTaskObservable()
    
    var body: some View {
        List {
            TextField("Name", text: $observable.name)
            TextField("Description", text: $observable.description)
            Picker("Worker", selection: $observable.worker_id) {
                ForEach(observable.workers, id: \.user_id) { worker in
                    Text("\(worker.first_name) \(worker.last_name)")
                        .tag(worker.user_id)
                }
            }
            Picker("Group", selection: $observable.group_id) {
                ForEach(observable.groups, id: \.group_id) { group in
                    Text(group.group_name)
                        .tag(group.group_id)
                }
            }
            DatePicker("Deadline Date", selection: $observable.deadline_date)
            Section("Region&District") {
                Picker("Region", selection: $observable.selectedRegion) {
                    ForEach(CurrentlyAvailableRegion.allCases) { region in
                        Text(region.title)
                            .tag(region)
                    }
                }
                Picker("District", selection: $observable.selectedDistrict) {
                    ForEach(observable.selectedRegion.regionDistricts) { district in
                        Text(district.title)
                            .tag(district)
                    }
                }
            }
            Section("Parcels") {
                ForEach(observable.parcelsData, id: \.parcel_id) { parcel in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(parcel.parcel_id)")
                                .font(.headline)
                            Text(parcel.owner_name)
                                .font(.caption)
                            Text("\(parcel.region), \(parcel.district)")
                                .font(.caption)
                            Text("Kontur: \(parcel.kontur_number)")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if observable.parcels.contains(parcel.parcel_id) {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Image(systemName: "circle")
                        }
                    }
                    .onTapGesture {
                        if observable.parcels.contains(parcel.parcel_id) {
                            observable.parcels.removeAll(where: {$0 == parcel.parcel_id})
                        } else {
                            observable.parcels.append(parcel.parcel_id)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding()
            Button("Create Task") {
                Task {
                    try? await observable.createTask()
                }
            }
        }
        .onChange(of: observable.selectedRegion, { _, _ in
            observable.selectedDistrict = observable.selectedRegion.regionDistricts.first ?? CurrentlyAvailableDistrict.chortoq
        })
        .onChange(of: observable.selectedDistrict, { _, _ in
            Task {
                try? await observable.getParcels()
            }
        })
        .onChange(of: observable.taskCreated, { oldValue, newValue in
            if newValue {
                dismiss()
            }
        })
        .task {
            try? await observable.getGroups()
            try? await observable.getWorkers()
            try? await observable.getParcels()
        }
    }
}

#Preview {
    CreateTask()
}
