public with sharing class Assignment_4_5 {
    public static String gameResult(String Player_1, String Player_2) {
        if(Player_1 == Player_2) {
            return 'TIE';
        } else if((Player_1 == 'Rock' && Player_2 == 'Scissor') || (Player_1 == 'Scissor' && Player_2 == 'Paper') || (Player_1 == 'Paper' && Player_2 == 'Rock')) {
            return 'Player 1 Wins';
        } else {
            return 'Player 2 Wins';
        }
    }
    public static void stringOperations(String input) {
        System.debug('Input in Uppercase: ' + input.toUpperCase());
        if (input.contains('value')) System.debug('Invalid String');
        input += ' Work for Absyz';
        System.debug('Concatenated String: ' + input);
    }
    public static void arrayTask() {
        Integer[] integerArray = new Integer[]{10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
        for (Integer i=integerArray.size()-1; i>=0; i--) {
            System.debug(integerArray[i]);         
        }
    }
    public static void displayDate() {
        System.debug('Current Date and Time: ' + Datetime.now());    
        System.debug('Date 5 days from now: ' + Date.today().addDays(5));    
        System.debug('Date 5 months from now: ' + Date.today().addMonths(5));    
    }
    public static void CarCount(Integer NoOfCarBody, Integer NoOfCarWheels, Integer NoOfPeople) {
        Integer carBody = NoOfCarBody/ 1;
        Integer carWheels = NoOfCarWheels/ 4;
        Integer people = NoOfPeople/ 2;
        Integer NoOfCars = Math.min(Math.min(carBody, carWheels), people);
        System.debug('No. of Cars '+ NoOfCars);
    }
    public static Integer[] strictlyGreaterElement(Integer[] numberArray) {
        Integer[] resultArray = new Integer[]{};

        for(Integer i=1; i<=numberArray.size()-2; i++) {
            if(numberArray[i] > numberArray[i-1] && numberArray[i] > numberArray[i+1]) resultArray.add(numberArray[i]); 
        }

        return resultArray;
    }
    public static void CharacterMatching(String str1, String str2) {
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
    public static void boxPattern(Integer n) {
        for(Integer i =0; i<n; i++) {
            for(Integer j=0; j<n; j++) {
                if(i==0 || i==n-1 || j==0 || j==n-1) System.debug('*');
                else System.debug(' ');
            }    
        }
    }
}