// http://nshipster.com/method-swizzling/
// HTMLElement Swizzle - To swizzle a method is to change a class’s dispatch table in order to resolve messages from an existing selector to a different implementation, while aliasing the original method implementation to a new selector.

// 3.2.3 HTML element constructors
// https://html.spec.whatwg.org/multipage/dom.html#html-element-constructors
// Satisfy Element interface document.createElement
//   - https://dom.spec.whatwg.org/#concept-element-interface


//// base class to extend, same trick as before
//class HTMLCustomElement extends HTMLElement {

//  constructor(_)
//    { return (_ = super(_)).init(), _; }

//  init()
//    { /* override as you like */ }
//}

var HTMLElement =

/*
// Domenic discusses
// https://esdiscuss.org/topic/extending-an-es6-class-using-es5-syntax#content-1
I believe this will work in most cases:

function B() {
  const obj = new A();
  Object.setPrototypeOf(obj, new.target.prototype); // or B.prototype, but if you derive from B you'll have to do this dance again

  // use obj instead of this

  return obj;
}
Also, in general you should do

instead of

B.prototype = Object.create(A.prototype);
for slightly better semantics, including class-side inheritance and not clobbering .constructor.
*/

( function (_) {
  function E () {}

  E.prototype =
  // E.prototype.__proto__ = ???
  // https://github.com/visionmedia/supertest/blob/master/lib/agent.js

    window.HTMLElement.prototype

  // Prevent `.constructor` clobbering
  // E.__proto__ = window.HTMLElement

    // https://github.com/whatwg/html/issues/1704
    // E.prototype.__proto__
    //   = (E.__proto__ = HTMLElement).prototype

    // Domenic's method
    // Object
    //   .setPrototypeOf
    //     (Object.setPrototypeOf (B, A).prototype, A.prototype)

    return E
})()

