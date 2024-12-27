public with sharing class StringListTest {
    public static List<String> generateStringList(Integer count) {
        List<String> stringList = new List<String>();
        for(Integer i = 0; i < count; i++) {
            stringList.add('Test ' + i);
        }
        return stringList;
    }
}