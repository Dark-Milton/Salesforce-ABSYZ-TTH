@RestResource(urlMapping='/Cases/*')
global with sharing class CaseManager {
    @HttpGet
    global static List<Case> getCaseLikeSubject(){
        RestRequest request = RestContext.request;
        String subject = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        subject = '%' + subject + '%';
        return [SELECT Id, Subject, Status, Priority, CaseNumber FROM Case WHERE Subject LIKE :subject];
    }
    @HttpPost
    global static ID createCase(String origin, String subject, String description) {
        Case thisCase = new Case(
            Subject=subject,
            Description=description,
            Origin=origin);
        insert thisCase;
        return thisCase.Id;
    }
    @HttpDelete
    global static void deleteCase() {
        RestRequest request = RestContext.request;
        String subject = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        subject = '%' + subject + '%';
        List<Case> thisCases = [SELECT Id FROM Case WHERE Subject LIKE :subject];
        delete thisCases;
    }
}