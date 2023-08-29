public with sharing class SandboxInfo_Manager {

    public class sandboxInfoAPIReturn{
        public List<SandboxInfo> records;
        public Integer size;
        public Integer totalSize;
        public Boolean done;
        public Object queryLocator;
        public String entityTypeName;
    }

    public static List<SandboxInfo> getSandboxes(){  
        HttpResponse res = callToolingAPI(null,'/query/?q=Select+id,SandboxName,LastModifiedDate+from+SandboxInfo','GET');
        sandboxInfoAPIReturn sandboxesAPIreturn = (sandboxInfoAPIReturn) JSON.deserialize(res.getBody(), sandboxInfoAPIReturn.class);
        List<SandboxInfo> sandboxes = sandboxesAPIreturn.records;
        return sandboxes;
    }  
    
    public static string refreshSandbox(SandboxInfo sandbox){
        HttpResponse res = callToolingAPI(prepSandboxInfoForREST(sandbox),'/sobjects/SandboxInfo/'+sandbox.Id,'PATCH');
        if(res.getStatusCode()==201||res.getStatusCode()==200||res.getStatusCode()==204)return res.getBody(); 
        else throw new CalloutException(res.getBody());   
    }

    public static string createSandbox(SandboxInfo sandbox){
        HttpResponse res = callToolingAPI(prepSandboxInfoForREST(sandbox),'/sobjects/SandboxInfo','POST');
        if(res.getStatusCode()==201)return res.getBody(); 
        else throw new CalloutException(res.getBody());   
    }

    public static string deleteSandbox(SandboxInfo sandbox){
        HttpResponse res = callToolingAPI(prepSandboxInfoForREST(sandbox),'/sobjects/SandboxInfo','DELETE');
        if(res.getStatusCode()==204)return res.getBody(); 
        else throw new CalloutException(res.getBody());
    }
    
    public static HttpResponse callToolingAPI(String body,String endpoint,String method){
        Http h = new Http();
        HttpRequest hr = new HttpRequest();
        hr.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        hr.setHeader('content-type','application/Json');
        hr.setTimeout(60000);
        hr.setEndpoint('callout:ToolingRest'+endPoint);
        if(body!=null)hr.setBody(body);
        system.debug(body);
        hr.setMethod(method);
        HttpResponse res = h.send(hr);
        
        return res;
    }

    public static string prepSandboxInfoForREST(SandboxInfo sandbox){
        sandbox.LastModifiedDate=null;
        sandbox.CreatedDate=null;
        return JSON.serialize(sandbox, true);
    }
    
}