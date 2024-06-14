# IES Webnode

The IES webnode is a server application that is installed on all web servers that deliver websites managed by the IES (Sitepark's content management system). The IES webnode serves as the "long arm" of the IES and represents the interface between the IES and the web servers. The IES webnode is used, for example, to deploy the web applications that are required to operate the websites.

## Start and stop

The IES webnode is started and stopped via the `systemd` service manager. The service is called `ies-webnode`.

Start the IES webnode:

```sh
sudo systemctl start ies-webnode
```

Stop the IES webnode:

```sh
sudo systemctl stop ies-webnode
```

## Update

The update file for the IES-Webnode is transferred via the IES on the web server when an update is initiated from the IES.

The update must then be installed manually on the web server. To do this, the update script is executed on the web server.

```sh
sudo systemctl stop ies-webnode
sudo ies-webnode update
sudo systemctl start ies-webnode
```

## Logs

The IES-Webnode logs are stored in the directory `/var/log/sitepark/ies-webnode/`.

## JWT Keys

The IES webnode provides a private and a public key with which the PHP applications can sign and verify JWTs. The keys are stored outside the web applications and are therefore retained even when the applications are updated.

The keys are stored in the file `/srv/sitepark/ies-webnode/config/jwt`.

## Realm-Properties-File

The `realm.properties` file is used for simple user administration. A user `api` with a randomly generated password is stored there during installation. The IES authenticates itself to the IES Webnode via this user.

The file is stored in the directory `/srv/sitepark/ies-webnode/config/`.

### Format of the file

The `realm.properties` file consists of key-value pairs, each of which defines a user and their associated properties. The file uses the simple text format and typically looks like this:

```properties
# Comments start with a #
# Custom entries consist of username, password and roles

# Username: user
# Password: password
# Roles: role1, role2
user=password,role1,role2

# Example:
api=password,api
admin=password,api,admin
user1=password,user
```

Explanation of the individual parts

1. **Comments**: Lines beginning with a # are comments and are ignored by the system.
2. **User-defined entries**: Each entry in the file defines a user.
   The user name precedes the `=`. The `=` is followed by the password and the roles, separated by commas.
