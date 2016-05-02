<?php

namespace Xmpp\Xep;

use Psr\Log\LoggerInterface;
use Xmpp\Connection;
use Xmpp\Exception\XmppException;
use Xmpp\Iq;

/**
 * The Xmpp\Xep\AbstractXep class.
 */
abstract class AbstractXep
{
    /**
     * @var array
     */
    protected $options = array(
        'from'      => null,
        // 'id'     => null,
        'realm'     => null,
        'mucServer' => null,
    );

    /**
     * @var Connection
     */
    protected $connection;

    /**
     * @var LoggerInterface
     */
    protected $logger;

    /**
     * @param array $options List of options:
     *   # username:
     *   # password:
     *   # host: e.g., example.com
     *   # ssl: Boolean TRUE or FALSE
     *   # port: e.g., 5222
     *   # resource: For heavy loaded server, suggest it make it unique for each call. e.g., "uniqid('', true)".
     *   # mucServer: If not specified, it will query against the XMPP server to get MUC server. Suggesting to provide
     *                it for performance reason.
     * @param LoggerInterface $logger
     * @throws XmppException
     */
    public function __construct(array $options, LoggerInterface $logger = null)
    {
        $this->logger = $logger;

        $this->connection = new Connection(
            $options['username'],
            $options['password'],
            $options['host'],
            $options['ssl'],
            $options['port'],
            $options['resource'],
            $this->logger
        );

        // $this->options['id'] = substr($options['username'], 0, strpos($options['username'], '@'));
        $this->options['realm'] = substr($options['username'], strpos($options['username'], '@') + 1);
        $this->options['from']  = $this->getFullUserId(
            substr($options['username'], 0, strpos($options['username'], '@')), // $this->options['id'],
            '' // $options['resource']
        );

        $this->connection->connect();
        $this->connection->authenticate();
        $this->connection->bind();
        $this->connection->establishSession();
        // $this->connection->presence();

        $this->setMucServer(array_key_exists('mucServer', $options) ? $options['mucServer'] : null);
    }

    /**
     * @return void
     */
    public function __destruct()
    {
        $this->connection->disconnect();
    }

    /**
     * @param string $host
     * @return $this
     * @throws XmppException
     */
    public function setMucServer($host = null)
    {
        if (!empty($host)) {
            $this->options['mucServer'] = $host;
        } else {
            if ($this->connection->isMucSupported()) {
                $this->options['mucServer'] = $this->connection->getMucServer();
            } else {
                $this->logger->critical('XMPP server seems not supporting MUC.');

                throw new XmppException('Chatting functionality is not available for now.');
            }
        }

        return $this;
    }

    /**
     * @param string $userId
     * @param string $resource
     * @return string
     */
    public function getFullUserId($userId, $resource = '')
    {
        return ($userId . '@' . $this->options['realm'] . ($resource ? "/{$resource}" : ''));
    }

    /**
     * @param string $roomId
     * @param string $nickname
     * @return string
     */
    public function getFullRoomId($roomId, $nickname = '')
    {
        return ($roomId . '@' . $this->options['mucServer'] . ($nickname ? "/{$nickname}" : ''));
    }

    /**
     * @param string $type
     * @return Iq
     */
    protected function getIq($type = null)
    {
        $iq = new Iq($this->options);

        if (isset($type)) {
            $iq->setType($type);
        }

        return $iq;
    }

    /**
     * Disconnect from the server.
     *
     * @return void
     */
    public function disconnect()
    {
        $this->getConnection->disconnect();
    }

    /**
     * @return Connection
     */
    public function getConnection()
    {
        return $this->connection;
    }
}
