public with sharing class BootcampTask {
    public static void CharacterMatching() {
        String str1 = 'Apple';
        String str2 = 'Algae';
        Integer matchCount = 0;
        String[] str1Array = str1.toLowerCase().split('');
        // String[] strArray = str2.toLowerCase().split('');
        for(String str : str1Array) {
            if(str2.toLowerCase().contains(str)) {
                matchCount++;
            }
        }
        System.debug('No. of Matching Characters '+ matchCount);
    }
    public static void CarCount(Integer NoOfCarBody, Integer NoOfCarWheels, Integer NoOfPeople) {
        Integer carBody = NoOfCarBody/ 1;
        Integer carWheels = NoOfCarWheels/ 4;
        Integer people = NoOfPeople/ 2;
        // List<Integer> list1 = new List<Integer>{carBody, carWheels, people};
        // list1.sort();
        Integer NoOfCars = Math.min(Math.min(carBody, carWheels), people);
        // Integer NoOfCars = min(carBody, carWheels, people);
        System.debug('No. of Cars '+ NoOfCars);
    }
}