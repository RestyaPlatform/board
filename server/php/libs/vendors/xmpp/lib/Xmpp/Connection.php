<?php

namespace Xmpp;

use DOMElement;
use Psr\Log\LoggerInterface;
use SimpleXMLElement;
use Xmpp\Exception\StreamException;
use Xmpp\Exception\XmppException;

/**
 * Xmpp is an implementation of the Xmpp protocol. Note that creating the class
 * does not connect to the server specified in the constructor. You need to call
 * connect() to actually perform the connection.
 *
 * @todo Store what features are available when session is established
 * @todo Handle error conditions of authenticate, bind, connect and
 *         establishSession
 * @todo Throw exceptions when attempting to perform actions that the server has
 *         not reported that they support.
 * @todo ->wait() method should return a class that encapsulates what has come
 *         from the server. e.g. Message Iq Xmpp_Presence
 */
class Connection
{
    const PRESENCE_AWAY = 'away';
    const PRESENCE_CHAT = 'chat';
    const PRESENCE_DND  = 'dnd';
    const PRESENCE_XA   = 'xa';

    /**
     * Time interval of usleep() when waiting server responses.
     *
     * @var int
     */
    const USLEEP_TIME = 5;

    /**
     * Host name of the server to connect to
     *
     * @var string
     */
    protected $host;

    /**
     * Holds the port of the server to connect to
     *
     * @var int
     */
    protected $port;

    /**
     * Whether or not this connection to switch SSL when it is available.
     *
     * @var boolean
     */
    protected $ssl = true;

    /**
     * Holds the username used for authentication with the server
     *
     * @var string
     */
    protected $username;

    /**
     * Holds the password of the user we are going to connect with
     *
     * @var string
     */
    protected $password;

    /**
     * Holds the resource for the connection. Will be something like a machine
     * name or a location to identify the connection.
     *
     * @var string
     */
    protected $resource;

    /**
     * Holds the "realm" of the user name. Usually refers to the domain in the
     * user name.
     *
     * @var string
     */
    protected $realm;

    /**
     * Holds the Stream object that performs the actual connection to the server
     *
     * @var Stream
     */
    protected $stream;

    /**
     * @var bool
     */
    protected $blockingMode = true;

    /**
     * @var array
     */
    protected $mechanisms = array();

    /**
     * List of items available on the server
     *
     * @var array
     */
    protected $items = array();

    /**
     * Holds an array of rooms that have been joined on this connection.
     *
     * @var array
     */
    protected $joinedRooms = array();

    /**
     * Holds the buffer of incoming tags
     *
     * @var array
     */
    protected $buffer = array();

    /**
     * @var SimpleXMLElement
     */
    protected $lastResponse;

    /**
     * @var int
     */
    protected $id;

    /**
     * @var string
     */
    protected $mucServer;

    /**
     * Class that performs logging
     *
     * @var LoggerInterface
     */
    protected $logger;

    /**
     * Class constructor.
     *
     * @param string $username Username to authenticate with.
     * @param string $password Password to authenticate with.
     * @param string $host Host name of the server to connect to.
     * @param boolean $ssl Whether or not to connect over SSL if it is available.
     * @param int $port Port to use for the connection.
     * @param string $resource Identifier of the connection.
     * @param LoggerInterface $logger
     * @todo Logger can not be optional.
     */
    public function __construct(
        $username,
        $password,
        $host,
        $ssl = true,
        $port = 5222,
        $resource = 'NewXmpp',
        LoggerInterface $logger = null
    ) {
        list($this->username, $this->realm) = array_pad(explode('@', $username), 2, null);

        $this->host     = $host;
        $this->password = $password;
        $this->port     = $port;
        $this->ssl      = $ssl;
        $this->resource = $resource;
        $this->logger   = $logger;
    }

    /**
     * Class destructor. Will try and close the connection if it is open.
     */
    public function __destruct()
    {
        $this->disconnect();
    }

