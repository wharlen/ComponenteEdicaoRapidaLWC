trigger AccountTrigger on Account (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        AccountBO.validaTipoConta(Trigger.new);
        AccountBO.trataTipoParceiro(Trigger.new);
        AccountBO.trataTipoConsumidorFinal(Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isUpdate){
        AccountBO.validaTipoConta(Trigger.new);
    }
}