import XCTest
@testable import Firestore

final class DocumentTests: XCTestCase {

    override class func setUp() {
        let serviceAccount = try! loadServiceAccount(from: "ServiceAccount")
        FirebaseApp.initialize(serviceAccount: serviceAccount)
    }

    override func setUp() async throws {
        let collection = Firestore.firestore().collection("test")

        try await collection.document("doc")
            .setData([
                "number": 0,
                "string": "string",
                "bool": true,
                "array": ["0", "1"],
                "map": ["key": "value"],
                "date": Date(timeIntervalSince1970: 0),
                "timestamp": Timestamp(seconds: 0, nanos: 0),
                "data": "data".data(using: .utf8)!,
                "geoPoint": GeoPoint(latitude: 0, longitude: 0)
            ])

        try await collection.document("serverTimestamp")
            .setData([
                "serverTimestamp": FieldValue.serverTimestamp,
            ])
    }

    override func tearDown() async throws {
        let firestore = Firestore.firestore()
        let collection = firestore.collection("test")
        try await collection.document("doc").delete()
        try await collection.document("serverTimestamp").delete()
    }

    class func loadServiceAccount(from jsonFile: String) throws -> ServiceAccount {
        guard let path = Bundle.main.path(forResource: jsonFile, ofType: "json")  else {
            throw NSError(domain: "FileNotFoundError", code: 404, userInfo: [NSLocalizedDescriptionKey: "JSON file not found"])
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let serviceAccount = try decoder.decode(ServiceAccount.self, from: data)
            return serviceAccount
        } catch {
            throw NSError(domain: "JSONParsingError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON file: \(error)"])
        }
    }

    func testDocumentData() async throws {
        let snapshot = try await Firestore
            .firestore()
            .collection("test")
            .document("doc")
            .getDocument()
        let data = snapshot.data()
        XCTAssertEqual(data["number"] as! Int, 0)
        XCTAssertEqual(data["string"] as! String, "string")
        XCTAssertEqual(data["bool"] as! Bool, true)
        XCTAssertEqual(data["array"] as! [String], ["0", "1"])
        XCTAssertEqual(data["map"] as! [String: String], ["key": "value"])
        XCTAssertEqual(data["date"] as! Timestamp, Timestamp(seconds: 0, nanos: 0))
        XCTAssertEqual(data["timestamp"] as! Timestamp, Timestamp(seconds: 0, nanos: 0))
        XCTAssertEqual(data["geoPoint"] as! GeoPoint, GeoPoint(latitude: 0, longitude: 0))
    }

    func testSeriverTimestamp() async throws {
        let snapshot = try await Firestore
            .firestore()
            .collection("test")
            .document("serverTimestamp")
            .getDocument()
        let data = snapshot.data()
        XCTAssertTrue(data["serverTimestamp"] is Timestamp)
    }
}
