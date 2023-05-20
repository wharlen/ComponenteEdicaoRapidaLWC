import { LightningElement, api, wire, track} from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

//getPicklistValues para retornar os valores das picklists
//getObjectInfo para retornar o parametro obrigatório do getPicklistValues que é o recordTypeId
import {  getObjectInfo } from 'lightning/uiObjectInfoApi'

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import IDCONTA from '@salesforce/schema/Account.Id';
import TIPO from '@salesforce/schema/Account.Type';
import TIPOCONTA from '@salesforce/schema/Account.Tipo_Conta__c';
import NOME from '@salesforce/schema/Account.Name';
import NUMEROCONTA from '@salesforce/schema/Account.AccountNumber';
import RECORDTYPEID from '@salesforce/schema/Account.MasterRecordId';

const fields = [IDCONTA, TIPO, TIPOCONTA, NOME, NUMEROCONTA, RECORDTYPEID];

export default class EdicaoCamposCliente extends LightningElement {
    @api recordId;
    @api objectInfo;
    @api isLoading = false;
    @track account;
    @api tipoContaValues =[
        {'label':'CNPJ', 'value':'CNPJ'},
        {'label':'CPF', 'value':'CPF'}
    ];
    @api tipoValues = [
        {'label':'Parceiro', 'value':'Parceiro'},
        {'label':'Consumidor Final', 'value':'Consumidor Final'}
    ];
    @api RECORDTYPE;

    /*@wire(getPicklistValues, {
        fieldApiName: TIPO,
        recordTypeId: recordTypeId
    })*/

    renderedCallback() {
    }

    connectedCallback() {
    }

    @wire(getRecord, { recordId: '$recordId', fields })
    account;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    handleChange(){
        console.log(this.account.data);
    }

    /*@wire(getPicklistValues, { recordTypeId: this.account.data.recordTypeId, fieldApiName: TIPO })
    tipoValues;

    @wire(getPicklistValues, { recordTypeId: recordType, fieldApiName: TIPOCONTA })
    tipoContaValues;*/

    get id() {
        return getFieldValue(this.account.data, IDCONTA);
    }

    get tipo() {
        return getFieldValue(this.account.data, TIPO);
    }

    get tipoConta() {
        return getFieldValue(this.account.data, TIPOCONTA);
    }

    get nome() {
        return getFieldValue(this.account.data, NOME);
    }

    get numeroConta() {
        return getFieldValue(this.account.data, NUMEROCONTA);
    }

    get recordType() {
        return getFieldValue(this.account.data.recordTypeId, RECORDTYPE);
    }

    updateAccount(event) {
        this.isLoading = true;

        const fields = {};
        fields[IDCONTA.fieldApiName] = this.recordId;
        fields[TIPO.fieldApiName] = this.template.querySelector("[data-field='tipo']").value;
        fields[TIPOCONTA.fieldApiName] = this.template.querySelector("[data-field='tipoConta']").value;
        fields[NOME.fieldApiName] = this.template.querySelector("[data-field='nome']").value;
        fields[NUMEROCONTA.fieldApiName] = this.template.querySelector("[data-field='numeroConta']").value;
        console.log(fields)

        const recordInput = { fields };
        console.log(recordInput)
        updateRecord(recordInput)
            .then((res) => {
                console.log(res)
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Successo',
                        message: 'Conta atualizada com sucesso ',
                        variant: 'success'
                    })
                );
                return refreshApex(this.account);
            })
            .catch(error => {
                console.log(error.body)
                console.log(error.body.output.errors[0].message)

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erro ao criar registro',
                        message: 'Ocorreu um erro:\n'+error.body.output.errors[0].message,
                        variant: 'error'
                    })
                );
            }).finally(()=>{
                this.isLoading = false;
            });
    }

}