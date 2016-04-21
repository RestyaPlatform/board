/**
 * @fileOverview This file has functions related to search page result view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Search Page Result View
 * @class SearchPageResultView
 * @constructor
 * @extends Backbone.View
 */
App.SearchPageResultView = Backbone.View.extend({
    template: JST['templates/search_page_result'],
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            search_result: this.model.result
        }));
        this.showTooltip();
        return this;
    }
});
