import SwiftUI

// MARK: - Data Model
struct Activity: Identifiable {
    let id = UUID()
    var hobbyName: String
    var venue: String
    var date: Date
    var time: String
}

// MARK: - Main View
struct ContentView: View {
    @State private var activities: [Activity] = []
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Display activities
                List(activities) { activity in
                    VStack(alignment: .leading) {
                        Text(activity.hobbyName)
                            .font(.headline)
                        Text("Venue: \(activity.venue)")
                        Text("Date: \(formattedDate(activity.date))")
                        Text("Time: \(activity.time)")
                    }
                }
                .navigationTitle("Hobby Activities")
                .navigationBarItems(trailing: Button(action: {
                    showingAddActivity.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddActivity) {
                    AddActivityView(activities: $activities)
                }
            }
        }
    }
    
    // Helper function to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

// MARK: - Add Activity View
struct AddActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var activities: [Activity]
    
    @State private var hobbyName = ""
    @State private var venue = ""
    @State private var date = Date()
    @State private var time = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hobby Information")) {
                    TextField("Hobby Name", text: $hobbyName)
                    TextField("Venue", text: $venue)
                }
                
                Section(header: Text("Date and Time")) {
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                    TextField("Time (e.g., 3:00 PM)", text: $time)
                }
                
                Button(action: {
                    let newActivity = Activity(hobbyName: hobbyName, venue: venue, date: date, time: time)
                    activities.append(newActivity)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Activity")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
            .navigationBarTitle("Add New Activity", displayMode: .inline)
        }
    }
}

// MARK: - App Entry Point
@main
struct HobbyActivityApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
