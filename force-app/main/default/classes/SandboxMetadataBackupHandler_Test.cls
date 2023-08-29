@isTest
public with sharing class SandboxMetadataBackupHandler_Test {
    @isTest
    public static void testMetaDataBackup(){
        test.setMock(HttpCalloutMock.class, new SandboxInfo_Manager_Test.Mock());
        test.startTest();
        SandboxMetadataBackupHandler schedulableClass = new SandboxMetadataBackupHandler();
        system.schedule('SandboxMetadataBackupHandler', '0 0 0 ? * * *', schedulableClass);
        test.stopTest();
    } 
 
}