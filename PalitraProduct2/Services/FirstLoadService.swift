import Foundation
import CoreData
import AEXML


final class FirstLoadData {
    
    static func readXml() {
        guard
            let xmlPath = Bundle.main.path(forResource: "import_files/import0_1", ofType: "xml"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath)),
            let xmlPath2 = Bundle.main.path(forResource: "import_files/offers0_1", ofType: "xml"),
            let data2 = try? Data(contentsOf: URL(fileURLWithPath: xmlPath2)),
            let clientPath = Bundle.main.path(forResource: "import_files/Clients", ofType: "xml"),
            let clientData = try? Data(contentsOf: URL(fileURLWithPath: clientPath))
                
        else {
            print("resource not found!")
            return
        }
        
        var options = AEXMLOptions()
        options.parserSettings.shouldProcessNamespaces = false
        options.parserSettings.shouldReportNamespacePrefixes = false
        options.parserSettings.shouldResolveExternalEntities = false
        
        do {
            
//MARK: - save group
            let xmlProduct = try AEXMLDocument(xml: data, options: options)
            let groupXml = xmlProduct.root["Классификатор"]["Группы"]["Группа"]
            requestGroupe(request: groupXml, groupId: "1a")
            
            func requestGroupe(request: AEXMLElement, groupId: String? ) {
                
                    if let array = request.all {
                        for property in array {
                            if property["Группы"].value != nil {
                                CoreDataService.mainContext.perform {
                                    let group = Group(context: CoreDataService.mainContext)
                                    group.groupId = property["Ид"].value ?? ""
                                    group.name = property["Наименование"].value ?? ""
                                    group.parentId = groupId
                  
                                    CoreDataService.saveContext()
                                }
                                
                                requestGroupe(request: property["Группы"]["Группа"], groupId: (property["Ид"].value ?? ""))
                            } else {
                                CoreDataService.mainContext.perform {
                                    let group = Group(context: CoreDataService.mainContext)
                                    group.groupId = property["Ид"].value ?? ""
                                    group.name = property["Наименование"].value ?? ""
                                    group.parentId = groupId
                          
                                    CoreDataService.saveContext()
                                }
                            }
                        }
                    }
                }
            
//MARK: - save products
            let xmlInfo = try AEXMLDocument(xml: data2, options: options)
            if let productXml = xmlProduct.root["Каталог"]["Товары"]["Товар"].all {
                for element in productXml {
                    var quantity: Int16 = 0
                    if let productInfo = xmlInfo.root["ПакетПредложений"]["Предложения"]["Предложение"].all {
                        for info in productInfo {
                            if element["Ид"].value == info["Ид"].value {
                                quantity = Int16(info["Склад"].attributes["КоличествоНаСкладе"] ?? "") ?? 0
                            }
                        }
                    }
                    CoreDataService.mainContext.perform {
                        let product = Product(context: CoreDataService.mainContext)
                    
                        product.selfId = element["Ид"].value ?? ""
                        product.name = element["Наименование"].value ?? ""
                        product.image = element["Картинка"].value ?? ""
                        product.barcode = element["Штрихкод"].value ?? ""
                        product.vendorcode = element["Артикул"].value ?? ""
                        product.unit = element["БазоваяЕдиница"].attributes["Код"] ?? ""
                        product.groupId = element["Группы"]["Ид"].value ?? ""
                        product.manufacturerId = element["Изготовитель"]["Ид"].value ?? ""
                        product.manufacturer = element["Изготовитель"]["Наименование"].value ?? ""
                        product.fee = element["СтавкиНалогов"]["СтавкаНалога"]["Наименование"].value ?? ""
                        product.percentFee = Int16(element["СтавкиНалогов"]["СтавкаНалога"]["Ставка"].value ?? "") ?? 0
                        product.quantity = quantity
                        
                        if let group = Group.getById(id: product.groupId ?? "") {
                            product.group = group
                            
                        }
                       
                        CoreDataService.saveContext()
                    }
                }
            }
            
//MARK: - save prices
            if let productInfo = xmlInfo.root["ПакетПредложений"]["Предложения"]["Предложение"].all {
                for info in productInfo {
                    if let priceInfo = info["Цены"]["Цена"].all {
                        for element in priceInfo {
                            var typePriceName: String = ""
                            if let elementPrice = xmlInfo.root["ПакетПредложений"]["ТипыЦен"]["ТипЦены"].all {
                                elementPrice.forEach({
                                    if element["ИдТипаЦены"].value == $0["Ид"].value {
                                        typePriceName = $0["Наименование"].value ?? ""
                                    }
                                })
                            }
                            CoreDataService.mainContext.perform {
                                let price = Price(context: CoreDataService.mainContext)
                                
                                price.selfId = element["ИдТипаЦены"].value ?? ""
                                price.price = Double(element["ЦенаЗаЕдиницу"].value ?? "") ?? 0.0
                                price.productId = info["Ид"].value ?? ""
                                price.name = typePriceName
                                price.unit = info["БазоваяЕдиница"].attributes["Код"] ?? "error"
                                
                                if let product = Product.getById(id: price.productId ?? "") {
                                    price.product = product
                                }
                                
                                CoreDataService.saveContext()
                            }
                        }
                    }
                }
            }
            
//MARK: - Save clients

            let readXmlClients = try AEXMLDocument(xml: clientData, options: options)
            if let counterInfo = readXmlClients.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Контрагенты"].all {

                for counter in counterInfo {
                    if let partnerInfo = readXmlClients.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
                        for partner in partnerInfo {
                            if counter["Партнер"].value == partner["Ref"].value {
                                CoreDataService.mainContext.perform {
                                    let client = Client(context: CoreDataService.mainContext)
                                    client.clientId = partner["Ref"].value ?? ""
                                    client.clientName = partner["Description"].value ?? ""
                                    client.clientInfo = partner["ДополнительнаяИнформация"].value ?? ""
                                    client.comment = partner["Комментарий"].value ?? ""
                                    client.counterInfo = counter["ДополнительнаяИнформация"].value ?? ""
                                    client.counterpartyFullName = counter["НаименованиеПолное"].value ?? ""
                                    client.counterpartyId = counter["Ref"].value ?? ""
                                    client.deletionMark = Bool(partner["DeletionMark"].value ?? "") ?? false
                                    client.firstClientId = counter["ГоловнойКонтрагент"].value ?? ""
                                    client.clientFullName = partner["НаименованиеПолное"].value ?? ""
                                    client.managerId = partner["ОсновнойМенеджер"].value ?? ""
                                    client.registrationDate = partner["ДатаРегистрации"].value ?? ""
                                    client.unp = counter["ИНН"].value ?? ""
                                    client.clientCodeInServer = partner["Code"].value ?? ""
                                    print("Save")

                                    CoreDataService.saveContext()
                                }
                            } else {
                                print("no match")
                            }
                        }
                    }
                }
                
            }
            
