if (typeof App === 'undefined') {
    App = {};
}
/**
 * Attachment Collection
 * @class AttachmentCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.AttachmentCollection = Backbone.Collection.extend({
    model: App.Attachment,
    saved: function() {
        return this.reject(function(attachment) {
            return attachment.isNew();
        });
    }
});
