if (typeof App === 'undefined') {
    App = {};
}
/**
 * Setting Category Collection
 * @class SettingCategoryCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.SettingCategoryCollection = Backbone.Collection.extend({
    model: App.SettingCategory,
    url: api_url + 'settings.json',
    initialize: function(id) {
        this.url = api_url + 'settings.json';
    }
});
