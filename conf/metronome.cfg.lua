-- Prosody XMPP Server Configuration
--
-- Information on configuring Prosody can be found on our
-- website at http://prosody.im/doc/configure
--
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running: prosodyctl check config
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- Good luck, and happy Jabbering!


---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see http://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.com", "user2@example.net" }
admins = { "focus__APP__@auth.__DOMAIN__" }
daemonize = true
cross_domain_bosh = true;
component_ports = { __PORT_COMPONENT__ }
--component_interface = "192.168.0.10"

-- Enable use of libevent for better performance under high load
-- For more information see: http://prosody.im/doc/libevent
--use_libevent = true

-- This is the list of modules Prosody will load on startup.
-- It looks for mod_modulename.lua in the plugins folder, so make sure that exists too.
-- Documentation on modules can be found at: http://prosody.im/doc/modules
modules_enabled = {

	-- Generally required
		"roster"; -- Allow users to have a roster. Recommended ;)
		"saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
		"tls"; -- Add support for secure TLS on c2s/s2s connections
		"dialback"; -- s2s dialback support
		"disco"; -- Service discovery
		"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.

	-- Not essential, but recommended
		"private"; -- Private XML storage (for room bookmarks, etc.)
		"vcard"; -- Allow users to set vCards

	-- These are commented by default as they have a performance impact
		--"privacy"; -- Support privacy lists
		"compression"; -- Stream compression (requires the lua-zlib package installed)

	-- Nice to have
		"version"; -- Replies to server version requests
		"uptime"; -- Report how long server has been running
		"time"; -- Let others know the time here on this server
		"ping"; -- Replies to XMPP pings with pongs
		"pep"; -- Enables users to publish their mood, activity, playing music and more
		"register"; -- Allow users to register on this server using a client and change passwords

	-- Admin interfaces
		"admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
		--"admin_telnet"; -- Opens telnet console interface on localhost port 5582

	-- HTTP modules
		"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
		--"http_files"; -- Serve static files from a directory over HTTP

	-- Other specific functionality
		--"groups"; -- Shared roster support
		--"announce"; -- Send announcement to all online users
		--"welcome"; -- Welcome users who register accounts
		--"watchregistrations"; -- Alert admins of registrations
		--"motd"; -- Send a message to users when they log in
		--"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
	-- jitsi
		"smacks";
		"carbons";
		"mam";
		"lastactivity";
		"offline";
		"pubsub";
		"adhoc";
		"websocket";
		"http_altconnect";
}

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
	-- "offline"; -- Store offline messages
	-- "c2s"; -- Handle client connections
	-- "s2s"; -- Handle server-to-server connections
}

-- Disable account creation by default, for security
-- For more information see http://prosody.im/doc/creating_accounts
allow_registration = false

-- These are the SSL/TLS-related settings. If you don't want
-- to use SSL/TLS, you may comment or remove this
-- ssl = {
--    key = "/etc/prosody/certs/localhost.key";
--    certificate = "/etc/prosody/certs/localhost.crt";
--}

-- Force clients to use encrypted connections? This option will
-- prevent clients from authenticating unless they are using encryption.

-- c2s_require_encryption = true

-- Force certificate authentication for server-to-server connections?
-- This provides ideal security, but requires servers you communicate
-- with to support encryption AND present valid, trusted certificates.
-- NOTE: Your version of LuaSec must support certificate verification!
-- For more information see http://prosody.im/doc/s2s#security

-- s2s_secure_auth = false

-- Many servers don't support encryption or have invalid or self-signed
-- certificates. You can list domains here that will not be required to
-- authenticate using certificates. They will be authenticated using DNS.

--s2s_insecure_domains = { "gmail.com" }

-- Even if you leave s2s_secure_auth disabled, you can still require valid
-- certificates for some domains by specifying a list here.

--s2s_secure_domains = { "jabber.org" }

-- Required for init scripts and prosodyctl
-- pidfile = "/var/run/prosody/prosody.pid"

-- Select the authentication backend to use. The 'internal' providers
-- use Prosody's configured data storage to store the authentication data.
-- To allow Prosody to offer secure authentication mechanisms to clients, the
-- default provider stores passwords in plaintext. If you do not trust your
-- server please see http://prosody.im/doc/modules/mod_auth_internal_hashed
-- for information about using the hashed backend.

-- authentication = "internal_plain"
authentication = "internal_hashed"

-- Select the storage backend to use. By default Prosody uses flat files
-- in its configured data directory, but it also supports more backends
-- through modules. An "sql" backend is included by default, but requires
-- additional dependencies. See http://prosody.im/doc/storage for more info.

--storage = "sql" -- Default is "internal"

-- For the "sql" backend, you can uncomment *one* of the below to configure:
--sql = { driver = "SQLite3", database = "prosody.sqlite" } -- Default. 'database' is the filename.
--sql = { driver = "MySQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }
--sql = { driver = "PostgreSQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }

-- Logging configuration
-- For advanced logging see http://prosody.im/doc/logging
-- log = {
-- 	info = "/var/log/prosody/prosody.log"; -- Change 'info' to 'debug' for verbose logging
-- 	error = "/var/log/prosody/prosody.err";
-- 	"*syslog";
-- }

----------- Virtual hosts -----------
-- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
-- Settings under each VirtualHost entry apply *only* to that host.

--VirtualHost "localhost"

VirtualHost "__DOMAIN__"
	-- enabled = false -- Remove this line to enable this host
	authentication = "anonymous"
	-- Assign this host a certificate for TLS, otherwise it would use the one
	-- set in the global section (if any).
	-- Note that old-style SSL on port 5223 only supports one certificate, and will always
	-- use the global one.
	ssl = {
		key = "/etc/yunohost/certs/__DOMAIN__/key.pem";
		certificate = "/etc/yunohost/certs/__DOMAIN__/crt.pem";
	}

	c2s_require_encryption = false

VirtualHost "auth.__DOMAIN__"
	ssl = {
		key = "/etc/yunohost/certs/auth.__DOMAIN__/key.pem";
		certificate = "/etc/yunohost/certs/auth.__DOMAIN__/crt.pem";
	}
	authentication = "ldap2"
	ldap = {
		hostname      = "localhost",
		user = {
			basedn        = "ou=users,dc=yunohost,dc=org",
			filter        = "(&(objectClass=posixAccount)(mail=*@auth.__DOMAIN__))",
			usernamefield = "mail",
			namefield     = "cn",
		},
	}

------ Components ------
-- You can specify components to add hosts that provide special services,
-- like multi-user conferences, and transports.
-- For more information on components, see http://prosody.im/doc/components

---Set up a MUC (multi-user chat) room server on conference.example.com:
--Component "conference.example.com" "muc"

-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers:
--Component "proxy.example.com" "proxy65"

---Set up an external component (default component port is 5347)
--
-- External components allow adding various services, such as gateways/
-- transports to other networks like ICQ, MSN and Yahoo. For more info
-- see: http://prosody.im/doc/components#adding_an_external_component
--
--Component "gateway.example.com"
--	component_secret = "password"

Component "conference.__DOMAIN__" "muc"

Component "jitsi-videobridge.__DOMAIN__"
    component_secret = "__VIDEOBRIDGE_SECRET__"
Component "focus.__DOMAIN__"
    component_secret = "__FOCUS_SECRET__"
