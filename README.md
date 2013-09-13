Serendipity
===========

Take a leap of faith and make a random call! Serendipity is an app that randomly chooses a contact in your phone's address book---and then starts a phone call! 

This page is where you can find the full source code for Serendipity. That's right: the whole source code for *free*. Feel free to have a look how it all works, verify my claim that none of your contacts or private data are sent to the NSA, build it yourself, modify it, and even make a derivative app of your own!

### How it works

It's a very straightforward app, with little in the way of complicated features, but here's a quick explanation of the important parts of what happens when you run the app and then tap the big button:

1. On opening the main view, the app builds a list of all the contacts in the address book, including the phone number and what type of phone it is.
2. Contacts without the allowed kinds of phone, and blocked contacts (see the settings view) are filtered before adding to the list.
3. When the button is tapped, the app calls random() to pick from the previously-built list.
4. After the user hits "Yes", it opens the Phone.app by using the UIApplication openURL method.

This is basically it. Most of the complicated parts are just interfacing with the CoreFoundation-based AddressBook framework - which is easily handled by appropriate use of (__bridge_transfer NSString*) casting.

### License

Serendipity is licensed under the MIT License (MIT)

Copyright (c) 2013 Josh Deprez.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
