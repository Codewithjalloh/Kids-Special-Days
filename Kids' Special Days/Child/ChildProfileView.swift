import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChildProfileView: View {
    @Binding var isLoggedIn: Bool
    var child: Child
    @State private var events: [Event] = []

    var body: some View {
        VStack {
            Text("Profile for \(child.name)")
                .font(.largeTitle)
                .padding()

            NavigationLink(destination: CreateEventView(childId: child.id!)) {
                Text("Add New Event")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding()

            NavigationLink(destination: EditChildView(child: child, children: .constant([]))) {
                Text("Edit Child")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(5)
            }
            .padding()

            List(events) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.note)
                            .font(.headline)
                        Text("Date: \(event.date, formatter: dateFormatter)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            fetchEvents()
        }
    }

    func fetchEvents() {
        let db = Firestore.firestore()
        db.collection("children").document(child.id!).collection("events").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }

            events = snapshot?.documents.compactMap { document in
                try? document.data(as: Event.self)
            } ?? []
        }
    }
}

struct ChildProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let child = Child(id: "exampleChildId", name: "John Doe", gender: "Male", dateOfBirth: Date(), userId: "exampleUserId")
        ChildProfileView(isLoggedIn: .constant(true), child: child)
    }
}

