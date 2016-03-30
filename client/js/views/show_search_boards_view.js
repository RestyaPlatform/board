/**
 * @fileOverview This file has functions related to show search boards view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model.
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
App.ShowSearchBoardsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.style = options.style;
        this.render();
    },
    template: JST['templates/show_search_boards'],
    tagName: 'li',
    className: '',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board: this.model,
            style: this.style
        }));
        this.showTooltip();
        return this;
    }
});