var TokenList = function (node) {
  var this$1 = this;


  var
    visit = function (node) { return node.attributes && [].slice
         .call (node.attributes)
         .map(collect)
      || collect (node); }

  , collect = function (node) { return /{(\w+|#)}/.test (node.textContent)
        && (node.text = node.textContent)
            .match (/[^{]+(?=})/g)
            .map (function (symbol) { return (this$1 [symbol] || (this$1 [symbol] = [])).push (node); }); }

  , walker =
      document.createNodeIterator
        (node, NodeFilter.SHOW_ELEMENT | NodeFilter.SHOW_TEXT, visit, null)

  while (walker.nextNode ()) { null } // Walk all nodes and do nothing.
};


TokenList.prototype.bind = function (context) {

  var
    tokenize = function (symbol) { return function (node) { return (node.textContent
        = node.textContent
        .split ('{'+symbol+'}')
        .join(context [symbol])); }; }

  for (var symbol in this)
    { symbol != 'bind'
      && this [symbol].map
        (function (node) { return (node.textContent = node.text) && node; }) }

  for (var symbol$1 in this)
    { symbol$1 != 'bind'
      && this [symbol$1].map
        (tokenize (symbol$1)) } // more than one occurrence
};

// https://codereview.chromium.org/1987413002
// https://github.com/whatwg/fetch/pull/442
// https://chromium.googlesource.com/chromium/src.git/+/a5a314d3249ecf1c291b417fbe067e8c2a65fad2
//
// Link rel preload as attribute doesn't support the as=document value
// https://bugs.chromium.org/p/chromium/issues/detail?id=593267
//
// Requests with useStreamOnResponse flag don't reuse preloaded resources
// https://bugs.chromium.org/p/chromium/issues/detail?id=652228
//
// Spurious warning preloading script
// https://bugs.chromium.org/p/chromium/issues/detail?id=655698
//
// WPT
// https://github.com/w3c/web-platform-tests/pull/4505
//
// w3c preload Tighter definition of "load was successful"
// https://github.com/w3c/preload/issues/83
void ( function (_) {

  //create an observer instance
  // Can always default to DOMContentLoaded
  // https://bugs.webkit.org/show_bug.cgi?id=38995#c26
  (new MutationObserver ( function (mutations) {

    for (var i$1 = 0, list$1 = mutations; i$1 < list$1.length; i$1 += 1)
      {
      var mutation = list$1[i$1];

      for (var i = 0, list = mutation.addedNodes; i < list.length; i += 1) {
         var node = list[i];

          /^p/.test (node.rel)
           && /\-/.test (node.id)
           && load (node)

         !! /\-/.test (node.localName)
           && (link = document.querySelector ('#'+node.localName))
           && link.content
           && stamp.call (node, link.content)
           && customElements.upgrade (node)
      }
    }
  }))

  .observe (document.documentElement, { childList: true, subtree: true })

  void

  [].slice
    .call (document.querySelectorAll ('[rel^=pre][id~="-"]'))
    .map  (load)


  // XHR Specs
  // https://xhr.spec.whatwg.org
  // Progress events
  // https://xhr.spec.whatwg.org/#interface-progressevent
  // Loader - https://trac.webkit.org/browser/trunk/WebCore/loader/loader.cpp
  function load (link) {

    var xhr = new XMLHttpRequest

    // Destination - https://fetch.spec.whatwg.org/#requestdestination

    xhr.link   = link
    xhr.onload = onload
    // progress events won't fire unless defining before open
    xhr.open ('GET', link.href)
    xhr.responseType = 'document'
    // Max requests
    xhr.send ()
  }


  // https://github.com/w3c/preload/pull/40
  // https://bugs.webkit.org/show_bug.cgi?id=38995
  // https://www.w3.org/TR/html5/document-metadata.html#the-link-element
  function onload () {
    var
      link = this.link

    , response =
        this.response

    , anchor =
        link.nextChild

    , template =
        link.content =
           response.querySelector ('template')

    // https://www.nczonline.net/blog/2010/09/28/why-is-getelementsbytagname-faster-that-queryselectorall
    for (var i = 0, list = document.querySelectorAll (link.id); i < list.length; i += 1)
      {
      var node = list[i];

      template && stamp.call (node, template)
    }


    for (var i$1 = 0, list$1 = response.querySelectorAll ('style,link,script'); i$1 < list$1.length; i$1 += 1)
      {
      var node$1 = list$1[i$1];

      process (link, node$1, anchor)
    }
  }


  function process (link, node, anchor) {
      var
        // https://chromium.googlesource.com/chromium/src.git/+/0661feafc9a84f03b04dd3719b8aaa255dfaec63/third_party/WebKit/Source/core/loader/LinkLoader.cpp
        // HTML WhatWG scripting
        // https://html.spec.whatwg.org/multipage/scripting.html
        // https://html.spec.whatwg.org/multipage/scripting.html#prepare-a-script
        // Classic script graph - https://html.spec.whatwg.org/multipage/webappapis.html#fetch-a-classic-script
        // Module script tree - https://html.spec.whatwg.org/multipage/webappapis.html#fetch-a-module-script-tree
        // Concept Script script - https://html.spec.whatwg.org/multipage/scripting.html#concept-script-script
        as = node.getAttribute ('as')

      , clone =
          document.createElement
            ('script' == as ? as : node.localName)

      void

      // 'type' is used for data blocks (i.e. `type=text/recipe` or `type=application/x-game-data`
      // https://html.spec.whatwg.org/multipage/scripting.html#data-block
      ['id', 'rel', 'href', 'src', 'textContent', 'as', 'defer', 'crossOrigin' ]
        // setAttribute won't work for textContent and likewise explicit set for crossorigin
        .map (function (attr) { return node [attr] && attr in clone && (clone [attr] = node [attr]); })

      // use rel = 'preload stylesheet' for async
      // or use media=snuggsi => media || 'all' trick
      // loadCSS - https://github.com/filamentgroup/loadCSS
      // http://keithclark.co.uk/articles/loading-css-without-blocking-render
      'style' == as
      // https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/#markup-based-async-loader
        && (clone.rel = 'stylesheet')

      'script' == as // smelly
        && (clone.src = clone.href)

      link
        .parentNode
        .insertBefore (clone, anchor)
  }

  // Slot replacement & light DOM stamping
  // https://github.com/w3c/webcomponents/issues/288
  // https://dom.spec.whatwg.org/#slot-assigned-nodes
  function stamp (template) {
    var this$1 = this;


    template =
      document.importNode (template, true)

    var slot

    [] // distribute attributes
      .slice
      .call (template.attributes)
      .map  (function (attr) { return !   this$1.attributes [attr.name]
        &&  this$1.setAttribute (attr.name, attr.value); })


    for (var i = 0, list = this.querySelectorAll ('[slot]'); i < list.length; i += 1)
      {
      var replacement = list[i];

      (slot = (template.content || template).querySelector
       ( 'slot[name=' + replacement.getAttribute ('slot') + ']' ))

      && // this could be slow
        slot.parentNode.replaceChild (replacement, slot)
    }

    return this.innerHTML = template.innerHTML
  }

}) ()

var Template = function (template) {

  var
    range = document.createRange ()

  template
    = typeof template == 'string'
    ? document.querySelector ( 'template[name=' + template + ']' )
    : template

  range.selectNodeContents ( template.content )

  var
    fragment = range.cloneContents ()


  template.bind = function (context) {

    range.setStartAfter  (template)
    range.deleteContents ()

    context && void []
      .concat (context)
      .map (tokenize)
      .reverse () // Range.insertNode does prepend
      .map (function (fragment) { return range.insertNode (fragment); })
  }


  function tokenize (context, index) {

    var
      clone = fragment.cloneNode (true)

    typeof context != 'object'
      && ( context  = { self: context })

    context ['#'] = index


    void (new TokenList (clone))
      .bind (context)

    return clone
  }

  return template
}

window.customElements =
  window.customElements
  || {/* microfill */}

void ( function (_) { /* CustomElementRegistry */

  customElements.define = function ( name, constructor ) {

    !! /\-/.test (name)
    && (customElements [name] = constructor)
    && [].slice
      // https://www.nczonline.net/blog/2010/09/28/why-is-getelementsbytagname-faster-that-queryselectorall
      .call ( document.querySelectorAll (name) )
      .map  ( customElements.upgrade )
  }


  // "Dmitry's Brain Transplant"
  // https://wiki.whatwg.org/wiki/Custom_Elements#Upgrading
  customElements.upgrade = function (node) {

    // Here's where we can swizzle
    // https://github.com/whatwg/html/issues/1704#issuecomment-241881091

    Object.setPrototypeOf
      (node, customElements [node.localName].prototype)

    node.connectedCallback ()
  }


  void (new MutationObserver ( function (mutations) {

    for (var i$1 = 0, list$1 = mutations; i$1 < list$1.length; i$1 += 1)
      {
      var mutation = list$1[i$1];

      for (var i = 0, list = mutation.addedNodes; i < list.length; i += 1)

         {
          var node = list[i];

          !! /\-/.test (node.localName)
         && customElements [node.localName]
         && customElements.upgrade (node)
        }
    }
  }))

  .observe (document.documentElement, { childList: true, subtree: true })

})() /* CustomElementRegistry */

var ParentNode = function (Element) { return (/*@__PURE__*/(function (Element) {
    function anonymous () {
      Element.apply(this, arguments);
    }

    if ( Element ) anonymous.__proto__ = Element;
    anonymous.prototype = Object.create( Element && Element.prototype );
    anonymous.prototype.constructor = anonymous;

    anonymous.prototype.select = function ( )
    {
    var ref;
 return (ref = this).selectAll.apply ( ref, arguments ) [0] };

  anonymous.prototype.selectAll = function ( strings ) {
    var tokens = [], len = arguments.length - 1;
    while ( len-- > 0 ) tokens[ len ] = arguments[ len + 1 ];

    strings = [ ].concat ( strings )

    return [].slice.call
      (this.querySelectorAll
        (tokens.reduce // denormalize selector
          (function (part, token) { return part + token + strings.shift (); }
          , strings.shift ())))
  };

    return anonymous;
  }(Element))); }

//  comb (parent) {
//    // ElementTraversal interface
//    // https://www.w3.org/TR/ElementTraversal/#interface-elementTraversal
//
//    if (parent.hasChildNodes())
//      for (let node = parent.firstChild; node; node = node.nextSibling)
//        comb (node)
//  }

var EventTarget = function (HTMLElement) { return (/*@__PURE__*/(function (HTMLElement) {
    function anonymous () {
      HTMLElement.apply(this, arguments);
    }

    if ( HTMLElement ) anonymous.__proto__ = HTMLElement;
    anonymous.prototype = Object.create( HTMLElement && HTMLElement.prototype );
    anonymous.prototype.constructor = anonymous;

    anonymous.prototype.on = function ( event, handler ) {

    this.addEventListener
      (event, this.renderable (handler))
  };

  anonymous.prototype.renderable = function ( handler ) {
    var this$1 = this;


    // BIG BUG IN IE!!!
    //
    // https://connect.microsoft.com/IE/feedback/details/790389/event-defaultprevented-returns-false-after-preventdefault-was-called
    //
    // https://github.com/webcomponents/webcomponents-platform/blob/master/webcomponents-platform.js#L16

    return function (event) { return handler.call (this$1, event) !== false
        // check render availability
        && event.defaultPrevented
        || this$1.render (); }
  };

//off (event, listener = 'on' + this [event])
//  // MDN EventTarget.removeEventListener
//  // https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener
//  //
//  // WHATWG Living Standard EventTarget.removeEventListener
//  // https://dom.spec.whatwg.org/#dom-eventtarget-removeeventlistener
//  //
//  // DOM Level 2 EventTarget.removeEventListener
//  // https://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-EventTarget-removeEventListener

//  { this.removeEventListener (event, listener) }

//dispatch (event)
//  // MDN EventTarget.dispatchEvent
//  // https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/dispatchEvent
//  //
//  // WHATWG Living Standard EventTarget.dispatchEvent
//  // https://dom.spec.whatwg.org/#dom-eventtarget-dispatchevent
//  //
//  // DOM Level 2 EventTarget.dispatchEvent
//  //  https://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-EventTarget-dispatchEvent

//  { }


  // Reflection - https://en.wikipedia.org/wiki/Reflection_(computer_programming)
  // Type Introspection - https://en.wikipedia.org/wiki/Type_introspection
  //
  // In computing, type introspection is the ability of a program
  // to examine the type or properties of an object at runtime.
  // Some programming languages possess this capability.
  //
  // Introspection should not be confused with reflection,
  // which goes a step further and is the ability for a program to manipulate the values,
  // meta-data, properties and/or functions of an object at runtime.


  anonymous.prototype.reflect = function (handler) {

    /^on/.test (handler) // is a W3C `on`event
      && handler in HTMLElement.prototype // `on*`

      && // automagically delegate event
        this.on ( handler.substr (2), this [handler] )
  };


  anonymous.prototype.register = function (node, handler, event) {
    for (var i = 0, list = [].slice.call (node.attributes); i < list.length; i += 1)
            {
      var attribute = list[i];

      /^on/.test (event = attribute.name)
            // https://www.quirksmode.org/js/events_tradmod.html
            // because under traditional registration the handler value is wrapped in scope `{ onfoo }`
            && ( handler = (/{\s*(\w+)/.exec (node [event]) || []) [1])
            && ( node [event] = this.renderable (this [handler]) )
    }
  };

    return anonymous;
  }(HTMLElement))); }

var GlobalEventHandlers = function (Element) { return (/*@__PURE__*/(function (Element) {
    function anonymous () {
      Element.apply(this, arguments);
    }

    if ( Element ) anonymous.__proto__ = Element;
    anonymous.prototype = Object.create( Element && Element.prototype );
    anonymous.prototype.constructor = anonymous;

    anonymous.prototype.onconnect = function (event) {

    this.templates =
      this
        .selectAll ('template[name]')
        .map (Template)

    this.tokens =
      new TokenList (this)

    Element.prototype.onconnect
      && Element.prototype.onconnect.call (this, event)
  };

    return anonymous;
  }(Element))); }
var Custom = function (Element) { return ( /*@__PURE__*/(function (superclass) {
    function anonymous () {
      superclass.apply(this, arguments);
    }

    if ( superclass ) anonymous.__proto__ = superclass;
    anonymous.prototype = Object.create( superclass && superclass.prototype );
    anonymous.prototype.constructor = anonymous;

    anonymous.prototype.connectedCallback = function () {
    this.context = {}

    superclass.prototype.initialize
      && superclass.prototype.initialize.call (this)

    Object
      .getOwnPropertyNames (Element.prototype)
      .map (this.reflect, this)

    this.addEventListener
      ('connect', this.onconnect)
 
    this.addEventListener.call
      (this, 'idle', superclass.prototype.onidle)

    this.dispatchEvent
      (new Event ('connect'))

    this.render ()
  };


  anonymous.prototype.upgrade = function () {

  };


  anonymous.prototype.render = function () {

    for (var i = 0, list = this.templates; i < list.length; i += 1)
      {
      var template = list[i];

      template.bind
        (this [template.getAttribute ('name')])
    }

    this
      .tokens
      .bind (this)

    this.register (this)

    this
      // possibly restrict to elements with on event
      .selectAll ('*')
      .map (this.register, this)

    this.dispatchEvent
      (new Event ('idle'))
  };

    return anonymous;
  }(( ParentNode
  ( EventTarget
  ( GlobalEventHandlers
  ( Element ))))))); }

// http://2ality.com/2013/09/window.html
// http://tobyho.com/2013/03/13/window-prop-vs-global-var

var Element = function (tag) { return (

//      const constructor =// swizzle
//        typeof tag === 'string'
//    //    ? HTMLCustomElement
//    //    : HTMLElement

        //https://gist.github.com/allenwb/53927e46b31564168a1d
        // https://github.com/w3c/webcomponents/issues/587#issuecomment-271031208
        // https://github.com/w3c/webcomponents/issues/587#issuecomment-254017839

      function (Element) { return customElements.define
          ( tag + '', Custom (Element) ); }

// Assign `window.Element.prototype` in case of feature checking on `Element`
//  E.prototype = Element.prototype
//  return E
); }

