public with sharing class InvokeFromFlow {
    @InvocableMethod(label='Display Message Apex')
    public static void displayMessage(String[] messageList) {
        for(String message: messageList)
            System.debug('Apex Executed with input message as: ' + message);
    }
}