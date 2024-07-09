import Foundation
import FirebaseFirestoreSwift

struct Child: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var gender: String
    var dateOfBirth: Date
    var userId: String
}

