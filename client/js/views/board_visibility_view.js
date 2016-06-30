/**
 * @fileOverview This file has functions related to board visibility view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardVisibility View
 * @class BoardVisibilityView
 * @constructor
 * @extends Backbone.View
 */
App.BoardVisibilityView = Backbone.View.extend({
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
    template: JST['templates/board_visibility'],
    tagName: 'ul',
    className: 'list-unstyled',
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
