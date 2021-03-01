//
//  Order.swift
//  CupcakeCorner
//
//  Created by Scott Obara on 3/2/21.
//

import Foundation

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    @Published var type = 0
    @Published var quantity = 3

    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        let rangeName = NSRange(location: 0, length: name.utf16.count)
        let regexName = try! NSRegularExpression(pattern: "[a-zA-Z]+")
        let rangeStreetAddress = NSRange(location: 0, length: streetAddress.utf16.count)
        let regexStreetAddress = try! NSRegularExpression(pattern: "[0-9]+.*[a-zA-Z]+")
        let rangeCity = NSRange(location: 0, length: city.utf16.count)
        let regexCity = try! NSRegularExpression(pattern: "[a-zA-Z]+")
        let rangeZip = NSRange(location: 0, length: zip.utf16.count)
        let regexZip = try! NSRegularExpression(pattern: "[0-9]+")
        
        if regexName.firstMatch(in: name, options: [], range: rangeName) == nil ||
            regexStreetAddress.firstMatch(in: streetAddress, options: [], range: rangeStreetAddress) == nil ||
            regexCity.firstMatch(in: city, options: [], range: rangeCity) == nil ||
            regexZip.firstMatch(in: zip, options: [], range: rangeZip) == nil {
            return false
        }

        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)

        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)

        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)

        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
}