    /**
     * Authenticate against server with the stored username and password.
     *
     * Note only PLAIN and DIGEST-MD5 authentication are supported.
     *
     * @return boolean
     * @throws XmppException
     */
    public function authenticate()
    {
        if ($this->mechanismAvailable('PLAIN')) {
            $message =
                '<auth xmlns="urn:ietf:params:xml:ns:xmpp-sasl" mechanism="PLAIN">' .
                base64_encode("\x00" . $this->username . "\x00" . $this->password) .
                '</auth>'
            ;
            $this->stream->send($message);
            $response = $this->waitForServer('success');

            $this->logResponse($response, 'Auth response (PLAIN)');

            if (!($response instanceof SimpleXMLElement) && empty($response)) {
                throw new XmppException('PLAIN authentication failed.');
            }
        } elseif ($this->mechanismAvailable('DIGEST-MD5')) {
            // Send message to the server that we want to authenticate
            $message = "<auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' "
                . "mechanism='DIGEST-MD5'/>";
            //$this->logger->debug('Requesting Authentication: ' . $message);
            $this->stream->send($message);

            // Wait for challenge to come back from the server
            $response = $this->waitForServer('challenge');
            $this->logResponse($response, 'Challenge response');

            // Decode the response
            $decodedResponse = base64_decode((string) $response);
            $this->logResponse($response, 'Decoded response');

            // Split up the parts of the challenge
            $challengeParts = explode(',', $decodedResponse);

            // Create an array to hold the challenge
            $challenge = array();

            // Process the parts and put them into the array for easy access
            foreach ($challengeParts as $part) {
                list($key, $value) = explode('=', trim($part), 2);
                $challenge[$key] = trim($value, '"');
            }

            // Ejabberd Doesn't appear to send the realm in the challenge, so
            // we need to default to what we think the realm is.
            if (!isset($challenge['realm'])) {
                $challenge['realm'] = $this->realm;
            }

            $cnonce = uniqid();
            $a1 =
                pack('H32', md5($this->username . ':' . $challenge['realm'] . ':' . $this->password)) .
                ':' . $challenge['nonce'] . ':' . $cnonce
            ;

            $a2 = 'AUTHENTICATE:xmpp/' . $challenge['realm'];
            $ha1 = md5($a1);
            $ha2 = md5($a2);
            $kd = $ha1 . ':' . $challenge['nonce'] . ':00000001:'
                . $cnonce . ':' . $challenge['qop'] . ':' . $ha2;
            $z = md5($kd);

            // Start constructing message to send with authentication details in it.
            $message =
                'username="' . $this->username . '",'
                . 'realm="' . $challenge['realm'] . '",'
                . 'nonce="' . $challenge['nonce'] . '",'
                . 'cnonce="' . $cnonce . '",nc="00000001",'
                . 'qop="' . $challenge['qop'] . '",'
                . 'digest-uri="xmpp/' . $challenge['realm'] . '",'
                . 'response="' . $z . '",'
                . 'charset="' . $challenge['charset'] . '"'
            ;
            //$this->logger->debug('Unencoded Response: ' . $message);
            $message = "<response xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>" . base64_encode($message) . '</response>';

            // Send the response
            //$this->logger->debug('Challenge response: ' . $message);
            $this->stream->send($message);

            // Should get another challenge back from the server. Some servers
            // don't bother though and just send a success back with the
            // rspauth encoded in it.
            $response = $this->waitForServer('*');
            $this->logResponse($response, 'Challenge response from server');

            // If we have got a challenge, we need to send a response, blank this time.
            if ($response->getName() == 'challenge') {
                $message = "<response xmlns='urn:ietf:params:xml:ns:xmpp-sasl'/>";

                // Send the response
                //$this->logger->debug('Challenge Response: ' . $message);
                $this->stream->send($message);

                // This time we should get a success message.
                $response = $this->waitForServer('success');
                $this->logResponse($response, 'Challenge success response from server');
            }
        } else {
            throw new XmppException('No implmented authentication mechanisms defined.');
        }

        // Now that we have been authenticated, a new stream needs to be started.
        $this->startStream();

        // Server should now respond with start of stream and list of features
        $response = $this->waitForServer('stream:stream');
        $this->logResponse($response, 'XMPP start of stream');

        // If the server has not yet said what features it supports, wait for that.
        if ($response && (strpos($response->asXML(), 'stream:features') === false)) {
            $response = $this->waitForServer('stream:features');
            $this->logResponse($response, 'XMPP list of features');
        }
    }

    /**
     * Checks if a given authentication mechanism is available.
     *
     * @param string $mechanism Mechanism to check availability for.
     * @return boolean
     */
    protected function mechanismAvailable($mechanism)
    {
        return array_key_exists($mechanism, $this->mechanisms);
    }

