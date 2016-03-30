/**
 * @fileOverview This file has functions related to search result view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: JSON Object.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * SearchResult View
 * @class SearchResultView
 * @constructor
 * @extends Backbone.View
 */
App.SearchResultView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/search_result'],
    tagName: 'ul',
    className: 'unstyled',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            hits: this.model
        }));
        this.showTooltip();
        return this;
    }
});
