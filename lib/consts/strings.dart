const String kSaltDescription =
    'A salt is appended to your password before the hashing phase making it unique. It is highly recommended to use a random string of characters.';
const String kIterationCountDescription =
    'This decides how many times the password will be run through the hashing function.\n\nNote: Excessive number of iterations can take some time to finish because the function does not discriminate. Proceed with caution.';
const kNoPasswordStorageDescription =
    'Since Murmelpass does not store your passwords we cannot automagically verify that you typed it corectley.\n\nIf wrong password is entered here, wrong passwords will be outputted in app.';