    /**
     * Waits for the server to send the specified tag back.
     *
     * @param string $tag Tag to wait for from the server.
     * @return SimpleXMLElement|false
     * @todo Make it protected if possbile.
     */
    public function waitForServer($tag)
    {
        //$this->logger->debug("Tag we're waiting for: " . $tag);

        $fromServer = false;

        // If there is nothing left in the buffer, wait for the stream to update
        if (count($this->buffer) == 0 && $this->stream->select() > 0) {
            $response = '';
            $done     = false;

            while (!$done) {
                // Read data from the connection.
                $response .= $this->stream->read(4096);
                if ($this->stream->select() == 0) {
                    $done = true;
                } else {
                    usleep(self::USLEEP_TIME);
                }
            }

            //$this->logger->debug('Response after while loop (\Xmpp\Connection): ' . $response);

            // If the response isn't empty, load it into a SimpleXML element
            if (trim($response) != '') {
                // If the response from the server starts (where "starts
                // with" means "appears after the xml prologue if one is
                // present") with "<stream:stream and it doesn't have a
                // closing "</stream:stream>" then we should append one so
                // that it can be easily loaded into a SimpleXMLElement,
                // otherwise it will cause an error to be thrown because of
                // malformed XML.
                // Check if response starts with XML Prologue:
                if (preg_match("/^<\?xml version='1.0'( encoding='UTF-8')?\?>/", $response, $matches) == 1) {
                    $offset = strlen($matches[0]);
                    $prologue = $matches[0];
                } else {
                    $offset = 0;
                }

                // Check if first part of the actual response starts with <stream:stream
                if (strpos($response, '<stream:stream ') === $offset) {
                    // If so, append a closing tag
                    $response .= '</stream:stream>';
                }

                // For consistent handling and correct stream namespace
                // support, we should wrap all responses in the
                // stream:stream tags to make sure everything works as
                // expected. Unless the response already contains such tags.
                if (strpos($response, '<stream:stream') === false) {
                    $response = '<stream:stream '
                        . 'xmlns:stream="http://etherx.jabber.org/streams" '
                        . "xmlns:ack='http://www.xmpp.org/extensions/xep-0198.html#ns' "
                        . 'xmlns="jabber:client" '
                        . 'from="' . $this->realm . '" '
                        . 'xml:lang="en" version="1.0">'
                        . $response . '</stream:stream>';
                }

                // If the xml prologue should be at the start, move it
                // because it will now be in the wrong place. We can assume
                // if $offset is not 0 that there was a prologue.
                if ($offset != 0) {
                    $response = $prologue
                        . str_replace($prologue, '', $response);
                }

                $xml = simplexml_load_string($response);

                // If we want the stream element itself, just return that, otherwise check the contents of the stream.
                if ($tag == 'stream:stream') {
                    $fromServer = $xml;
                } elseif (($xml instanceof SimpleXMLElement) && in_array($xml->getName(), array('stream'))) {
                    // Get the namespaces used at the root level of the
                    // document. Add a blank namespace on for anything that
                    // isn't namespaced. Then we can iterate over all of the
                    // elements in the doc.
                    $namespaces = $xml->getNamespaces();
                    $namespaces['blank'] = '';
                    foreach ($namespaces as $namespace) {
                        foreach ($xml->children($namespace) as $child) {
                            if ($child instanceof SimpleXMLElement) {
                                $this->buffer[] = $child;
                            }
                        }
                    }
                } else {
                    //$this->logger->debug("Revised XMPP response is invalid: {$response}.");
                }
            } else {
                //$this->logger->debug("We're waiting for tag '{$tag}', but the response is blank.");
            }
        } else {
            //$this->logger->debug("Tag we're waiting for '{$tag}' not presenting.");
        }

        //$this->logger->debug('Contents of $fromServer: ' . var_export($fromServer, true));
        //$this->logger->debug('Contents of $this->buffer before foreach: ' . var_export($this->buffer, true));

        // Now go over what is in the buffer and return anything necessary
        foreach ($this->buffer as $key => $stanza) {
            // Only bother looking for more tags if one has not yet been found.
            if ($fromServer === false) {
                // Remove this element from the buffer because we do not want it to be processed again.
                unset($this->buffer[$key]);

                // If this the tag we want, save it for returning.
                if (in_array($tag, array('*', $stanza->getName()))) {
                    $fromServer = $stanza;
                }
            }
        }

        //$this->logger->debug('Contents of $this->buffer after foreach: ' . var_export($this->buffer, true));

        return $fromServer;
    }

