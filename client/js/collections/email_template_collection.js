if (typeof App === 'undefined') {
    App = {};
}
/**
 * Email Template Collection
 * @class EmailTemplateCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.EmailTemplateCollection = Backbone.Collection.extend({
    model: App.EmailTemplate
});
