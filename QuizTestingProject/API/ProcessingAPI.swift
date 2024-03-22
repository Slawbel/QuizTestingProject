import Foundation

class ProcessingAPI {
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        // URL of the API endpoint
        let urlString = "https://api.npoint.io/d6bd0efc05639084eb17"
        
        // Create URL object
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                completion(.failure(error))
            return
        }
            
        // Create URLSession
        let session = URLSession(configuration: .default)
        
        // Create URLSessionDataTask
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
                
            // Check if response is HTTPURLResponse and status code is 200 (OK)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let error = NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
                    completion(.failure(error))
                return
            }
                
            // Check if data is available
            guard let data = data else {
                let error = NSError(domain: "NoData", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(error))
                return
            }
                
            // Call completion handler with success and data
            completion(.success(data))
        }
            
        // Start the task
        task.resume()
    }

}
