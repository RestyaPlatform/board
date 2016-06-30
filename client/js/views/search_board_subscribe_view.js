/**
 * @fileOverview This file has functions related to show search board subscribe view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
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
App.ShowSearchBoardSubscribeView = Backbone.View.extend({
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
    //template: JST['templates/show_search_board_subscribe'],
    tagName: 'span',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.showTooltip();
        return this;
    }
});
