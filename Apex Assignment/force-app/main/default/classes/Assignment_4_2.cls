public with sharing class Assignment_4_2 {
    public static String sumInFeetAndInches(Integer inches1, Integer inches2) {
        Integer sum = inches1 + inches2;
        return (sum/12) + ' feet ' + Math.mod(sum, 12) + ' inches';
    }
    public static String sumInKmAndMeters(Integer meters1, Integer meters2) {
        Integer sum = meters1 + meters2;
        return (sum/1000) + ' kilometers ' + Math.mod(sum, 1000) + ' meters';
    }
}