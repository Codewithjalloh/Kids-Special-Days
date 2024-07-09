import SwiftUI

struct EventDetailView: View {
    var event: Event

    var body: some View {
        VStack {
            Text(event.note)
                .font(.largeTitle)
                .padding()

            Text("Date: \(event.date, formatter: dateFormatter)")
                .font(.subheadline)
                .padding()

            if let url = URL(string: event.mediaURL) {
                AsyncImage(url: url)
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event(id: "exampleEventId", date: Date(), note: "First Steps", mediaURL: "https://example.com/image.jpg")
        EventDetailView(event: event)
    }
}

