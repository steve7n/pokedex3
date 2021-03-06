//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Steven Sosa on 4/6/17.
//  Copyright © 2017 SosaDesign. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            return ""
        } else {
            return _nextEvolutionLevel
        }
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil{
            return ""
        } else{
            return _nextEvolutionId
        }
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil{
            return ""
        } else {
            return _nextEvolutionName
        }
    }
    
    var description: String{
        if _description == nil {
            return ""
        } else {
            return _description
        }
    }
    
    var type: String {
        if _type == nil {
            return ""
        } else {
            return _type
        }
    }
    
    var defense: String{
        if _defense == nil{
            return ""
        } else {
            return _defense
        }
    }
    
    var height: String {
        if _height == nil {
            return ""
        } else {
            return _height
        }
    }
    
    var weight: String {
        if _weight == nil {
            return ""
        } else {
            return _weight
        }
    }
    
    var attack: String {
        if _attack == nil {
            return ""
        } else {
            return _attack
        }
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            return ""
        } else {
            return _nextEvolutionTxt
        }
    }
    
    
    
    
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)/"
        
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, Any> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Double {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Double {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    
//                    if let name = types[0]["name"]{
//                        self._type = name.capitalized
//                    }
                    
                    self._type = ""
                    for x in 0..<types.count {
                        if let name = types[x]["name"]{
                            self._type! += "/\(name.capitalized)"
                        }
                    }
                    
                    
                    
                } else {
                    
                    self._type = ""
                    
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"]{
                        
                        Alamofire.request("\(URL_BASE)\(url)").responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, Any>{
                                if let description =  descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    
                                }
                                
                            }
                            
                            
                            completed()
                        })
                        
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                self._nextEvolutionId = newString.replacingOccurrences(of: "/", with: "")
                                
                            }
                            
                            if let lvlExists = evolutions[0]["level"] {
                                if let lvl = lvlExists as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                                
                            } else {
                                self._nextEvolutionLevel = ""
                            }
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                print(self.nextEvolutionLevel)
                print(self.nextEvolutionName)
                print(self.nextEvolutionId)
                
                
            }
            
            completed()

            
        }
        
        
        
    }
    
    
    
    
}
