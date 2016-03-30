if (typeof App === 'undefined') {
    App = {};
}
/**
 * ElasticSearch Collection
 * @class ElasticSearchCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ElasticSearchCollection = Backbone.Collection.extend({
    model: App.ElasticSearch
});
