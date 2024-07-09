import Foundation
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var date: Date
    var note: String
    var mediaURL: String
}

