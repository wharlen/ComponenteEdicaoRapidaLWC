public with sharing class AccountBO {
    public static void validaTipoConta(List<Account> newAccounts) {
        
        for(Account acc : newAccounts){

            if(String.isBlank(acc.AccountNumber)){
                acc.addError('Número não pode ser vazio');
            }

            if(acc.Tipo_Conta__c == 'CNPJ'){
                if(!Util.validaCNPJ(acc.AccountNumber)){
                    acc.addError('Número do cliente é inválido');
                }
            }else {
                if(!Util.validaCPF(acc.AccountNumber)){
                    acc.addError('Número do cliente é inválido');
                }
            }
        }
    }

    public static void trataTipoParceiro(List<Account> newAccounts){
        List<Account> accToInsertOpp = new List<Account>();
        for(Account acc : newAccounts){
            if(acc.Type == 'Channel Partner / Reseller'){
                accToInsertOpp.add(acc);
            }
        }

        if(!accToInsertOpp.isEmpty()){
            Opportunity opp;
            List<Opportunity> oppsToInsert = new List<Opportunity>();
            for(Account acc : accToInsertOpp){
                opp = new Opportunity(
                    Name = acc.Name +' – opp Parceiro',
                    StageName = 'Qualification',
                    CloseDate = Date.today().addDays(30),
                    AccountId = acc.Id
                );
                oppsToInsert.add(opp);
            }

            if(!oppsToInsert.isEmpty()){
                insert oppsToInsert;
            }
        }
    }

    public static void trataTipoConsumidorFinal(List<Account> newAccounts){
        List<Account> accToInsertTask = new List<Account>();
        for(Account acc : newAccounts){
            if(acc.Type == 'Customer - Direct'){
                accToInsertTask.add(acc);
            }
        }

        if(!accToInsertTask.isEmpty()){
            Task task;
            List<Task> tasksToInsert = new List<Task>();
            for(Account acc : accToInsertTask){
                task = new Task(
                    WhatId = acc.Id,
                    Status = 'Not started',
                    Priority = 'Normal',
                    Subject = 'Consumidor Final'
                );
                tasksToInsert.add(task);
            }

            if(!tasksToInsert.isEmpty()){
                insert tasksToInsert;
            }
        }
    }

    public static void sanitizateAccount(List<Account> accountToInactive){
        List<Account> accountsToUpdate = new List<Account>();
        for(Account acc : accountToInactive){
            acc.Inativa__c = true;
            accountsToUpdate.add(acc);
        }
        update accountsToUpdate;
    }
}