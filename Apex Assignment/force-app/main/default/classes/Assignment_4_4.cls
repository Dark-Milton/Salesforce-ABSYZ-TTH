public with sharing class Assignment_4_4 {
    public static Boolean stringOperations(String input) {
        if(input.length() == 0) return null;
        if(input.contains('Test')) return true;
        if(input == 'Salesforce') return true;
        return false;
    }
}