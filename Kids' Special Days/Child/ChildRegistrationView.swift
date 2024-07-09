import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChildRegistrationView: View {
    @State private var name = ""
    @State private var gender = "Male"
    @State private var dateOfBirth = Date()
    @Binding var children: [Child]

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

            Button(action: registerChild) {
                Text("Register Child")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding()
        }
        .padding()
    }

    func registerChild() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }

        let db = Firestore.firestore()
        let child = Child(id: UUID().uuidString, name: name, gender: gender, dateOfBirth: dateOfBirth, userId: userId)

        do {
            try db.collection("children").document(child.id!).setData(from: child) { error in
                if let error = error {
                    print("Error writing child to Firestore: \(error)")
                } else {
                    children.append(child)
                }
            }
        } catch let error {
            print("Error writing child to Firestore: \(error)")
        }
    }
}

struct ChildRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ChildRegistrationView(children: .constant([]))
    }
}

