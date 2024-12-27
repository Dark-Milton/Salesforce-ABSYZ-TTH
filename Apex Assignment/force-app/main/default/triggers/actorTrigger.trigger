trigger actorTrigger on Actor__c (after insert, after update) {

    List<Actor__Share> sharesToInsert = new List<Actor__Share>();
    List<Id> recordIdsToDelete = new List<Id>();

    for (Actor__c actorRecord : Trigger.new) {
        if (actorRecord.User__c != null || (Trigger.isUpdate && Trigger.oldMap.get(actorRecord.Id).User__c != null)) {
            if (Trigger.isUpdate && actorRecord.User__c != Trigger.oldMap.get(actorRecord.Id).User__c) {
                recordIdsToDelete.add(actorRecord.Id);
            }

            Actor__Share newShare = new Actor__Share();
            newShare.ParentId = actorRecord.Id;
            newShare.UserOrGroupId = actorRecord.User__c;
            newShare.AccessLevel = 'Edit';
            newShare.RowCause = Schema.Actor__Share.RowCause.Manual;
            sharesToInsert.add(newShare);
        }
    }

    if (!recordIdsToDelete.isEmpty()) {
        List<Actor__Share> sharesToDelete = [
            SELECT Id FROM Actor__Share
            WHERE ParentId IN :recordIdsToDelete
            AND RowCause = :Schema.Actor__Share.rowCause.Manual
        ];
        delete sharesToDelete;
    }

    if (!sharesToInsert.isEmpty()) {
        try {
            insert sharesToInsert;
        } catch (DmlException e) {
            System.debug('Error creating Actor__Share records: ' + e.getMessage());
        }
    }
}