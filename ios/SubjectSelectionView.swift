import SwiftUI

struct SubjectSelectionView: View {
    let subjects = ["Math", "Science", "History", "Computer Science"]
    @State private var selectedSubject: String? = nil

    var body: some View {
        VStack {
            Text("Select a Subject")
                .font(.headline)
            List(subjects, id: \.self) { subject in
                Button(subject) {
                    selectedSubject = subject
                }
            }
            if let subject = selectedSubject {
                FileUploadView(subject: subject)
            }
        }
    }
}
