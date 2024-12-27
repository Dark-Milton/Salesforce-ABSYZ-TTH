@isTest
public with sharing class TestVerifyDate {
    @isTest
    public static void testDate() {
        Date date1 = Date.newInstance(2022, 1, 1);
        Date date2 = Date.newInstance(2022, 1, 15);
        Date date3 = Date.newInstance(2022, 2, 1);
        Date date4 = Date.newInstance(2022, 1, 31);
        Date date5 = Date.newInstance(2022, 2, 28);

        //positive test case
        System.assertEquals(date2, VerifyDate.CheckDates(date1, date2));

        //negative test case with date2 in the past
        System.assertEquals(date4, VerifyDate.CheckDates(date2, date1));

        //negative test case with date2 more than 30 days away
        System.assertEquals(date4, VerifyDate.CheckDates(date1, date5));
    }
}