<?php

namespace Xmpp;

/**
 * Represents an XMPP <message>
 */
class Message extends Stanza
{
    const TYPE_CHAT      = 'chat';
    const TYPE_ERROR     = 'error';
    const TYPE_GROUPCHAT = 'groupchat';
    const TYPE_HEADLINE  = 'headline';
    const TYPE_NORMAL    = 'normal';

    /**
     * @var array
     */
    protected $bodies = array();
    protected $error;
    protected $lang;

    /**
     * @var array
     */
    protected $subjects = array();
    protected $thread;
    protected $delayed = false;

    /**
     * Class constructor.
     *
     * @param \SimpleXMLElement $message The XML of the message.
     */
    public function __construct(\SimpleXMLElement $message)
    {

        parent::__construct($message);

        // Get the type of the message
        if (isset($message['type'])
            && ((string) $message['type'] == self::TYPE_CHAT
                || (string) $message['type'] == self::TYPE_ERROR
                || (string) $message['type'] == self::TYPE_GROUPCHAT
                || (string) $message['type'] == self::TYPE_HEADLINE)
        ) {
            $this->type = (string) $message['type'];
        } else {
            $this->type = self::TYPE_NORMAL;
        }

        if ($this->type == self::TYPE_ERROR) {
            if (isset($message->error[0])) {
                $this->error = (string) $message->error[0];
            } else {
                $this->error = '';
            }
        }

        if (isset($message['xml:lang'])) {
            $this->lang = (string) $message['xml:lang'];
        }

        foreach ($message->subject as $subject) {
            $thisSubject = array(
                'content' => (string) $subject,
            );

            if (isset($subject['xml:lang'])) {
                $thisSubject['lang'] = (string) $subject['xml:lang'];
            }

            $this->subjects[] = $thisSubject;
        }

        foreach ($message->body as $body) {
            $thisBody = array(
                'content' => (string) $body,
            );

            if (isset($body['xml:lang'])) {
                $thisBody['lang'] = (string) $body['xml:lang'];
            }

            $this->bodies[] = $thisBody;
        }

        if (isset($message->delay[0])) {
            $this->delayed = true;
        }

        if (isset($message->thread[0])) {
            $this->thread = (string) $message->thread[0];
        } else {
            $this->thread = '';
        }
    }

    /**
     * Gets the bodies contained in the message.
     *
     * @return array
     */
    public function getBodies()
    {
        return $this->bodies;
    }

    /**
     * Gets the error associated with this message.
     *
     * @return type
     */
    public function getError()
    {
        return $this->error;
    }

    /**
     * Gets the language of the message.
     *
     * @return type
     */
    public function getLang()
    {
        return $this->lang;
    }

    /**
     * Gets the subjects of the message.
     *
     * @return array
     */
    public function getSubjects()
    {
        return $this->subjects;
    }

    /**
     * Gets the thread the message is associated with.
     *
     * @return type
     */
    public function getThread()
    {
        return $this->thread;
    }

    /**
     * @return bool
     */
    public function isDelayed()
    {
        return $this->delayed;
    }
}
