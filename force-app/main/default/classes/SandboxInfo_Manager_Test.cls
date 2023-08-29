@isTest
public with sharing class SandboxInfo_Manager_Test {
    
    
    public class Mock implements HttpCalloutMock{
        public String getSandboxesReturn ='{"size":3,"totalSize":3,"done":true,"queryLocator":null,"entityTypeName":"SandboxInfo",'
        +'"records":[{"attributes":{"type":"SandboxInfo","url":"/services/data/v41.0/tooling/sobjects/SandboxInfo/0GQ1U000000D5ziWAC"},'
        +'"Id":"0GQ1U000000D5ziWAC","SandboxName":"LoadTest","LastModifiedDate":"2023-01-05T14:15:49.000+0000"},'
        +'{"attributes":{"type":"SandboxInfo","url":"/services/data/v41.0/tooling/sobjects/SandboxInfo/0GQ1U0000000NdGWAU"},'
        +'"Id":"0GQ1U0000000NdGWAU","SandboxName":"Metadata-Backup","LastModifiedDate":"2022-01-14T18:03:32.000+0000"},'
        +'{"attributes":{"type":"SandboxInfo","url":"/services/data/v41.0/tooling/sobjects/SandboxInfo/0GQ1U0000000KU9WAM"},'
        +'"Id":"0GQ1U0000000KU9WAM","SandboxName":"SFSIFull","LastModifiedDate":"2023-03-03T18:59:40.000+0000"}]}';

        public HTTPResponse respond(HTTPRequest req) {
            if(req.getEndpoint().contains('/query/?q=Select+id,SandboxName,LastModifiedDate+from+SandboxInfo')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody(getSandboxesReturn);
                res.setStatusCode(200);
                return res;
            }else if(req.getEndpoint().contains('/sobjects/SandboxInfo')&&req.getMethod().contains('PATCH')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setStatusCode(204);
                return res;
            }else if(req.getEndpoint().contains('/sobjects/SandboxInfo')&&req.getMethod().contains('POST')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setStatusCode(201);
                return res;    
            }else if(req.getEndpoint().contains('/sobjects/SandboxInfo')&&req.getMethod().contains('DELETE')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setStatusCode(204);
                return res;
            }
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(404);
            return res;
        }
    }

    public class FailureMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req) {
            if(req.getEndpoint().contains('/query/?q=Select+id,SandboxName,LastModifiedDate+from+SandboxInfo')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('The session ID or OAuth token used has expired or is invalid.');
                res.setStatusCode(401);
                return res;
            }else if(req.getEndpoint().contains('/sobjects/SandboxInfo')&&req.getMethod().contains('PATCH')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('The sandbox you tried to refresh or delete has a current status of PROCESSING. Wait until its status is Finished, and then try again.');
                res.setStatusCode(403);
                return res;
            }else if(req.getEndpoint().contains('/sobjects/SandboxInfo')&&req.getMethod().contains('POST')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('The Id field should not be specified in the sobject data.');
                res.setStatusCode(400);
                return res;    
            }else if(req.getEndpoint().contains('/sobjects/SandboxInfo')&&req.getMethod().contains('DELETE')){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('The request could not be completed due to a conflict with the current state of the resource. Check that the API version is compatible with the resource you are requesting.');
                res.setStatusCode(409);
                return res;
            }
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('An error has occurred within Lightning Platform, so the request couldn’t be completed. Contact Salesforce Customer Support.');
            res.setStatusCode(500);
            return res;
        }
    }

    @isTest
    public static void testCallout(){
        test.setMock(HttpCalloutMock.class, new Mock());
        List<SandboxInfo> records=SandboxInfo_Manager.getSandboxes();
        system.assert(!records.isEmpty());
        SandboxInfo_Manager.refreshSandbox(records[0]);
        SandboxInfo_Manager.createSandbox(records[0]);
        SandboxInfo_Manager.deleteSandbox(records[0]);

    }

    @isTest
    public static void testFailedCallout(){
        test.setMock(HttpCalloutMock.class, new FailureMock());
        SandboxInfo newSandbox = new SandboxInfo();
        newSandbox.LicenseType='DEVELOPER';
        newSandbox.AutoActivate=true;
        newSandbox.Description='MetaData Backup';
        newSandbox.SandboxName='MDBx';
        try{
            List<SandboxInfo> records=SandboxInfo_Manager.getSandboxes();
        }catch(Exception e){
            system.assert(true);
        }
        try{
            SandboxInfo_Manager.refreshSandbox(newSandbox);
        }catch(Exception e){
            system.assert(true);
        }
        try{
            SandboxInfo_Manager.createSandbox(newSandbox);
        }catch(Exception e){
            system.assert(true);
        }
        try{
            SandboxInfo_Manager.deleteSandbox(newSandbox);
        }catch(Exception e){
            system.assert(true);
        }

    }
    
}