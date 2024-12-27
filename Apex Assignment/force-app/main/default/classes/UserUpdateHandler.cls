public with sharing class UserUpdateHandler {
    @Future
    public static void updateUser(String username) {
        User user = [Select Id, Name, Email, Username from User where Username = 'timsmith@absyz.sandbox' LIMIT 1];
        user.Username = username;
        Database.update(user);
    }
}