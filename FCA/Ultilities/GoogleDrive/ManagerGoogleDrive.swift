//
//  ManagerGoogleDrive.swift
//  FCA
//

import Foundation
let kGTLAuthScopeDriveFile = "https://www.googleapis.com/auth/drive.file"

class ManagerGoogleDrive: NSObject {
    let driveService : GTLRDriveService =  GTLRDriveService()
    var authorizationCompletion: ((Bool) -> Void)?
    let imageFolder: String = "1G5wBWlCsyI4rBdWEs_N9I8AuOvtwqIEM"
    let excelFolder: String = "1Cef9qAaPAO7ym3z0mVN6STlmNPeponvP"
    let adminFolder: String = "1KPZEKXZicjJAch9SMmuvZUK1yGACAbZQ"
    
    static private var singleton: ManagerGoogleDrive?
    static var shared: ManagerGoogleDrive {
        if singleton == nil {
            singleton = ManagerGoogleDrive()
        }
        return singleton!
    }
    
    func setup() {
        let googleAuthorizer = GAuthorizer.shared
        googleAuthorizer.addScope(kGTLAuthScopeDriveFile)
        googleAuthorizer.loadState()
        driveService.authorizer = googleAuthorizer.authorization
        GAuthorizer.shared.authorizationCompletion = {
            (result: Bool) in
            if result {
                self.driveService.authorizer = GAuthorizer.shared.authorization
            }
        }
    }
    
    func isAuthorized() -> Bool {
        return GAuthorizer.shared.isAuthorized()
    }
    
    func resetState() {
        return GAuthorizer.shared.resetState()
    }
    
    func authorize(in presentingViewController: UIViewController, authorizationCompletion: @escaping ((Bool) -> Void)) {
        GAuthorizer.shared.authorize(in: presentingViewController, authorizationCompletion: authorizationCompletion)
    }
    
    func uploadImage(image: UIImage, fileName: String, uploadCompletion: @escaping ((Bool) -> Void)) {
        let dateFormat  = DateFormatter()
        dateFormat.dateFormat = "'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"
        
        let file = GTLRDrive_File()
        file.descriptionProperty = "Uploaded from Google Drive IOS"
        file.mimeType = "image/png"
        file.name = fileName
        
        let data = UIImagePNGRepresentation(image)
        let uploadParameters = GTLRUploadParameters.init(data: data!, mimeType: file.mimeType!)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        self.driveService.executeQuery(query, completionHandler: { (ticket, insertedFile, error) in
            if error == nil {
                uploadCompletion(true)
            }else {
                uploadCompletion(false)
            }
        })
    }
    
    func uploadFileToFolder(image: UIImage, fileName: String, uploadCompletion: @escaping ((Bool) -> Void)) {
        let fileData: Data? = UIImagePNGRepresentation(image)
        let folderId = imageFolder
        let metadata = GTLRDrive_File()
        metadata.name = fileName
        metadata.parents = [folderId]
        
        let uploadParameters = GTLRUploadParameters(data: fileData!, mimeType: "image/png")
        uploadParameters.shouldUploadWithSingleRequest = true
        let query = GTLRDriveQuery_FilesCreate.query(withObject: metadata, uploadParameters: uploadParameters)
        query.fields = "id"
        driveService.executeQuery(query, completionHandler: { ticket, file, error in
            if error == nil {
                uploadCompletion(true)
            }else {
                uploadCompletion(false)
            }
        })
    }
    
    func uploadExcelFile(filePath: String, fileName: String, id: String, uploadCompletion: @escaping ((Bool) -> Void)) {
        let dateFormat  = DateFormatter()
        dateFormat.dateFormat = "'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"
        let folderId = excelFolder
        let file = GTLRDrive_File()
        
        file.descriptionProperty = "Uploaded from Google Drive IOS"
        file.mimeType = "application/vnd.ms-excel"
        file.name = fileName
        file.parents = [folderId]
        
        guard let fileData = FileManager.default.contents(atPath: filePath) else {
            return
        }
        let uploadParameters = GTLRUploadParameters.init(data: fileData, mimeType: file.mimeType!)
        if id == "" {
            let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
            self.driveService.executeQuery(query, completionHandler: { (ticket, insertedFile, error) in
                
                if error == nil {
                    uploadCompletion(true)
                }else {
                    uploadCompletion(false)
                }
            })
        } else {
            let del = GTLRDriveQuery_FilesDelete.query(withFileId: id)
            let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
            self.driveService.executeQuery(del, completionHandler: { (ticket, insertedFile, error) in
                self.driveService.executeQuery(query, completionHandler: { (ticket, insertedFile, error) in
                    
                    if error == nil {
                        uploadCompletion(true)
                    }else {
                        uploadCompletion(false)
                    }
                })

            })
        }
    }
    
