trigger accountTrigger on Account (before update) {
    if(trigger.isBefore && trigger.isUpdate) {
        for(Account acc: trigger.new) {
            if(trigger.oldMap.get(acc.Id).AnnualRevenue != acc.AnnualRevenue)
                acc.Description = 'Old Value: '+trigger.oldMap.get(acc.Id).AnnualRevenue + ', New Value: ' + acc.AnnualRevenue;
        }
    }
} 