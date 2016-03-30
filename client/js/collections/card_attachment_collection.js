if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card Attachment Collection
 * @class CardAttachmentCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardAttachmentCollection = Backbone.Collection.extend({
    model: App.CardAttachment
});
