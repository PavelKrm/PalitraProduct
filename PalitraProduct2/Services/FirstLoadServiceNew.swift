import Foundation
import CoreData
import AEXML


final class FirstLoadDataNew {
    
    static let shared = FirstLoadDataNew()
    
    func readXml() {
//        let queue = DispatchQueue(label: "readProducts", qos: .userInitiated)
        
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
                
//                queue.async {
                    self.requestGroup(request: groupXml, groupId: "1a")
//                }
 
                //MARK: - save products
                let xmlInfo = try AEXMLDocument(xml: data2, options: options)
//                queue.sync {
                    self.requestProduct(requestProduct: xmlProduct, requestProductInfo: xmlInfo)
//                }
          
                //MARK: - save prices
//                queue.sync {
                    self.requestPrices(request: xmlInfo)
//                }
                
                //MARK: - Save clients
//                let clientsQueue = DispatchQueue(label: "readClients", qos: .userInitiated)
                let readXmlClients = try AEXMLDocument(xml: clientData, options: options)
//                clientsQueue.async {
                    self.requestClients(request: readXmlClients)
//                }

                //MARK: - Save partner
//                clientsQueue.async {
                    self.requestPartner(request: readXmlClients)
//                }
                
                //MARK: - Save contacts for client
//                clientsQueue.async {
                    self.requestContactsClient(request: readXmlClients)
//                }
               
                //MARK: - Save contacts for partner
//                clientsQueue.async {
                    self.requestContactsPartner(request: readXmlClients)
//                }

            } catch {
                print("\(error)")
            }
    }
    
    //MARK: - save group
    
    private func requestGroup(request: AEXMLElement, groupId: String? ) {
        
        if let array = request.all {
            for property in array {
                if property["Группы"].value != nil {
                    CoreDataServiceNew.backgroundContext.perform {
                        let group = Group(context: CoreDataServiceNew.backgroundContext)
                        group.groupId = property["Ид"].value ?? ""
                        group.name = property["Наименование"].value ?? ""
                        group.parentId = groupId
                        
                        CoreDataServiceNew.saveBackgroundContext()
                    }
                    
                    requestGroup(request: property["Группы"]["Группа"], groupId: (property["Ид"].value ?? ""))
                } else {
                    
                    }
                CoreDataServiceNew.backgroundContext.perform {
                        let group = Group(context: CoreDataServiceNew.backgroundContext)
                        group.groupId = property["Ид"].value ?? ""
                        group.name = property["Наименование"].value ?? ""
                        group.parentId = groupId
                        
                        if property["Ид"].value ?? "" == "db3b98d8-6bcf-11ec-b76a-b3fbe64f3794"{
                            print("записалась")
                            CoreDataServiceNew.saveBackgroundContext()
                    }
                }
            }
        
        }
    }
    
    //MARK: - save products
    
    private func requestProduct(requestProduct: AEXMLDocument, requestProductInfo: AEXMLDocument) {
        
        if let productXml = requestProduct.root["Каталог"]["Товары"]["Товар"].all {
            for element in productXml {
                var quantity: Int16 = 0
                if let productInfo = requestProductInfo.root["ПакетПредложений"]["Предложения"]["Предложение"].all {
                    for info in productInfo {
                        if element["Ид"].value == info["Ид"].value {
                            quantity = Int16(info["Склад"].attributes["КоличествоНаСкладе"] ?? "") ?? 0
                        }
                    }
                }
                CoreDataServiceNew.backgroundContext.perform {
                    let product = Product(context: CoreDataServiceNew.backgroundContext)
                    
                    product.lastUpdated = Date.now
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
                    
                    CoreDataServiceNew.saveBackgroundContext()
                }
            }
        }
    }
    
    //MARK: - save prices
    private func requestPrices(request: AEXMLDocument) {
        
        if let productInfo = request.root["ПакетПредложений"]["Предложения"]["Предложение"].all {
            for info in productInfo {
                if let priceInfo = info["Цены"]["Цена"].all {
                    for element in priceInfo {
                        var typePriceName: String = ""
                        if let elementPrice = request.root["ПакетПредложений"]["ТипыЦен"]["ТипЦены"].all {
                            elementPrice.forEach({
                                if element["ИдТипаЦены"].value == $0["Ид"].value {
                                    typePriceName = $0["Наименование"].value ?? ""
                                }
                            })
                        }
                        CoreDataServiceNew.backgroundContext.perform {
                            let price = Price(context: CoreDataServiceNew.backgroundContext)
                            
                            price.lastUpdated = Date.now
                            price.selfId = element["ИдТипаЦены"].value ?? ""
                            price.price = Double(element["ЦенаЗаЕдиницу"].value ?? "") ?? 0.0
                            price.productId = info["Ид"].value ?? ""
                            price.name = typePriceName
                            price.unit = info["БазоваяЕдиница"].attributes["Код"] ?? "error"
                            
                            if let product = Product.getById(id: price.productId ?? "") {
                                price.product = product
                            }
                            
                            CoreDataServiceNew.saveBackgroundContext()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Save clients
    private func requestClients(request: AEXMLDocument) {
        
        if let counterInfo = request.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Контрагенты"].all {
            for counter in counterInfo {
                if let partnerInfo = request.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
                    for partner in partnerInfo {
                        if counter["Партнер"].value == partner["Ref"].value {
                            CoreDataServiceNew.backgroundContext.perform {
                                let client = Client(context: CoreDataServiceNew.backgroundContext)
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
                                
                                
                                CoreDataServiceNew.saveBackgroundContext()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Save partner
    private func requestPartner(request: AEXMLDocument) {
        
        if let partnerInfo = request.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
            for part in partnerInfo {
                CoreDataServiceNew.backgroundContext.perform {
                    let partner = Partner(context: CoreDataServiceNew.backgroundContext)
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
                    
                    CoreDataServiceNew.saveBackgroundContext()
                }
            }
        }
    }
    
    //MARK: - Save contacts for client
    private func requestContactsClient(request: AEXMLDocument) {
        
        if let clients = request.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
            for client in clients {
                if let contacts = client["КонтактнаяИнформация"]["Row"].all {
                    for cont in contacts {
                        CoreDataServiceNew.backgroundContext.perform {
                            let contact = Contact(context: CoreDataServiceNew.backgroundContext)
                            if let client = Client.getById(id: client["Ref"].value ?? "") {
                                contact.type = cont["Тип"].value ?? ""
                                contact.view = cont["Представление"].value ?? ""
                                contact.client = client
                            }
                            
                            CoreDataServiceNew.saveBackgroundContext()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Save contacts for partner
    private func requestContactsPartner(request: AEXMLDocument) {
        
        if let partners = request.root["v8msg:Body"]["v8de:Changes"]["v8de:Data"]["CatalogObject.Партнеры"].all {
            for part in partners {
                if let contacts = part["КонтактнаяИнформация"]["Row"].all {
                    for cont in contacts {
                        CoreDataServiceNew.backgroundContext.perform {
                            let contact = Contact(context: CoreDataServiceNew.backgroundContext)
                            if let partner = Partner.getById(id: part["Ref"].value ?? "") {
                                contact.type = cont["Тип"].value ?? ""
                                contact.view = cont["Представление"].value ?? ""
                                contact.partner = partner
                            }
                            
                            CoreDataServiceNew.saveBackgroundContext()
                        }
                    }
                }
            }
        }
    }
    
}
