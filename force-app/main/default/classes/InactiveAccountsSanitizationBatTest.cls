@isTest
public with sharing class InactiveAccountsSanitizationBatTest {
    @TestSetup
    static void makeData(){
        //Account without op in terms to inactivate
        Account acc = new Account(
            Name='Test1', 
            Tipo_Conta__c = 'CPF', 
            Type='Parceiro', 
            AccountNumber='088.000.565-94'
        );
        insert acc;
        
        Account acc2 = new Account(
            Name='Test2', 
            Tipo_Conta__c = 'CPF', 
            Type='Parceiro', 
            AccountNumber='088.000.565-94'
        );
        insert acc2;  
        
        Account acc3 = new Account(
            Name='Test3', 
            Tipo_Conta__c = 'CPF', 
            Type='Consumidor Final', 
            AccountNumber='088.000.565-94'
        );
        insert acc3; 
        
        Account acc4 = new Account(
            Name='Test4', 
            Tipo_Conta__c = 'CPF', 
            Type='Consumidor Final', 
            AccountNumber='088.000.565-94'
        );
        insert acc4;       

    }

    @isTest
    static void test_account_without_opp_ganha_in_120_days_inactivated() {
        Opportunity oppAcc = [SELECT Id, StageName, CreatedDate FROM Opportunity WHERE Account.Name = 'test1'];

        oppAcc.StageName = 'Ganho';
        oppAcc.Data_Ganha__c = Date.today().addDays(121);
        update oppAcc;

        Test.startTest();
        InactiveAccountsSanitizationBatchable b = new InactiveAccountsSanitizationBatchable();
        Database.executeBatch(b);
        Test.stopTest();
        Account acc = [SELECT Id, Inativa__c, CreatedDate FROM Account WHERE Name = 'Test1' LIMIT 1];
        System.assertEquals(true, acc.Inativa__c, 'Conta sem op nos ultimos 120 dias não foi inativada');
    }

    @isTest
    static void test_account_with_opp_ganha_in_120_days_not_inactivated() {
        Opportunity oppAcc = [SELECT Id, StageName, Data_Ganha__c FROM Opportunity WHERE Account.Name = 'test2'];

        oppAcc.StageName = 'Ganho';
        oppAcc.Data_Ganha__c = Date.today().addDays(70);
        update oppAcc;

        Test.startTest();
        InactiveAccountsSanitizationBatchable b = new InactiveAccountsSanitizationBatchable();
        Database.executeBatch(b);
        Test.stopTest();
        Account acc2 = [SELECT Id, Inativa__c, CreatedDate FROM Account WHERE Name = 'Test2' LIMIT 1];
        System.assertEquals(false, acc2.Inativa__c, 'Conta com op nos ultimos 120 dias foi inativada');
    }

    @isTest
    static void test_account_with_opp_negociacao_not_inactivated() {
        Opportunity oppAcc = [SELECT Id, StageName, CreatedDate FROM Opportunity WHERE Account.Name = 'test2'];

        oppAcc.StageName = 'Negociação';
        //oppAcc.Data_Ganha__c = Date.today().addDays(70);
        update oppAcc;

        Test.startTest();
        InactiveAccountsSanitizationBatchable b = new InactiveAccountsSanitizationBatchable();
        Database.executeBatch(b);
        Test.stopTest();
        Account acc2 = [SELECT Id, Inativa__c, CreatedDate FROM Account WHERE Name = 'Test2' LIMIT 1];
        System.assertEquals(false, acc2.Inativa__c, 'Conta com op nos ultimos 120 dias foi inativada');
    }

    @isTest
    static void test_account_without_task_not_inactivated() {
        
        Task taskAcc = [SELECT Id, CreatedDate FROM Task WHERE Account.Name = 'test3'];

        Test.setCreatedDate(taskAcc.Id, System.now().addDays(-91));
        update taskAcc;

        Test.startTest();
        InactiveAccountsSanitizationBatchable b = new InactiveAccountsSanitizationBatchable();
        Database.executeBatch(b);
        Test.stopTest();
        Account conta = [SELECT Id, Inativa__c, CreatedDate FROM Account WHERE Name = 'Test3' LIMIT 1];
        System.assertEquals(false, conta.Inativa__c, 'Conta sem tarefa não foi inativada');
    }
}