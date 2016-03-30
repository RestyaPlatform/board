if (typeof App === 'undefined') {
    App = {};
}
/**
 * Acl Board Links Collection
 * @class AclBoardLinksCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.AclBoardLinksCollection = Backbone.Collection.extend({
    model: App.AclBoardLinks
});
