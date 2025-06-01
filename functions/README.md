firebase deploy --only functions
firebase emulators:start --only functions

test

tsc
firebase deploy --only functions

