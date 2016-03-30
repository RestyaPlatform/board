/**
 * @fileOverview This file has functions related to my boards listing view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ShowAllVisibility View
 * @class ShowAllVisibilityView
 * @constructor
 * @extends Backbone.View
 */
App.MyBoardsListingView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.authuser = options.authuser;
        this.render();
    },
    template: JST['templates/my_boards_listing'],
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
            board: this.model
        }));
        this.showTooltip();
        return this;
    }
});
