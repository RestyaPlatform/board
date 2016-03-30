/**
 * @fileOverview This file has functions related to board sidebar view. This view calling from apllication view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardSidebar View
 * @class BoardSidebarView
 * @constructor
 * @extends Backbone.View
 */
App.BoardSidebarView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/board_sidebar'],
    tagName: 'ul',
    className: 'dropdown-menu arrow arrow-right col-xs-12 js-setting-response',
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
            subscriber: this.model.board_subscriber,
        }));
        this.showTooltip();
        return this;
    }
});