    /**
     * Starts an XMPP connection.
     *
     * @return void
     */
    protected function startStream()
    {
        $message = '<stream:stream to="' . $this->host . '" '
            . 'xmlns:stream="http://etherx.jabber.org/streams" '
            . 'xmlns="jabber:client" version="1.0">';
        $this->stream->send($message);
        //$this->logger->debug('Stream started.');
    }

    /**
     * Bind this connection to a particular resource (the last part of the JID)
     *
     * @return void
     */
    public function bind()
    {
        // Need to bind the resource with the server
        $message = "<iq type='set' id='bind_2'>"
            . "<bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'>"
            . '<resource>' . $this->resource . '</resource>'
            . '</bind></iq>';
        //$this->logger->debug('Bind request: ' . $message);
        $this->stream->send($message);

        // Should get an iq response from the server confirming the jid
        $response = $this->waitForServer('*');
        $this->logResponse($response, 'Binding response');
    }

    /**
     * Connects to the server and upgrades to TLS connection if possible.
     *
     * @return void
     * @throws XmppException
     */
    public function connect()
    {
        try {

            // Get a connection to server
            $this->stream = $this->getStream();
            //$this->logger->debug('Connection made');

            // Attempt to send the stream start
            $this->startStream();

            //$this->logger->debug('Wait for response from server');

            // Now we will expect to get a stream tag back from the server. Not
            // sure if we're supposed to do anything with it, so we'll just drop
            // it for now. May contain the features the server supports.
            $response = $this->waitForServer('stream:stream');
            $this->logResponse($response, 'Stream tag received');

            if (!$response) {
                //$this->logger->critical('XMPP server does not send stream tag response back.');
                return;
            }

            // If the response from the server does contain a features tag, don't
            // bother querying server to get it.
            // TODO - Xpath would probably be more sensible for this, but for
            // now this'll work.
            if (strpos($response->asXml(), '<stream:features') === false) {
                // Server should now send back a features tag telling us what
                // features it supports. If it tells us to start tls then we will
                // need to change to a secure connection. It will also tell us what
                // authentication methods it supports.
                //
                // Note we check for a "features" tag rather than stream:features because it is namespaced.
                $response = $this->waitForServer('features');
                $this->logResponse($response, 'Features received');
            }

            // Set mechanisms based on that tag
            $this->setMechanisms($response);
            // @see http://tools.ietf.org/html/rfc3920#section-4 XMPP core: XML Streams
            $this->setId($response['id']); //TODO what if ID doesn't exist

            // If there was a starttls tag in there, and this connection has SSL
            // enabled, then we should tell the server that we will start up tls as
            // well.
            if ($response->xpath("//*[local-name()='starttls']") && $this->ssl === true) {
                //$this->logger->debug('Informing server we will start TLS');
                $message = "<starttls xmlns='urn:ietf:params:xml:ns:xmpp-tls'/>";
                $this->stream->send($message);

                // Wait to get the proceed message back from the server
                $response = $this->waitForServer('proceed');
                $this->logResponse($response, 'Proceed response');

                // Once we have the proceed signal from the server, we should turn
                // on TLS on the stream and send the opening stream tag again.
                $this->stream->setTLS(true);
                //$this->logger->debug('Enabled TLS');

                // Now we need to start a new stream again.
                $this->startStream();

                // Server should now respond with start of stream and list of features
                $response = $this->waitForServer('stream:stream');
                $this->logResponse($response, 'Start of stream response');

                // Set mechanisms based on that tag
                $this->setMechanisms($response);
            }
        } catch (StreamException $e) {
            // A Stream Exception occured. Catch it and rethrow it as an Xmpp Exception.
            throw new XmppException('Failed to connect: ' . $e->getMessage());
        }
    }

    /**
     * @param int $id
     * @return $this
     */
    protected function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    /**
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @return string
     */
    public function getMucServer()
    {
        return $this->mucServer;
    }

    /**
     * Get the server this class should connect to.
     *
     * @return string
     */
    protected function getServer()
    {
        return 'tcp://' . $this->host . ':' . $this->port;
    }

