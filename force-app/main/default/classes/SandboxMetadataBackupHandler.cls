public with sharing class SandboxMetadataBackupHandler implements Schedulable{
    
    private static final integer SANDBOX_MAX = 20;

    public void execute(SchedulableContext sc){
        startBackup();
    }
    
    @future(callout=true)
    public static void startBackup(){
        List<SandboxInfo> sandboxes = SandboxInfo_Manager.getSandboxes();
        SandboxInfo sandboxToRefresh=null;
        Integer countOfBackups=0;
        for(SandboxInfo sandbox : sandboxes){
            if(sandbox.SandboxName.contains('MDBx')){
                if((sandboxToRefresh==null||sandboxToRefresh.LastModifiedDate>sandbox.LastModifiedDate)){
                    sandboxToRefresh=sandbox;
                }
                countOfBackups++;
            }
        }
        if(countOfBackups<SANDBOX_MAX){
            SandboxInfo newSandbox = new SandboxInfo();
            newSandbox.LicenseType='DEVELOPER';
            newSandbox.AutoActivate=true;
            newSandbox.Description='Metadata Backup';
            newSandbox.SandboxName='MDBx'+(countOfBackups+1);
            SandboxInfo_Manager.createSandbox(newSandbox);
        }
        else{SandboxInfo_Manager.refreshSandbox(sandboxToRefresh);}
        
    }
    
}
