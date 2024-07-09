import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChildrenListView: View {
    @Binding var children: [Child]
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                NavigationLink(destination: ParentProfileView()) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                }
            }

            List {
                ForEach(children) { child in
                    NavigationLink(destination: ChildProfileView(isLoggedIn: $isLoggedIn, child: child)) {
                        Text(child.name)
                    }
                }
                .onDelete(perform: deleteChild)
                .onMove(perform: moveChild)
            }

            NavigationLink(destination: ChildRegistrationView(children: $children)) {
                Text("Register New Child")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding()

            Button(action: logoutUser) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(5)
            }
            .padding()
        }
        .navigationTitle("My Children")
        .toolbar {
            EditButton()
        }
    }

    func deleteChild(at offsets: IndexSet) {
        let db = Firestore.firestore()
        for index in offsets {
            let child = children[index]
            db.collection("children").document(child.id!).delete { error in
                if let error = error {
                    print("Error deleting child: \(error)")
                } else {
                    children.remove(at: index)
                }
            }
        }
    }

    func moveChild(from source: IndexSet, to destination: Int) {
        children.move(fromOffsets: source, toOffset: destination)
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ChildrenListView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenListView(
            children: .constant([
                Child(id: "1", name: "John Doe", gender: "Male", dateOfBirth: Date(), userId: "exampleUserId"),
                Child(id: "2", name: "Jane Doe", gender: "Female", dateOfBirth: Date(), userId: "exampleUserId")
            ]),
            isLoggedIn: .constant(true)
        )
    }
}

