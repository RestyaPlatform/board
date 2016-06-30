/**
 * @fileOverview This file has functions related to board custom background view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardCustomBackground View
 * @class BoardCustomBackgroundView
 * @constructor
 * @extends Backbone.View
 */
App.BoardCustomBackgroundView = Backbone.View.extend({
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
    template: JST['templates/board_custom_background'],
    tagName: 'div',
    className: 'js-change-custom-background board-background-select',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board_background: this.model
        }));
        this.showTooltip();
        return this;
    }
});
