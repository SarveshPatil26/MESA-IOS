import SwiftUI

struct FileUploadView: View {
    let subject: String
    @State private var selectedImage: UIImage?
    @State private var selectedPDF: URL?
    @State private var showImagePicker = false
    @State private var showDocumentPicker = false
    @State private var uploadedFileURL: String?

    var body: some View {
        VStack {
            Text("Upload file for \(subject)")
                .font(.headline)
            
            Button("Select Image") {
                showImagePicker = true
            }
            .padding()
            
            Button("Select PDF") {
                showDocumentPicker = true
            }
            .padding()

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                Button("Upload Image") {
                    uploadImageToCloudinary(image: image)
                }
                .padding()
            }

            if let pdf = selectedPDF {
                Text("Selected PDF: \(pdf.lastPathComponent)")

                Button("Upload PDF") {
                    uploadPDFToCloudinary(pdfURL: pdf)
                }
                .padding()
            }

            if let url = uploadedFileURL {
                Text("Uploaded File URL:")
                Text(url)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(document: $selectedPDF)
        }
    }

    func uploadImageToCloudinary(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let url = URL(string: "https://api.cloudinary.com/v1_1/dbbdyyluu/image/upload")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("sarvesh\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let url = json["secure_url"] as? String {
                DispatchQueue.main.async {
                    self.uploadedFileURL = url
                }
            }
        }.resume()
    }

    func uploadPDFToCloudinary(pdfURL: URL) {
        let url = URL(string: "https://api.cloudinary.com/v1_1/dbbdyyluu/raw/upload")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"document.pdf\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)

        if let pdfData = try? Data(contentsOf: pdfURL) {
            body.append(pdfData)
        }

        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("sarvesh\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let url = json["secure_url"] as? String {
                DispatchQueue.main.async {
                    self.uploadedFileURL = url
                }
            }
        }.resume()
    }
}
















/*func uploadImageToCloudinary(image: UIImage) {
 guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
 let url = URL(string: "https://api.cloudinary.com/v1_1/dbbdyyluu/image/upload")!

 var request = URLRequest(url: url)
 request.httpMethod = "POST"

 let boundary = "Boundary-\(UUID().uuidString)"
 request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

 var body = Data()
 body.append("--\(boundary)\r\n".data(using: .utf8)!)
 body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
 body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
 body.append(imageData)
 body.append("\r\n".data(using: .utf8)!)
 body.append("--\(boundary)\r\n".data(using: .utf8)!)
 body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
 body.append("sarvesh\r\n".data(using: .utf8)!)
 body.append("--\(boundary)--\r\n".data(using: .utf8)!)

 request.httpBody = body

 URLSession.shared.dataTask(with: request) { data, response, error in
     guard let data = data, error == nil else { return }
     if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
        let url = json["secure_url"] as? String {
         DispatchQueue.main.async {
             self.uploadedFileURL = url
             self.sendToMongoDB(subject: self.subject, fileURL: url) // Send to MongoDB
         }
     }
 }.resume()
}

func sendToMongoDB(subject: String, fileURL: String) {
 let serverURL = "http://YOUR_SERVER_IP:5000/upload"
 
 guard let url = URL(string: serverURL) else { return }
 var request = URLRequest(url: url)
 request.httpMethod = "POST"
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")

 let body: [String: Any] = ["subject": subject, "fileURL": fileURL]

 request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

 URLSession.shared.dataTask(with: request) { data, response, error in
     guard let data = data, error == nil else { return }
     if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
         print("MongoDB Response: \(responseJSON)")
     }
 }.resume()
}
*/
