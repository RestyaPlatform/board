/*!
 * Backbone.Overview 
 *
 * Copyright (c) 2014, JC Brand <jc@opkode.com>
 * Licensed under the Mozilla Public License (MPL) 
 */
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define(["underscore", "backbone"], factory);
   } else {
      // RequireJS isn't being used.
      // Assume underscore and backbone are loaded in <script> tags
        factory(_ || root._, Backbone || root.Backbone);
   }
}(this, function (_, Backbone) {
    "use strict";
    var Overview = Backbone.Overview = function (options) {
        /* An Overview is a View that contains and keeps track of sub-views.
         * Kind of like what a Collection is to a Model.
         */
        this.views = {};
        this.keys = _.partial(_.keys, this.views);
        this.getAll = _.partial(_.identity, this.views);
        this.get = function (id) { return this.views[id]; }.bind(this);
        this.add = function (id, view) {
            this.views[id] = view;
            return view;
        }.bind(this);
        this.remove = function (id) {
            if (typeof id === "undefined") {
                new Backbone.View().remove.apply(this);
            }
            var view = this.views[id];
            if (view) {
                delete this.views[id];
                view.remove();
                return view;
            }
        }.bind(this);
        this.removeAll = function () {
            _.each(_.keys(this.views), this.remove);
        }.bind(this);
        Backbone.View.apply(this, Array.prototype.slice.apply(arguments));
    };

    var methods = ['forEach', 'each', 'map', 'collect', 'reduce', 'foldl',
        'inject', 'reduceRight', 'foldr', 'find', 'detect', 'filter', 'select',
        'reject', 'every', 'all', 'some', 'any', 'include', 'contains', 'invoke',
        'max', 'min', 'toArray', 'size', 'first', 'head', 'take', 'initial', 'rest',
        'tail', 'drop', 'last', 'without', 'difference', 'indexOf', 'shuffle',
        'lastIndexOf', 'isEmpty', 'chain', 'sample'];
    // Mix in each Underscore method as a proxy to `Overview#view`.
    _.each(methods, function(method) {
        Overview.prototype[method] = function() {
            var args = Array.prototype.slice.call(arguments);
            args.unshift(this.views);
            return _[method].apply(_, args);
        };
    });
    _.extend(Overview.prototype, Backbone.View.prototype);
    Overview.extend = Backbone.View.extend;
    return Backbone.Overview;
}));