    /**
     * Gets a Stream object that encapsulates the actual connection to the server.
     *
     * @return Stream
     */
    public function getStream()
    {
        if (empty($this->stream)) {
            $this->stream = new Stream($this->getServer(), null, null, null, $this->logger);

            $this->stream->setBlocking($this->blockingMode);
            //$this->logger->debug(sprintf(
                //'Blocking mode on the stream %s.',
//                ($this->blockingMode ? 'enabled' : 'disabled')
            //));
        }

        return $this->stream;
    }

    /**
     * Take the given features tag and figure out what authentication mechanisms are supported from it's contents.
     *
     * @param SimpleXMLElement $features <stream:features> saying what server supports.
     * @return void
     */
    protected function setMechanisms(SimpleXMLElement $features)
    {
        $matches = array();
        $pattern = '/<stream:features.*(<mechanisms.*<\/mechanisms>).*<\/stream:features>/';

        /**
         * A response containing a stream:features tag should have been passed in. The tag contain a mechanisms tag.
         * Find the mechanisms tag and load it into a SimpleXMLElement object.
         */
        if (preg_match($pattern, $features->asXml(), $matches)) {
            $this->mechanisms = array();

            $xml = simplexml_load_string($matches[1]);

            foreach ($xml->children() as $child) {
                $this->mechanisms[(string) $child] = null;
            }
        }
    }

    /**
     * Disconnect from the server.
     *
     * @return void
     */
    public function disconnect()
    {
        if (!is_null($this->stream) && $this->stream->isConnected()) {
            $this->stream->send('</stream:stream>');
            $this->stream->disconnect();
            //$this->logger->debug('Disconnected.');
        }
    }

    /**
     * Establish the start of a session.
     *
     * @return boolean
     */
    public function establishSession()
    {
        // Send message requesting start of session.
        $message ='<iq type="set" id="sess_1" to="' . $this->realm .
            '"><session xmlns="urn:ietf:params:xml:ns:xmpp-session"></session></iq>'
        ;
        $this->stream->send($message);

        // Should now get an iq in response from the server to say the session was established.
        $response = $this->waitForServer('iq');
        $this->logResponse($response, 'Session establishing response');

    }

    /**
     * Get the last response as an instance of \Xmpp\Iq.
     *
     * @return Iq
     * @throws XmppException
     */
    public function getIq()
    {
        if ((string) $this->lastResponse->getName() != 'iq') {
            throw new XmppException('Last stanza received was not an iq stanza');
        }

        return new Iq($this->lastResponse);
    }

    /**
     * Get the last response an an instance of \Xmpp\Message.
     *
     * @return Message
     * @throws XmppException
     */
    public function getMessage()
    {
        if ((string) $this->lastResponse->getName() != 'message') {
            throw new XmppException('Last stanza received was not a message');
        }

        return new Message($this->lastResponse);
    }

    /**
     * Set the presence of the user.
     *
     * @param string $status Custom status string
     * @param string $show Current state of user, e.g. away, do not disturb
     * @param int $priority Presence priority
     * @return void
     * @todo Allow multiple statuses to be entered
     */
    public function presence($status = null, $show = null, $priority = null)
    {
        if (is_null($status) && is_null($show) && is_null($priority)) {
            $message = '<presence/>';
        } else {
            $message = "<presence xml:lang='en'>";

            if (!is_null($status)) {
                $message .= '<status>' . $status . '</status>';
            }

            if (!is_null($show)
                && ($show == self::PRESENCE_AWAY
                    || $show == self::PRESENCE_CHAT || $show == self::PRESENCE_DND
                    || $show == self::PRESENCE_XA)
            ) {
                $message .= '<show>' . $show . '</show>';
            }

            if (!is_null($priority) && is_int($priority)) {
                $message .= '<priority>' . $priority . '</priority>';
            }

            $message .= '</presence>';
        }
        $this->stream->send($message);

        $response = $this->waitForServer('*');
        $this->logResponse($response, 'XMPP presence response');
    }

    /**
     * Wait for the server to respond.
     *
     * @param string $tag
     * @return SimpleXMLElement|null
     * @todo Get this to return after a timeout period if nothing has come back
     * @todo delete this one if useless.
     */
    public function wait($tag = '*')
    {
        return ($this->waitForServer($tag) ?: null); // Wait for a tag to be sent by the server
    }

