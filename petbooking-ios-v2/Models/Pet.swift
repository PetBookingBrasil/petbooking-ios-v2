//
//  Pet.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 20/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Pet: MTLModel, MTLJSONSerializing {
	
	dynamic var id = ""
	dynamic var type = ""
	dynamic var name = ""
	dynamic var breedName = ""
	dynamic var gender = ""
	dynamic var photoUrl = ""
	dynamic var photoMediumUrl = ""
	dynamic var photoThumbUrl = ""
	dynamic var breedId = ""
	dynamic var mood = ""
	dynamic var size = ""
	dynamic var coatSize = ""
	dynamic var birthday = ""
	dynamic var petDescription = ""
	

	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"type": "type",
			"name": "attributes.name",
			"breedName": "attributes.breed_name",
			"gender": "attributes.gender",
			"photoUrl": "attributes.photo.url",
			"photoMediumUrl": "attributes.photo.medium.url",
			"photoThumbUrl": "attributes.photo.thumb.url"
		]
	}
	
	
}

class PetList: MTLModel, MTLJSONSerializing {
	
	dynamic var pets = [Pet]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"pets": "data"
		]
	}

	static func petsJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Pet.self)
		
	}
}

enum PetTypeEnum:String {
	case dog = "dog"
	case cat = "cat"
}

enum PetGenderEnum:String {
	case male = "male"
	case female = "female"
}

enum PetSizeEnum:String {
	case small = "small"
	case medium = "medium"
	case big = "big"
	case giant = "giant"
}

enum PetCoatEnum:String {
	case short = "short_coat"
	case medium = "medium_coat"
	case long = "long_coat"
}

enum PetMoodEnum:String {
	case calm = "calm"
	case agitated = "agitated"
	case happy = "happy"
	case loving = "loving"
	case angry = "angry"
	case playful = "playful"
	case needy = "needy"
	case affectionate = "affectionate"
	case brave = "brave"
}