    func uploadExcelFileToAdmin(filePath: String, fileName: String, uploadCompletion: @escaping ((Bool) -> Void)) {
        let dateFormat  = DateFormatter()
        dateFormat.dateFormat = "'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"
        let folderId = adminFolder
        let file = GTLRDrive_File()
        file.descriptionProperty = "Uploaded from Google Drive IOS"
        file.mimeType = "application/vnd.ms-excel"
        file.name = fileName
        file.parents = [folderId]
        
        guard let fileData = FileManager.default.contents(atPath: filePath) else {
            return
        }
        let uploadParameters = GTLRUploadParameters.init(data: fileData, mimeType: file.mimeType!)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        self.driveService.executeQuery(query, completionHandler: { (ticket, insertedFile, error) in
            
            if error == nil {
                uploadCompletion(true)
            }else {
                uploadCompletion(false)
            }
        })
    }
    
    // Download file from drive
    func loadDriveFiles(uploadCompletion: @escaping ((GTLRDrive_FileList) -> Void)) {
        let query = GTLRDriveQuery_FilesList.query()
        query.q = "'\(excelFolder)' IN parents"
        query.pageSize = 300
        query.fields = "files(id,trashed,originalFilename),nextPageToken";
        //files(id,name,mimeType,modifiedTime,createdTime,fileExtension,size,parents,kind
        // root is for root folder replace it with folder identifier in case to fetch any specific folder
        driveService.executeQuery(query, completionHandler: { ticket, files, error in
            if error == nil {
                if let filesList : GTLRDrive_FileList = files as? GTLRDrive_FileList {
                    //                    var cloudArray = Array<GTLRDrive_File>()
                    uploadCompletion(filesList)
                } else {
                    
                }
            } else {
                if let anError = error {
                    print("An error occurred: \(anError)")
                }
            }
        })
    }
    
    func getFile(fileId: String, uploadCompletion: @escaping ((NSData) -> Void)) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileId)
        //1MSMGnWZk1ahPcoiz5eJzVuVRC0tPyIap
        //1soxoNf375wHnd_rqj2Cxh7EixWoE6Pto
        //1OXg3EvQHYHtNKYP-_rraKjJACw4OS605
        driveService.executeQuery(query, completionHandler: { ticket, file, error in
            if error == nil {
                //                let data = file as! GTLRDataObject
                //                if var aLength = (file as AnyObject).data.count {
                let data = (file as AnyObject).data as NSData
                uploadCompletion(data)
                //                }
            } else {
                if let anError = error {
                    print("An error occurred: \(anError)")
                }
            }
        })
    }
    
    func downloadFile(){
        let url = "https://www.googleapis.com/drive/v3/files/1MSMGnWZk1ahPcoiz5eJzVuVRC0tPyIap?alt=media"
        
        let fetcher = driveService.fetcherService.fetcher(withURLString: url)
        
        fetcher.beginFetch(
            withDelegate: self,
            didFinish: #selector(finishedFileDownload(fetcher:finishedWithData:error:)))
    }
    
    @objc
    func finishedFileDownload(fetcher: GTMSessionFetcher, finishedWithData data: NSData, error: NSError?){
        if let error = error {
            //show an alert with the error message or something similar
            return
        }
        do {
            var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
            let fullPath: String = paths[0] + "/testSave.xlsx"
            let asasd = try data.write(to: URL.init(string: fullPath)!)
            print(asasd)
            // do something with data
            // if the call fails, the catch block is executed
        }catch {
            
        }
        //do something with data (save it...)
    }
}