    /**
     * Check if server supports the Multi-User Chat extension.
     *
     * @return boolean
     */
    public function isMucSupported()
    {
        // If items is empty then we haven't yet asked the server what items are
        // associated with it. Query the server for what items are available.
        if (empty($this->items)) {
            $this->discoverItems();
        }

        // Iterate over the items and the main server to ask if MUC is supported
        $items = $this->items;
        $items[] = array('jid' => $this->realm);

        foreach ($items as $item) {
            // Send iq stanza asking if this server supports MUC.
            $message = "<iq from='" . $this->username . '@' . $this->realm . '/'
                . $this->resource . "' id='disco1' "
                . "to='" . $item['jid'] . "' type='get'>"
                . "<query xmlns='http://jabber.org/protocol/disco#info'/>"
                . "</iq>";
            $this->stream->send($message);
            //$this->logger->debug('Querying for MUC support');

            // Wait for iq response
            $response = false;
            while (!$response) {
                $response = $this->waitForServer('iq');
            }
            $this->logResponse($response, 'Info discovered response');

            // Check if feature tag with appropriate var value is in response. If it is, then MUC is supported
            if (isset($response->query)) {
                foreach ($response->query->children() as $feature) {
                    if ($feature->getName() == 'feature'
                        && isset($feature->attributes()->var)
                        && $feature->attributes()->var == 'http://jabber.org/protocol/muc'
                    ) {
                        $this->mucServer = $item['jid'];

                        return true;
                    }
                }
            }
        }

        return false;
    }

    /**
     * Discovers what items (basically features) are available on the server.
     *
     * @return void
     */
    protected function discoverItems()
    {
        // Send IQ stanza asking server what items are associated with it.
        $message =
            "<iq from='" . $this->username . '@' . $this->realm . '/'
            . $this->resource . "' id='" . uniqid() . "' "
            . "to='" . $this->realm . "' type='get'>"
            . "<query xmlns='http://jabber.org/protocol/disco#items'/>"
            . '</iq>'
        ;
        $this->stream->send($message);
        //$this->logger->debug('Querying for available services');

        // Wait for iq response
        $response = false;
        while (!$response || $response->getName() != 'iq' || strpos($response->asXml(), '<item') === false) {
            $response = $this->waitForServer('iq');
        }
        $this->logResponse($response, 'Items discovery response');

        if (!$response) {
            $this->logger->critical('XMPP server does not send back valid resonses for "disco#items".');
            return;
        }

        // Check if query tag is in response. If it is, then iterate over the children to get the items available.
        $this->items = $this->items ?: array();
        if (isset($response->query)) {
            foreach ($response->query->children() as $item) {
                if (($item->getName() == 'item') && isset($item->attributes()->jid)) {
                    $this->items[] = array(
                        'jid'  => $item->attributes()->jid,
                        'name' => $item->attributes()->name ?: '',
                    );
                }
            }
        }
    }

    /**
     * Join a MUC Room.
     *
     * @param string $roomJid Room to join.
     * @param string $nick Nickname to join as.
     * @param boolean $overRideReservedNick Override the server assigned nickname.
     * @return boolean
     */
    public function join($roomJid, $nick, $overRideReservedNick = false)
    {
        // If we shouldn't over ride the reserved nick, check to see if one is set.
        if (!$overRideReservedNick) {
            // Make a request to see if we have a reserved nick name in the room that we want to join.
            $reservedNick = $this->requestReservedNickname($roomJid);

            if (!is_null($reservedNick)) {
                $nick = $reservedNick;
            }
        }

        // Attempt to enter the room by sending it a presence element.
        $message =
            "<presence from='" . $this->username . '@' . $this->realm
            . '/' . $this->resource . "' to='" . $roomJid . '/' . $nick
            . "'><x xmlns='http://jabber.org/protocol/muc'/></presence>"
        ;
        $this->stream->send($message);
        //$this->logger->debug('Attempting to join the room ' . $roomJid);

        // Should now get a list of presences back containing the details of all the other occupants of the room.
        $response = false;
        while (!$response) {
            $response = $this->waitForServer('presence');
        }
        $this->logResponse($response, 'Joining response');

        // Room has now been joined, if it isn't the array of joinedRooms, add it
        if (!in_array($roomJid, $this->joinedRooms)) {
            $this->joinedRooms[] = $roomJid;
        }

        return true;
    }

