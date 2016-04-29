<?php

namespace Xmpp;

use DOMElement;
use DOMDocument;

/**
 * Represents an <Presence /> XMPP Stanza.
 */
class Presence extends Stanza
{
    /**
     * @param DOMElement $x
     * @return DOMDocument
     */
    public function initDom(DOMElement $x = null)
    {
        if (empty($this->dom)) {
            $this->setNewDom();

            $xmlRoot = $this->dom->createElement('presence');

            if ($this->getFrom()) {
                $xmlRoot->setAttribute('from', $this->getFrom());
            }
            if ($this->getTo()) {
                $xmlRoot->setAttribute('to', $this->getTo());
            }

            $xmlRoot->appendChild($x);

            $this->dom->appendChild($xmlRoot);
        }

        return $this->dom;
    }
}
