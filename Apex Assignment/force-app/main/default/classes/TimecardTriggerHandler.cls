public with sharing class TimecardTriggerHandler {
    private static String[] fieldAPINameList = new String[] {
        'Monday_Hours__c',
        'Tuesday_Hours__c',
        'Wednesday_Hours__c',
        'Thursday_Hours__c',
        'Friday_Hours__c',
        'Saturday_Hours__c',
        'Sunday_Hours__c'
    };
    public static void handleTimecardTrigger(List<Timecard__c> timecards, Map<Id, Timecard__c> oldTimecardsMap) {
        for(Timecard__c timecard : timecards) {

            if(!timecard.Start_Date__c.isSameDay(timecard.Start_Date__c.toStartOfWeek().addDays(1))) {
                timecard.Start_Date__c.addError('Start Date Error: Start Date is not Monday');
                continue;
            }
            if(!timecard.End_Date__c.isSameDay(timecard.Start_Date__c.addDays(7).toStartOfWeek())) {
                timecard.End_Date__c.addError('End Date Error: End Date is not next consecutive Sunday');
                continue;
            }
            
            // Date lockDate = timecard.Lock_Date__c;

            String monthLabel = 'Lockdate_' + timecard.Today_Date__c.month();
            Date lockDate = Date.parse(System.label.get('', monthLabel));

            if(timecard.Today_Date__c < lockDate) {
                monthLabel = 'Lockdate_' + timecard.Today_Date__c.addMonths(-1).month();
                lockDate = Date.parse(System.label.get('', monthLabel));
            }

            lockDate = lockDate.toStartofMonth();

            if(timecard.End_Date__c < lockDate) {
                if(oldTimecardsMap == null || oldTimecardsMap.get(timecard.Id).End_Date__c != timecard.End_Date__c) {
                    timecard.End_Date__c.addError('Cannot submit timecard for previous month');
                    continue;
                }
            }
            if(timecard.Start_Date__c < lockDate && ((oldTimecardsMap == null && timecard.Monday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Monday_Hours__c != timecard.Monday_Hours__c))) {
                timecard.addError('Timesheet locked');
            }
            else if(timecard.Start_Date__c.addDays(1) < lockDate && ((oldTimecardsMap == null && timecard.Tuesday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Tuesday_Hours__c != timecard.Tuesday_Hours__c))) {
                timecard.addError('Timesheet locked');
            }
            else if(timecard.Start_Date__c.addDays(2) < lockDate && ((oldTimecardsMap == null && timecard.Wednesday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Wednesday_Hours__c != timecard.Wednesday_Hours__c))) {
                timecard.addError('Timesheet locked');
            }
            else if(timecard.Start_Date__c.addDays(3) < lockDate && ((oldTimecardsMap == null && timecard.Thursday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Thursday_Hours__c != timecard.Thursday_Hours__c))) {
                timecard.addError('Timesheet locked');
            }
            else if(timecard.Start_Date__c.addDays(4) < lockDate && ((oldTimecardsMap == null && timecard.Friday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Friday_Hours__c != timecard.Friday_Hours__c))) {
                timecard.addError('Timesheet locked');
            }
            else if(timecard.Start_Date__c.addDays(5) < lockDate  && ((oldTimecardsMap == null && timecard.Saturday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Saturday_Hours__c != timecard.Saturday_Hours__c))) {
                timecard.addError('Timesheet locked');
            }
            else if(timecard.Start_Date__c.addDays(6) < lockDate && ((oldTimecardsMap == null && timecard.Sunday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Sunday_Hours__c != timecard.Sunday_Hours__c))) {
                timecard.addError('Timesheet locked');
            }
            System.debug('lockDate: ' + lockDate);
            // if(timecard.Start_Date__c.addDays(6) < timecard.Lock_Date__c.toStartofMonth()) {
            //     if((oldTimecardsMap == null && timecard.Sunday_Hours__c !=0) || (oldTimecardsMap != null && oldTimecardsMap.get(timecard.Id).Sunday_Hours__c != timecard.Sunday_Hours__c)) {
            //         timecard.addError('Timesheet locked');
            //     }
            // }
        }
    }
    public static void handleTimecardSplit(Map<Id, Timecard__c> timecardsMap, Map<Id, Timecard__c> oldTimecardsMap) {
        List<Timecard_Split__c> timecardSplitList = new List<Timecard_Split__c>();
        for(Id timecardId : timecardsMap.keySet()) {
            Timecard__c timecard = timecardsMap.get(timecardId);
            if(timecard.Start_Date__c.month() == timecard.End_Date__c.month()) {
                Timecard_Split__c timecardSplit = new Timecard_Split__c();
                timecardSplit.Timecard__c = timecard.Id;
                timecardSplit.Start_Date__c = timecard.Start_Date__c;
                timecardSplit.End_Date__c = timecard.End_Date__c;
                Integer totalHours = 0;
                for(String fieldAPIName : fieldAPINameList) {
                    totalHours += (Integer)timecard.get(fieldAPIName);
                }
                timecardSplit.Time_hours__c = totalHours;
                timecardSplitList.add(timecardSplit);
            }
            else {
                Timecard_Split__c timecardSplit1 = new Timecard_Split__c();
                timecardSplit1.Timecard__c = timecard.Id;
                timecardSplit1.Start_Date__c = timecard.Start_Date__c;
                timecardSplit1.End_Date__c = timecard.End_Date__c.toStartofMonth().addDays(-1);
                Decimal totalHours = 0;
                Integer i = 0;
                for(; i < timecardSplit1.Start_Date__c.daysBetween(timecardSplit1.End_Date__c) + 1; i++) {
                    totalHours += (Decimal)timecard.get(fieldAPINameList[i]);
                }
                timecardSplit1.Time_hours__c = totalHours;
                timecardSplitList.add(timecardSplit1);

                Timecard_Split__c timecardSplit2 = new Timecard_Split__c();
                timecardSplit2.Timecard__c = timecard.Id;
                timecardSplit2.Start_Date__c = timecard.End_Date__c.toStartOfMonth();
                timecardSplit2.End_Date__c = timecard.End_Date__c;
                totalHours = 0;
                for(; i < fieldAPINameList.size(); i++) {
                    totalHours += (Decimal)timecard.get(fieldAPINameList[i]);
                }
                timecardSplit2.Time_hours__c = totalHours;
                timecardSplitList.add(timecardSplit2);
            }
        }
        Database.insert(timecardSplitList);
    }
    public static void handleTimecardSplitUpdate(Map<Id, Timecard__c> timecardsMap, Map<Id, Timecard__c> oldTimecardsMap) {
        List<Timecard_Split__c> timecardSplitListtoUpdate = new List<Timecard_Split__c>();
        for(Id timecardId : timecardsMap.keySet()) {
            Timecard__c timecard = timecardsMap.get(timecardId);
            if(timecard.Start_Date__c.month() == timecard.End_Date__c.month()) {
                Timecard_Split__c timecardSplit = [SELECT Id, Start_Date__c, End_Date__c, Time_hours__c FROM Timecard_Split__c WHERE Timecard__c = :timecard.Id LIMIT 1];
                Decimal totalHours = 0;
                for(String fieldAPIName : fieldAPINameList) {
                    totalHours += (Decimal)timecard.get(fieldAPIName);
                }
                timecardSplit.Time_hours__c = totalHours;
                timecardSplitListtoUpdate.add(timecardSplit);
            }
            else {
                List<Timecard_Split__c> timecardSplitList = [SELECT Id, Start_Date__c, End_Date__c, Time_hours__c FROM Timecard_Split__c WHERE Timecard__c = :timecard.Id Order By Start_Date__c ASC];
                System.debug('timecardSplitList: ' + timecardSplitList);
                Timecard_Split__c timecardSplit1 = timecardSplitList[0];
                Decimal totalHours = 0;
                Integer i = 0;
                for(; i < timecardSplit1.Start_Date__c.daysBetween(timecardSplit1.End_Date__c) + 1; i++) {
                    totalHours += (Decimal)timecard.get(fieldAPINameList[i]);
                }
                timecardSplit1.Time_hours__c = totalHours;
                timecardSplitListtoUpdate.add(timecardSplit1);

                Timecard_Split__c timecardSplit2 = timecardSplitList[1];
                totalHours = 0;
                for(; i < fieldAPINameList.size(); i++) {
                    totalHours += (Decimal)timecard.get(fieldAPINameList[i]);
                }
                timecardSplit2.Time_hours__c = totalHours;
                timecardSplitListtoUpdate.add(timecardSplit2);
            }
        }
        Database.update(timecardSplitListtoUpdate);
    }
}