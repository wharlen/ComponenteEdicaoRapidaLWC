global class InactiveAccountsSanitizationBatchable implements Database.Batchable<Account>{
    public Iterable<Account> start(Database.BatchableContext BC){
        Set<Id> accountsToInactivate = new Set<Id>();

        //Contas com Tarefas nos ultimos 90 dias
        //Se as contas ativas não estiverem dentro dessas então deve ser ativadas
        Set<Id> accountsWithTasksIn90 = new Set<Id>();
        for(Task task : [SELECT AccountId FROM Task WHERE CreatedDate < LAST_N_DAYS:90]){
            accountsWithTasksIn90.add(task.AccountId);
        }
        System.debug(accountsWithTasksIn90);

        //Pega contas ativas para verificar se estão nas condições para inativação
        //Com contas que não tenham oportunidades Ganhas em 120 dias ou em negociação
        Map<Id, Account> accountsIds = new Map<Id, Account>([SELECT Id, Inativa__c FROM Account 
        WHERE Inativa__C = false 
        AND Id not in (SELECT AccountId FROM Opportunity 
                        WHERE (StageName = 'Ganho' 
                                AND Data_Ganha__c < LAST_N_DAYS:120) 
                        OR StageName = 'Negociação')
        AND Id NOT IN: accountsWithTasksIn90]);

        return [
            SELECT Id, Inativa__c FROM Account 
            WHERE Id IN: accountsIds.keySet()
        ];
    }
  
    global void execute(Database.BatchableContext BC, List<Account> scope){
        System.debug(scope);
        AccountBO.sanitizateAccount(scope);
    }

    global void finish( Database.BatchableContext bc ){
    }
}