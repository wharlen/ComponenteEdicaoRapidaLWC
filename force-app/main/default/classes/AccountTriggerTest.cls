@isTest
public class AccountTriggerTest {
    @testSetup
    static void makeData(){

    }

    @isTest
    static void test_validaTipoConta_void_field() {
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account(Name='Test1', Tipo_Conta__c = 'CPF'));
        lstAcc.add(new Account(Name='Test1', AccountNumber= '', Tipo_Conta__c = 'CPF'));
        AccountBO.validaTipoConta(lstAcc);
    }

    @isTest
    static void test_validaTipoConta_CPF_success() {
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account(Name='Test1', AccountNumber= '000.000.333-94', Tipo_Conta__c = 'CPF'));
        lstAcc.add(new Account(Name='Test1', AccountNumber= '000.000.333-87', Tipo_Conta__c = 'CPF'));
        AccountBO.validaTipoConta(lstAcc);
    }

    @isTest
    static void test_validaTipoConta_CPF_error() {
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account(Name='Test1', AccountNumber= '000.000.333-s94', Tipo_Conta__c = 'CPF'));
        lstAcc.add(new Account(Name='Test1', AccountNumber= '000.000.333-87', Tipo_Conta__c = 'CPF'));
        AccountBO.validaTipoConta(lstAcc);
    }

    @isTest
    static void test_validaTipoConta_CNPJ_success() {
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-94', Tipo_Conta__c = 'CNPJ'));
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-98', Tipo_Conta__c = 'CNPJ'));
        AccountBO.validaTipoConta(lstAcc);
    }

    @isTest
    static void test_validaTipoConta_CNPJ_error() {
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-945', Tipo_Conta__c = 'CNPJ'));
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-98', Tipo_Conta__c = 'CNPJ'));
        AccountBO.validaTipoConta(lstAcc);
    }

    @isTest
    static void test_trataTipoParceiro() {
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-945', Tipo_Conta__c = 'CNPJ', Type='Channel Partner / Reseller'));
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-98', Tipo_Conta__c = 'CNPJ', Type='Channel Partner / Reseller'));
        AccountBO.trataTipoParceiro(lstAcc);
    }

    @isTest
    static void test_trataTipoConsumidorFinal() {
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-94', Tipo_Conta__c = 'CNPJ', Type='Customer - Direct'));
        lstAcc.add(new Account(Name='Test1', AccountNumber= '39.905.173/0001-98', Tipo_Conta__c = 'CNPJ', Type='Customer - Direct'));
        AccountBO.trataTipoConsumidorFinal(lstAcc);
    }
}