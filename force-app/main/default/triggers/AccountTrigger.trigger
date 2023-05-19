trigger AccountTrigger on Account (before insert, before update, after insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        AccountBO.validaTipoConta(Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isUpdate){
        AccountBO.validaTipoConta(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert){
        AccountBO.trataTipoParceiro(Trigger.new);
        AccountBO.trataTipoConsumidorFinal(Trigger.new);
    }
}