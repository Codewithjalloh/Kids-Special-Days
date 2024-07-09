import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EditChildView: View {
    @State private var name: String
    @State private var gender: String
    @State private var dateOfBirth: Date
    var child: Child
    @Binding var children: [Child]

    init(child: Child, children: Binding<[Child]>) {
        self.child = child
        self._name = State(initialValue: child.name)
        self._gender = State(initialValue: child.gender)
        self._dateOfBirth = State(initialValue: child.dateOfBirth)
        self._children = children
    }

    var body: some View {
        VStack {
            TextField("Child's Name", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            Picker("Gender", selection: $gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                .padding()

            Button(action: saveChanges) {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding()
        }
        .padding()
    }

    func saveChanges() {
        guard let childId = child.id else {
            print("Child ID is nil")
            return
        }

        let db = Firestore.firestore()
        let updatedChild = Child(id: childId, name: name, gender: gender, dateOfBirth: dateOfBirth, userId: child.userId)

        do {
            try db.collection("children").document(childId).setData(from: updatedChild) { error in
                if let error = error {
                    print("Error updating child: \(error)")
                } else {
                    if let index = children.firstIndex(where: { $0.id == childId }) {
                        children[index] = updatedChild
                    }
                }
            }
        } catch let error {
            print("Error updating child: \(error)")
        }
    }
}

struct EditChildView_Previews: PreviewProvider {
    static var previews: some View {
        EditChildView(
            child: Child(id: "1", name: "John Doe", gender: "Male", dateOfBirth: Date(), userId: "exampleUserId"),
            children: .constant([
                Child(id: "1", name: "John Doe", gender: "Male", dateOfBirth: Date(), userId: "exampleUserId"),
                Child(id: "2", name: "Jane Doe", gender: "Female", dateOfBirth: Date(), userId: "exampleUserId")
            ])
        )
    }
}

