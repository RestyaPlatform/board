<?php

namespace Xmpp;

use DOMElement;
use DOMDocument;

/**
 * Represents an <iq /> XMPP Stanza.
 */
class Iq extends Stanza
{
    /**
     * @param string $namespaceURI
     * @param string $nodeName
     * @param array $nodeAttributes
     * @param string $reason
     * @return $this
     */
    public function initQuery($namespaceURI, $nodeName, array $nodeAttributes = array(), $reason = '')
    {
        $query = new DOMElement('query', null, $namespaceURI);
        $this->initDom($query);

        if (!empty($nodeName)) {
            $node = new DOMElement($nodeName);
            $query->appendChild($node);

            foreach ($nodeAttributes as $name => $value) {
                $node->setAttribute($name, $value);
            }

            if (!empty($reason)) {
                $node->appendChild(new DOMElement('reason', $reason));
            }
        }

        return $this;
    }

    /**
     * @param DOMElement $query
     * @return DOMDocument
     */
    public function initDom(DOMElement $query = null)
    {
        if (empty($this->dom)) {
            $this->setNewDom();

            $xmlRoot = $this->dom->createElement('iq');

            if ($this->getFrom()) {
                $xmlRoot->setAttribute('from', $this->getFrom());
            }
            if ($this->getId()) {
                $xmlRoot->setAttribute('id', $this->getId());
            }
            if ($this->getTo()) {
                $xmlRoot->setAttribute('to', $this->getTo());
            }
            if ($this->getType()) {
                $xmlRoot->setAttribute('type', $this->getType());
            }

            $this->dom->appendChild($xmlRoot);

            if ($query) {
                $xmlRoot->appendChild($query);
            }
        }

        return $this->dom;
    }
}
