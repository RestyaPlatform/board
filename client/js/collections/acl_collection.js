if (typeof App === 'undefined') {
    App = {};
}
/**
 * ACL Collection
 * @class ACLCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ACLCollection = Backbone.Collection.extend({
    model: App.ACL
});
