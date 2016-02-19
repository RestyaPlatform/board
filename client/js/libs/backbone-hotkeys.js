/*
  Backbone Hotkeys 1.10
  (c) 2012-2013 Robert Pocklington
  Backbone-hotkeys may be freely distributed under the MIT license.

  adds hotkey binding to Backbone.js
  include after backbone.js to overload default view event binding

 Example:

 App.SomeView = Backbone.View.extend({
   el:$('#some-id'),

   events: {
     'keyup[esc]             ': 'someMethod',
     'keyup[Alt+m] .a:visible': 'someMethod',
     'keyup[Alt+h]       body': 'someMethod',
     'keyup[Alt+right]   body': 'someMethod',
     'keyup[Ctrl+left]   body': 'someMethod',
     'keyup[Alt+s]       body': 'someMethod',
     'click          #some_id': 'someMethod'
   }

 });

 */

(function(jQuery) {
  // Cached regex to split keys for `delegate`.
  var delegateEventSplitter = /^(\S+)\s*(.*)$/;

  if (!jQuery.hotkeys) {
    throw new Error('Error: You have not included the jQuery Hotkeys dependency!');
  }

  Backbone.View = Backbone.View.extend({

    delegateEvents: function(events) {

      if (!(events || (events = _.result(this, 'events')))) return this;
      this.undelegateEvents();

      for (var key in events) {

        var method = events[key];
        if (!_.isFunction(method)) method = this[events[key]];
        if (!method) continue;

        var match = key.match(delegateEventSplitter);

        var eventName = match[1];
        var selector = match[2];
        var methodBound = _.bind(method, this);

        var hotkeysRegex = /(.*)\[(.*)\]/ ;
        var hotkeyEvent = eventName.match(hotkeysRegex);
        var keyCombination = null;

        if (hotkeyEvent) {
          eventName = hotkeyEvent[1];
          keyCombination = hotkeyEvent[2];
        }

        eventName += '.delegateEvents' + this.cid;

        if (!selector) {
          if (hotkeyEvent) {
            $(document).bind(eventName, keyCombination, methodBound);
          } else {
            this.$el.on(eventName, methodBound);
          }
        } else {

          if (hotkeyEvent) {

            var m = (function(selector, eventName, keyCombination, method) {
              // inner function to work around function-level variable scope
              return function() {

                // if selector defined for hotkey event, use its existence as a guard to perform the target action
                if ($(this).find(selector).length > 0) {
                  method.apply(null, arguments);
                }
              };

          }(selector, eventName, keyCombination, method));
            $(document).bind(eventName, keyCombination, m);
          } else {
            this.$el.on(eventName, selector, methodBound);
          }
        } // end loop
      }
      return this;
    },

    // removes any global bindings made in this view
    undelegateHotkeyGlobalEvents: function() {
      var view_events = '.delegateEvents' + this.cid;
      $(document).off(view_events);
    }
  });

  var stopListening = Backbone.View.prototype.stopListening;

  // automatically undelegate global hotkey events as part of view cleanup
  Backbone.View = Backbone.View.extend({
    stopListening: function(obj, name, callback) {
      stopListening.call(this, obj, name, callback);
      this.undelegateHotkeyGlobalEvents();
    }
  });
})(jQuery);
