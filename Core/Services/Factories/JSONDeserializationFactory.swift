import Alamofire
import TRON
import SwiftyJSON

open class JSONDeserializationFactory<T: JSONDecodable, U: JSONDecodable>: JSONDecodableParser<T, U>{
    public typealias SerializedError = U
    var subkey: String?
    
    public init(subkey: String? = nil) {
        self.subkey = subkey
        super.init(options: [])
    }
    
    open override var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Alamofire.Result<T> {
        return { [subkey] (request, response, data, error) in
            guard let data = data else { return .failure(DeserializationError.emptyResponseData) }
            do{
                if let subkey = subkey {
                    return .success(try T(json: JSON(data: data)[subkey]))
                } else {
                    return .success(try T(json: JSON(data: data)))
                }
            } catch { return .failure(error) }
        }
    }
}

private enum DeserializationError: Error {
    case emptyResponseData
}

open class VoidSerializationFactory<U: JSONDecodable>: ErrorHandlingDataResponseSerializerProtocol {
    public typealias SerializedError = U
    public init() {}
    
    public var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Alamofire.Result<Void> {
        return { (request, response, data, error) in
            return .success(())
        }
    }
    
    public var serializeError: (Alamofire.Result<()>?, URLRequest?, HTTPURLResponse?, Data?, Error?) -> APIError<U> {
        return errorDeserializer()
    }
}

open class AnonymousDeserializationFactory<T, U: JSONDecodable>: ErrorHandlingDataResponseSerializerProtocol {
    public typealias SerializedError = U
    private let factory: Func<JSON, T>
    
    public init(factory: @escaping Func<JSON, T>) {
        self.factory = factory
    }
    
    public var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Alamofire.Result<T> {
        return { [factory] (request, response, data, error) in
            guard let data = data else { return .failure(DeserializationError.emptyResponseData) }
            return .success(factory((try? JSON(data: data)) ?? JSON.null))
        }
    }
    
    public var serializeError: (Alamofire.Result<T>?, URLRequest?, HTTPURLResponse?, Data?, Error?) -> APIError<U> {
        return errorDeserializer()
    }
}

private func errorDeserializer<T, U: JSONDecodable>() -> ((Alamofire.Result<T>?, URLRequest?, HTTPURLResponse?, Data?, Error?) -> APIError<U>) {
    return { erroredResponse, request, response, data, error in
        let serializationError : Error? = erroredResponse?.error ?? error
        var error = APIError<U>(request: request, response: response, data: data, error: serializationError)
        let data = data ?? Data()
        let json = (try? JSON(data: data)) ?? JSON.null
        error.errorModel = try? U.init(json: json)
        return error
    }
}
