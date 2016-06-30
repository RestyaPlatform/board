<?php

namespace Xmpp\Xep;

use DOMElement;
use SimpleXMLElement;
use Xmpp\Presence;

/**
 * The Xmpp\Xep\Xep0045 class.
 */
class Xep0045 extends AbstractXep
{
    /**
     * @param int $roomId
     * @param string $roomNickname
     * @return boolean
     * @see http://xmpp.org/extensions/xep-0045.html#createroom
     * @todo test if failed or succeeded.
     * @todo Encode room nickname first before using it; otherwise creating room could fail because of invalid XML.
     */
    public function createRoom($roomId, $roomNickname = '')
    {
        $presence = new Presence();
        $presence
            ->setFrom($this->options['from'])
            ->setTo($this->getFullRoomId($roomId, $roomNickname))
            ->initDom(new DOMElement('x', null, 'http://jabber.org/protocol/muc'))
        ;

        $this->connection->getStream()->send($presence);

        $response = $this->connection->waitForServer('*');
        $this->connection->logResponse($response, 'Response when creating chatroom');
    }

    /**
     * @param int $roomId
     * @param string $reason
     * @return boolean
     * @see http://xmpp.org/extensions/xep-0045.html#destroyroom
     */
    public function destroyRoom($roomId, $reason = '')
    {
        $iq = $this->getIq('set')->setTo($this->getFullRoomId($roomId));
        $iq->initQuery(
            'http://jabber.org/protocol/muc#owner',
            'destroy',
            array(
                // 'jid' => $this->getFullRoomId($roomId),
            ),
            $reason
        );

        $this->connection->getStream()->send($iq);

        $response = $this->connection->waitForServer('*');
        $this->connection->logResponse($response, 'Response when destroying chatroom');
    }

    /**
     * @param int $roomId
     * @param string $name
     * @return boolean
     * @todo Not yet implemented.
     */
    public function renameRoom($roomId, $name)
    {
        $this->logger->warn('Changing XMPP chatroom names has not yet been implemented.');
    }

    /**
     * @param int $roomId
     * @param int $userId
     * @param string $reason
     * @return boolean
     * @see http://xmpp.org/extensions/xep-0045.html#grantmember
     * @todo Encode user nickname first before using it; otherwise adding user could fail because of invalid XML.
     */
    public function grantMember($roomId, $userId, $affiliation, $reason = '')
    {
        $iq = $this->getIq('set')->setTo($this->getFullRoomId($roomId));
        $iq->initQuery(
            'http://jabber.org/protocol/muc#admin',
            'item',
            array(
                'affiliation' => $affiliation,
                'jid'         => $this->getFullUserId($userId),
                // 'nick'     => null,
            ),
            $reason
        );
        $this->connection->getStream()->send($iq);
        $response = $this->connection->waitForServer('iq');
        $this->connection->logResponse($response, 'Response when granting member');
    }

    /**
     * @param int $roomId
     * @param int $userId
     * @param string $reason
     * @return boolean
     * @see http://xmpp.org/extensions/xep-0045.html#revokemember
     */
    public function revokeMember($roomId, $userId, $reason = '')
    {
        $iq = $this->getIq('set')->setTo($this->getFullRoomId($roomId));
        $iq->initQuery(
            'http://jabber.org/protocol/muc#admin',
            'item',
            array(
                'affiliation' => 'none',
                'jid'         => $this->getFullUserId($userId),
            ),
            $reason
        );

        $this->connection->getStream()->send($iq);

        $response = $this->connection->waitForServer('*');
        $this->connection->logResponse($response, 'Response when revoking member');
    }

    /**
     * @param int $roomId
     * @return array
     * @see http://xmpp.org/extensions/xep-0045.html#modifymember
     */
    public function getMemberList($roomId)
    {
        $iq = $this->getIq('get')->setTo($this->getFullRoomId($roomId));
        $iq->initQuery(
            'http://jabber.org/protocol/muc#admin',
            'item',
            array(
                'affiliation' => 'member',
            )
        );

        $this->connection->getStream()->send($iq);

        $response = $this->connection->waitForServer('*');
        $this->connection->logResponse($response, 'Response when getting member list');

        $members = array();
        if ($response instanceof SimpleXMLElement) {
            /**
             * In case when error happens, the response could be like following:
             *
             * <iq from='room_name@host' to='sender@host/resource' type='error' id='4227107239'>
             *     <query xmlns='http://jabber.org/protocol/muc#admin'>
             *         <item affiliation='member'/>
             *     </query>
             *     <error code='404' type='cancel'>
             *         <item-not-found xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
             *         <text xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'>Conference room does not exist</text>
             *     </error>
             * </iq>
             */
            foreach ($response->query->item as $item) {
                if (isset($item['jid'])) {
                    $jid = (string) $item['jid'];
                    $members[substr($jid, 0, strpos($jid, '@'))] = (string) $item['affiliation'];
                }
            }
        }

        return $members;
    }

	/**
     * @param xml $iq
     * @return boolean
     */
	public function changePassword($iq)
    {
        $this->connection->getStream()->send($iq);
        $response = $this->connection->waitForServer('*');
    }

	/**
     * @param xml $iq
     * @return boolean
     */
	public function deleteUser($iq)
    {
        $this->connection->getStream()->send($iq);
        $response = $this->connection->waitForServer('*');
    }
}
