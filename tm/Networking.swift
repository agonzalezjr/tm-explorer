
import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case put = "PUT"
  case post = "POST"
  case delete = "DELETE"
  case head = "HEAD"
  case options = "OPTIONS"
  case trace = "TRACE"
  case connect = "CONNECT"
}

struct HTTPHeader {
  let field: String
  let value: String
}

class APIRequest {
  let method: HTTPMethod
  let path: String
  var queryItems: [URLQueryItem] = []
  var headers: [HTTPHeader]?
  var body: Data?

  init(method: HTTPMethod, path: String) {
    self.method = method
    self.path = path
  }

  init<Body: Encodable>(method: HTTPMethod, path: String, body: Body) throws {
    self.method = method
    self.path = path
    self.body = try JSONEncoder().encode(body)
  }
}

struct APIResponse<Body> {
  let statusCode: Int
  let body: Body
}

extension APIResponse where Body == Data? {
  func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
    guard let data = body else {
      throw APIError.decodingFailure
    }
    do {
      let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
    } catch let error {
      print(error)
    }
    let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
    return APIResponse<BodyType>(statusCode: self.statusCode,
                                 body: decodedJSON)
  }
}

enum APIError: Error {
  case invalidURL
  case requestFailed
  case decodingFailure
}

enum APIResult<Body> {
  case success(APIResponse<Body>)
  case failure(APIError)
}

struct APIClient {

  typealias APIClientCompletion = (APIResult<Data?>) -> Void

  private let session = URLSession.shared
  private let baseURL = URL(string: "https://developer.uspto.gov/ibd-api/v1/trademark")!

  func perform(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {

    var urlComponents = URLComponents()
    urlComponents.scheme = baseURL.scheme
    urlComponents.host = baseURL.host
    urlComponents.path = baseURL.path
    urlComponents.queryItems = request.queryItems

    guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
      completion(.failure(.invalidURL)); return
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body

    request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }

    print("urlRequest = \(urlRequest.debugDescription)")

    let task = session.dataTask(with: urlRequest) { (data, response, error) in
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(.requestFailed)); return
      }
      completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
    }
    task.resume()
  }
}
