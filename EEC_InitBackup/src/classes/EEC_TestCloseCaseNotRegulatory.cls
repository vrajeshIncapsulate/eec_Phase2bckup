@isTest
public with sharing class EEC_TestCloseCaseNotRegulatory {
    
    @isTest static void testCloseNoEmail() {
        
        
        Integer emailCountBefore = Limits.getEmailInvocations();
        Case c = EEC_TestUtil.mockCase(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()), EEC_TestUtil.mockContact());
        Task t = EEC_TestUtil.mockTask(c);
        EEC_CloseCaseNotRegulatory ext = new EEC_CloseCaseNotRegulatory (new ApexPages.StandardController(c));
        Test.startTest();
        ext.close();
        Integer emailCountAfter = Limits.getEmailInvocations();
        
        Case cAfter = [SELECT Status, Priority FROM Case WHERE Id = :c.Id];
        List<Task> ts = [SELECT Status FROM Task WHERE WhatId = :c.Id];
        
        //system.debug('*** Tasks -----'+ ts);
        System.assertEquals(emailCountBefore, emailCountAfter);
        System.assertEquals('Closed', cAfter.Status);
        System.assertEquals(2, ts.size());
        System.assertEquals('Completed', ts.get(0).Status);
        
        Test.stopTest();
    }
    
    @isTest static void testCloseWithEmail() {
        
        
        Integer emailCountBefore = Limits.getEmailInvocations();
        Contact contact = EEC_TestUtil.mockContact('fakeemail@fake.com');
        Case c = EEC_TestUtil.mockCase(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()), contact );
       
        Task t = EEC_TestUtil.mockTask(c);
        Test.startTest();
        EEC_CloseCaseNotRegulatory ext = new EEC_CloseCaseNotRegulatory (new ApexPages.StandardController(c));
        ext.close();
        Integer emailCountAfter = Limits.getEmailInvocations();
        
        Case cAfter = [SELECT Status, Priority FROM Case WHERE Id = :c.Id];
        List<Task> ts = [SELECT Subject, Status, ActivityDate FROM Task WHERE WhatId = :c.Id];
        
        system.debug('*** Tasks -----'+ ts);
        
        System.assertEquals(emailCountBefore, emailCountAfter);
        System.assertEquals('Closed', cAfter.Status);
        System.assertEquals(3, ts.size());
        
        
        System.assertEquals('Completed', ts.get(0).Status);
        System.assertEquals(System.Today(), ts.get(0).ActivityDate);
        
        Test.stopTest();
    }
        
}