//MARK: - Save partner
            if let partnerInfo = readXmlClients.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
                for part in partnerInfo {
                    CoreDataService.mainContext.perform {
                        let partner = Partner(context: CoreDataService.mainContext)
                        if let client = Client.getById(id: part["Parent"].value ?? "") {
                            partner.client = client
                            partner.parentId = part["Parent"].value ?? ""
                            partner.deletionMark = Bool(part["DeletionMark"].value ?? "") ?? false
                            partner.selfId = part["Ref"].value ?? ""
                            partner.name = part["НаименованиеПолное"].value ?? ""
                            partner.managerId = part["ОсновнойМенеджер"].value ?? ""
                            partner.registrationDate = part["ДатаРегистрации"].value ?? ""
                            partner.codeInServer = part["Code"].value ?? ""
                            partner.comment = part["Комментарий"].value ?? ""
                            partner.info = part["ДополнительнаяИнформация"].value ?? ""
                        }
                        
                        CoreDataService.saveContext()
                    }
                }
            }
        
//MARK: - Save contacts for client
            if let clients = readXmlClients.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
                for client in clients {
                    if let contacts = client["КонтактнаяИнформация"]["Row"].all {
                        for cont in contacts {
                            CoreDataService.mainContext.perform {
                                let contact = Contact(context: CoreDataService.mainContext)
                                if let client = Client.getById(id: client["Ref"].value ?? "") {
                                    contact.type = cont["Тип"].value ?? ""
                                    contact.view = cont["Представление"].value ?? ""
                                    contact.client = client
                                }
                                
                                CoreDataService.saveContext()
                            }
                        }
                    }
                }
            }
            
//MARK: - Save contacts for partner
            if let partners = readXmlClients.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
                for part in partners {
                    if let contacts = part["КонтактнаяИнформация"]["Row"].all {
                        for cont in contacts {
                            CoreDataService.mainContext.perform {
                                let contact = Contact(context: CoreDataService.mainContext)
                                if let partner = Partner.getById(id: part["Ref"].value ?? "") {
                                    contact.type = cont["Тип"].value ?? ""
                                    contact.view = cont["Представление"].value ?? ""
                                    contact.partner = partner
                                }
                                
                                CoreDataService.saveContext()
                            }
                        }
                    }
                }
            }
            
            
        } catch {
            print("\(error)")
        }
        
    }
}
