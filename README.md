![](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![iOS](https://img.shields.io/badge/os-iOS-green.svg?style=flat)
![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat)

# SwiftLoggerUI

Super basic UI to display logs sent using [SwiftLogger](https://github.com/krugazor/SwiftLoggerServer)

## "Manual"

Launch the app. Start as many servers as you want by creating new windows.

- If you use the filter functionality on the client side, make sure the name of your server matches the one the client will be looking for
- Make sure the passcodes match in the client and the server, otherwise the security of the connection (and the connection itself) will fail

You can filter the messages by level of severity.

Filtering by words is coming.

As previously stated it is extremely basic.

## Known bugs

Sometimes, the Bonjour/Zeroconf advertisement doesn't go away. The client tries to connect to something that doesn't exist anymore instead of your server. It tends to happen more on the local link (client and server on the same machine) than connecting to a remote instance, under investigation.

## License
[MIT Licence](/LICENSE)