    /**
     * Checks if the server has a reserved nickname for this user in the given room.
     *
     * @param string $roomJid Given room the check the reserved nicknames for.
     *
     * @return string
     */
    protected function requestReservedNickname($roomJid)
    {
        $message =
            "<iq from='" . $this->username . '@' . $this->realm . '/'
            . $this->resource . "' id='" . uniqid() . "' "
            . "to='" . $roomJid . "' type='get'>"
            . "<query xmlns='http://jabber.org/protocol/disco#info' "
            . "node='x-roomuser-item'/></iq>"
        ;
        $this->stream->send($message);
        //$this->logger->debug('Querying for reserved nickname in ' . $roomJid);

        // Wait for iq response
        $response = false;
        while (!$response) {
            $response = $this->waitForServer('iq');
        }
        $this->logResponse($response, 'Reserved nicknames response');

        // If query isn't empty then the user does have a reserved nickname.
        if (isset($response->query) && count($response->query->children()) > 0 && isset($response->query->identity)) {
            $reservedNick = $response->query->identity->attributes()->name;
        } else {
            $reservedNick = null;
        }

        return $reservedNick;
    }

    /**
     * Sends a message.
     *
     * @param string $to Intended recipient of the message.
     * @param string $text Contents of the message.
     *
     * @return boolean
     */
    public function message($to, $text)
    {
        // Get the first part of the JID
        $toExploded = explode("/", $to);
        $firstPart = array_shift($toExploded);

        if (in_array($firstPart, $this->joinedRooms)) {
            $type = 'groupchat';
            $to = $firstPart;
        } else {
            $type = 'normal';
        }

        $message =
            "<message to='" . $to . "' from='" . $this->username . '@'
            . $this->realm . '/' . $this->resource . "' type='" . $type
            . "' xml:lang='en'><body>" . $this->encode($text)
            . "</body></message>"
        ;
        $this->stream->send($message);

        return true;
    }

    /**
     * Encodes text for XML.
     *
     * @param string $text
     * @return string
     * @todo use DOMDocument class instead and remove this method.
     */
    protected function encode($text)
    {
        return $text;
    }

    /**
     * @param string $to jid
     * @param string $html Html contents of the message
     * @param string $fallbackText Plain text contents of the message
     * @return bool
     */
    public function htmlMessage($to, $html, $fallbackText)
    {
        // Get the first part of the JID
        $toExploded = explode("/", $to);
        $firstPart = array_shift($toExploded);

        if (in_array($firstPart, $this->joinedRooms)) {
            $type = 'groupchat';
            $to = $firstPart;
        } else {
            $type = 'normal';
        }

        $message = "<message to='" . $to . "' from='" . $this->username . '@'
            . $this->realm . '/' . $this->resource . "' type='" . $type
            . "' xml:lang='en'><html xmlns='http://jabber.org/protocol/xhtml-im'>"
            . "<body xmlns='http://www.w3.org/1999/xhtml'>{$html}</body></html><body>"
            . $this->encode($fallbackText)
            . "</body></message>";
        $this->stream->send($message);

        return true;
    }

    /**
     * Send a ping to the server.
     *
     * @param string $to
     * @return void
     */
    public function ping($to)
    {
        $iq = new Iq(array(
            'from' => $this->getFrom(),
            'id'   => uniqid(),
            'to'   => $to,
            'type' => 'get',
        ));
        $iq->initDom(new DOMElement('ping', null, 'urn:xmpp:ping'));

        $this->stream->send((string) $iq);
    }

    /**
     * Send a response to a ping.
     *
     * @param string $to Who the response is being sent back to.
     * @param string $id The ID from the original ping.
     * @return void
     */
    public function pong($to, $id)
    {
        $iq = new Iq(array(
            'from' => $this->getFrom(),
            'id'   => $id,
            'to'   => $to,
            'type' => 'result',
        ));

        $this->stream->send((string) $iq);
    }

    /**
     * @return string
     */
    public function getFrom()
    {
        return ($this->username . '@' . $this->realm . ($this->resource ? "/{$this->resource}" : ''));
    }

    /**
     * @param SimpleXMLElement|false $response
     * @param $messageType
     * @return void
     */
    public function logResponse($response, $messageType)
    {
        if ($response instanceof SimpleXMLElement) {
            //$this->logger->debug("{$messageType} received: {$response->asXML()}");
        } else {
            if ($response) {
                //$this->logger->debug("{$messageType} received (not a SimpleXMLElement object): {$response}");
            } else {
                //$this->logger->error("{$messageType} not received.");
            }
        }
    }
}
