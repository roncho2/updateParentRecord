trigger updateParentRecord on Contact (after update) {
    Set<Id> parentAccIds = new Set<Id>();
    if(trigger.isAfter && trigger.isUpdate){

        if(!trigger.new.isEmpty()){
            for(Contact conObj : trigger.new){
                if(conObj.AccountId != null && conObj.Description != trigger.oldMap.get(conObj.Id).Description){
                    parentAccIds.add(conObj.AccountId);
                    

                }

            }

        }

    }
    if(!parentAccIds.isEmpty()){
    Map<Id, Account> mapToUpdate = new Map<Id, Account>();
    Map<Id, Account> parentAccMap = new Map<Id, Account>([SELECT Id, Description FROM Account WHERE Id IN : parentAccIds]);
    if(!trigger.new.isEmpty()){
        for(Contact con : trigger.New){  
            if(parentAccMap.containsKey(con.AccountId)){
                Account acc = parentAccMap.get(con.AccountId);
                acc.Description = con.Description;
                mapToUpdate.put(acc.Id, acc);



            }
        }

    }
    if(!mapToUpdate.isEmpty()){
        try{
            update mapToUpdate.values();
        }catch(Exception ex){
            System.debug('Error while updating record-->'  +  ex.getMessage());

        }

        }

    }

}
