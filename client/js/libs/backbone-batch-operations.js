(function() {
    Backbone.BatchCollection = Backbone.Collection.extend({
        isNew: function() {
            var isNew = this.all(function(model) {
                return !_.has(model, 'id');
            });
            return isNew;
        },
        isChanged: function() {
            var isChanged = this.some(function(model) {
                return model.hasChanged();
            });
            return isChanged;
        },
        save: function(options) {
            // initialize options
            if (_.isUndefined(options)) {
                options = {};
            }
            _.defaults(options, {
                url: _.result(this, 'url'),
                contentType: 'application/json',
                silent: false,
                data: this.toJSON()
            });

            // check collection status
            if (this.isEmpty()) {
                return this.batchDelete(options);
            }
            else if (this.isNew()) {
                return this.batchAdd(options);
            }
            else {
                return this.batchUpdate(options);
            }
        },
        batch: function(options) {
            // create parameters
            var ajaxOptions = {
                type: options.type,
                url: options.url,
                data: JSON.stringify(options.data),
                contentType: options.contentType,
                success: options.success,
                error: options.error,
                complete: options.complete,
                context: this
            };

            // batch update models
            var xhr = $.ajax(ajaxOptions)

            xhr.done(function(res) {
                if (!options.silent) {
                    this.trigger('sync', this.models);
                }
            });

            // fire request event
            if (!options.silent) {
                this.trigger('request', this.models);
            }

            return xhr;
        },
        batchDelete: function(options) {
            if (_.isUndefined(options.type)) {
                options.type = 'PUT';
            }
            return this.batch(options);
        },
        batchUpdate: function(options) {
            if (_.isUndefined(options.type)) {
                options.type = 'PUT';
            }
            return this.batch(options);
        },
        batchAdd: function(options) {
            if (_.isUndefined(options.type)) {
                options.type = 'POST';
            }
            return this.batch(options);
        }
    });

    _.extend(Backbone.BatchCollection.prototype, Backbone.Event);
}).call(this);