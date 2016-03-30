/**
 * @fileOverview This file has functions related to starred boards listing view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * StartedBoardsListing View
 * @class StartedBoardsListingView
 * @constructor
 * @extends Backbone.View
 */
App.StartedBoardsListingView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.user = options.user;
        this.render();
    },
    template: JST['templates/started_boards_listing'],
    tagName: 'li',
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
            user: this.user
        }));
        this.showTooltip();
        return this;
    }
});
